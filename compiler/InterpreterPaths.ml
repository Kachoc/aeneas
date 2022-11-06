module T = Types
module V = Values
module E = Expressions
module C = Contexts
module Subst = Substitute
module L = Logging
open Cps
open TypesUtils
open ValuesUtils
open InterpreterUtils
open InterpreterBorrowsCore
open InterpreterBorrows
open InterpreterExpansion
module Synth = SynthesizeSymbolic

(** The local logger *)
let log = L.paths_log

(** Paths *)

(** When we fail reading from or writing to a path, it might be because we
    need to update the environment by ending borrows, expanding symbolic
    values, etc. The following type is used to convey this information.
    
    TODO: compare with borrow_lres?
*)
type path_fail_kind =
  | FailSharedLoan of V.BorrowId.Set.t
      (** Failure because we couldn't go inside a shared loan *)
  | FailMutLoan of V.BorrowId.id
      (** Failure because we couldn't go inside a mutable loan *)
  | FailInactivatedMutBorrow of V.BorrowId.id
      (** Failure because we couldn't go inside an inactivated mutable borrow
          (which should get activated) *)
  | FailSymbolic of int * V.symbolic_value
      (** Failure because we need to enter a symbolic value (and thus need to
          expand it).
          We return the number of elements which remained in the path when we
          reached the error - this allows to retrieve the path prefix, which
          is useful for the synthesis. *)
  | FailBottom of int * E.projection_elem * T.ety
      (** Failure because we need to enter an any value - we can expand Bottom
          values if they are left values. We return the number of elements which
          remained in the path when we reached the error - this allows to
          properly update the Bottom value, if needs be.
       *)
  | FailBorrow of V.borrow_content
      (** We got stuck because we couldn't enter a borrow *)
[@@deriving show]

(** Result of evaluating a path (reading from a path/writing to a path)
    
    Note that when we fail, we return information used to update the
    environment, as well as the 
*)
type 'a path_access_result = ('a, path_fail_kind) result
(** The result of reading from/writing to a place *)

type updated_read_value = { read : V.typed_value; updated : V.typed_value }

type projection_access = {
  enter_shared_loans : bool;
  enter_mut_borrows : bool;
  lookup_shared_borrows : bool;
}

(** Generic function to access (read/write) the value at the end of a projection.

    We return the (eventually) updated value, the value we read at the end of
    the place and the (eventually) updated environment.
    
    TODO: use exceptions?
 *)
let rec access_projection (access : projection_access) (ctx : C.eval_ctx)
    (* Function to (eventually) update the value we find *)
      (update : V.typed_value -> V.typed_value) (p : E.projection)
    (v : V.typed_value) : (C.eval_ctx * updated_read_value) path_access_result =
  (* For looking up/updating shared loans *)
  let ek : exploration_kind =
    { enter_shared_loans = true; enter_mut_borrows = true; enter_abs = true }
  in
  match p with
  | [] ->
      let nv = update v in
      (* Type checking *)
      if nv.ty <> v.ty then (
        log#lerror
          (lazy
            ("Not the same type:\n- nv.ty: " ^ T.show_ety nv.ty ^ "\n- v.ty: "
           ^ T.show_ety v.ty));
        raise
          (Failure
             "Assertion failed: new value doesn't have the same type as its \
              destination"));
      Ok (ctx, { read = v; updated = nv })
  | pe :: p' -> (
      (* Match on the projection element and the value *)
      match (pe, v.V.value, v.V.ty) with
      | ( Field (((ProjAdt (_, _) | ProjOption _) as proj_kind), field_id),
          V.Adt adt,
          T.Adt (type_id, _, _) ) -> (
          (* Check consistency *)
          (match (proj_kind, type_id) with
          | ProjAdt (def_id, opt_variant_id), T.AdtId def_id' ->
              assert (def_id = def_id');
              assert (opt_variant_id = adt.variant_id)
          | ProjOption variant_id, T.Assumed T.Option ->
              assert (Some variant_id = adt.variant_id)
          | _ -> raise (Failure "Unreachable"));
          (* Actually project *)
          let fv = T.FieldId.nth adt.field_values field_id in
          match access_projection access ctx update p' fv with
          | Error err -> Error err
          | Ok (ctx, res) ->
              (* Update the field value *)
              let nvalues =
                T.FieldId.update_nth adt.field_values field_id res.updated
              in
              let nadt = V.Adt { adt with V.field_values = nvalues } in
              let updated = { v with value = nadt } in
              Ok (ctx, { res with updated }))
      (* Tuples *)
      | Field (ProjTuple arity, field_id), V.Adt adt, T.Adt (T.Tuple, _, _) -> (
          assert (arity = List.length adt.field_values);
          let fv = T.FieldId.nth adt.field_values field_id in
          (* Project *)
          match access_projection access ctx update p' fv with
          | Error err -> Error err
          | Ok (ctx, res) ->
              (* Update the field value *)
              let nvalues =
                T.FieldId.update_nth adt.field_values field_id res.updated
              in
              let ntuple = V.Adt { adt with field_values = nvalues } in
              let updated = { v with value = ntuple } in
              Ok (ctx, { res with updated })
          (* If we reach Bottom, it may mean we need to expand an uninitialized
           * enumeration value *))
      | Field ((ProjAdt (_, _) | ProjTuple _ | ProjOption _), _), V.Bottom, _ ->
          Error (FailBottom (1 + List.length p', pe, v.ty))
      (* Symbolic value: needs to be expanded *)
      | _, Symbolic sp, _ ->
          (* Expand the symbolic value *)
          Error (FailSymbolic (1 + List.length p', sp))
      (* Box dereferencement *)
      | ( DerefBox,
          Adt { variant_id = None; field_values = [ bv ] },
          T.Adt (T.Assumed T.Box, _, _) ) -> (
          (* We allow moving inside of boxes. In practice, this kind of
           * manipulations should happen only inside unsage code, so
           * it shouldn't happen due to user code, and we leverage it
           * when implementing box dereferencement for the concrete
           * interpreter *)
          match access_projection access ctx update p' bv with
          | Error err -> Error err
          | Ok (ctx, res) ->
              let nv =
                {
                  v with
                  value =
                    V.Adt { variant_id = None; field_values = [ res.updated ] };
                }
              in
              Ok (ctx, { res with updated = nv }))
      (* Borrows *)
      | Deref, V.Borrow bc, _ -> (
          match bc with
          | V.SharedBorrow (_, bid) ->
              (* Lookup the loan content, and explore from there *)
              if access.lookup_shared_borrows then
                match lookup_loan ek bid ctx with
                | _, Concrete (V.MutLoan _) ->
                    raise (Failure "Expected a shared loan")
                | _, Concrete (V.SharedLoan (bids, sv)) -> (
                    (* Explore the shared value *)
                    match access_projection access ctx update p' sv with
                    | Error err -> Error err
                    | Ok (ctx, res) ->
                        (* Update the shared loan with the new value returned
                           by {!access_projection} *)
                        let ctx =
                          update_loan ek bid
                            (V.SharedLoan (bids, res.updated))
                            ctx
                        in
                        (* Return - note that we don't need to update the borrow itself *)
                        Ok (ctx, { res with updated = v }))
                | ( _,
                    Abstract
                      ( V.AMutLoan (_, _)
                      | V.AEndedMutLoan
                          { given_back = _; child = _; given_back_meta = _ }
                      | V.AEndedSharedLoan (_, _)
                      | V.AIgnoredMutLoan (_, _)
                      | V.AEndedIgnoredMutLoan
                          { given_back = _; child = _; given_back_meta = _ }
                      | V.AIgnoredSharedLoan _ ) ) ->
                    raise (Failure "Expected a shared (abstraction) loan")
                | _, Abstract (V.ASharedLoan (bids, sv, _av)) -> (
                    (* Explore the shared value *)
                    match access_projection access ctx update p' sv with
                    | Error err -> Error err
                    | Ok (ctx, res) ->
                        (* Relookup the child avalue *)
                        let av =
                          match lookup_loan ek bid ctx with
                          | _, Abstract (V.ASharedLoan (_, _, av)) -> av
                          | _ -> raise (Failure "Unexpected")
                        in
                        (* Update the shared loan with the new value returned
                             by {!access_projection} *)
                        let ctx =
                          update_aloan ek bid
                            (V.ASharedLoan (bids, res.updated, av))
                            ctx
                        in
                        (* Return - note that we don't need to update the borrow itself *)
                        Ok (ctx, { res with updated = v }))
              else Error (FailBorrow bc)
          | V.InactivatedMutBorrow (_, bid) ->
              Error (FailInactivatedMutBorrow bid)
          | V.MutBorrow (bid, bv) ->
              if access.enter_mut_borrows then
                match access_projection access ctx update p' bv with
                | Error err -> Error err
                | Ok (ctx, res) ->
                    let nv =
                      {
                        v with
                        value = V.Borrow (V.MutBorrow (bid, res.updated));
                      }
                    in
                    Ok (ctx, { res with updated = nv })
              else Error (FailBorrow bc))
      | _, V.Loan lc, _ -> (
          match lc with
          | V.MutLoan bid -> Error (FailMutLoan bid)
          | V.SharedLoan (bids, sv) ->
              (* If we can enter shared loan, we ignore the loan. Pay attention
                 to the fact that we need to reexplore the *whole* place (i.e,
                 we mustn't ignore the current projection element *)
              if access.enter_shared_loans then
                match access_projection access ctx update (pe :: p') sv with
                | Error err -> Error err
                | Ok (ctx, res) ->
                    let nv =
                      {
                        v with
                        value = V.Loan (V.SharedLoan (bids, res.updated));
                      }
                    in
                    Ok (ctx, { res with updated = nv })
              else Error (FailSharedLoan bids))
      | (_, (V.Primitive _ | V.Adt _ | V.Bottom | V.Borrow _), _) as r ->
          let pe, v, ty = r in
          let pe = "- pe: " ^ E.show_projection_elem pe in
          let v = "- v:\n" ^ V.show_value v in
          let ty = "- ty:\n" ^ T.show_ety ty in
          log#serror ("Inconsistent projection:\n" ^ pe ^ "\n" ^ v ^ "\n" ^ ty);
          raise (Failure "Inconsistent projection"))

(** Generic function to access (read/write) the value at a given place.

    We return the value we read at the place and the (eventually) updated
    environment, if we managed to access the place, or the precise reason
    why we failed.
 *)
let access_place (access : projection_access)
    (* Function to (eventually) update the value we find *)
      (update : V.typed_value -> V.typed_value) (p : E.place) (ctx : C.eval_ctx)
    : (C.eval_ctx * V.typed_value) path_access_result =
  (* Lookup the variable's value *)
  let value = C.ctx_lookup_var_value ctx p.var_id in
  (* Apply the projection *)
  match access_projection access ctx update p.projection value with
  | Error err -> Error err
  | Ok (ctx, res) ->
      (* Update the value *)
      let ctx = C.ctx_update_var_value ctx p.var_id res.updated in
      (* Return *)
      Ok (ctx, res.read)

type access_kind =
  | Read  (** We can go inside borrows and loans *)
  | Write  (** Don't enter shared borrows or shared loans *)
  | Move  (** Don't enter borrows or loans *)

let access_kind_to_projection_access (access : access_kind) : projection_access
    =
  match access with
  | Read ->
      {
        enter_shared_loans = true;
        enter_mut_borrows = true;
        lookup_shared_borrows = true;
      }
  | Write ->
      {
        enter_shared_loans = false;
        enter_mut_borrows = true;
        lookup_shared_borrows = false;
      }
  | Move ->
      {
        enter_shared_loans = false;
        enter_mut_borrows = false;
        lookup_shared_borrows = false;
      }

(** Read the value at a given place.

    Note that we only access the value at the place, and do not check that
    the value is "well-formed" (for instance that it doesn't contain bottoms).
 *)
let read_place (config : C.config) (access : access_kind) (p : E.place)
    (ctx : C.eval_ctx) : V.typed_value path_access_result =
  let access = access_kind_to_projection_access access in
  (* The update function is the identity *)
  let update v = v in
  match access_place access update p ctx with
  | Error err -> Error err
  | Ok (ctx1, read_value) ->
      (* Note that we ignore the new environment: it should be the same as the
         original one.
      *)
      if config.check_invariants then
        if ctx1 <> ctx then (
          let msg =
            "Unexpected environment update:\nNew environment:\n"
            ^ C.show_env ctx1.env ^ "\n\nOld environment:\n"
            ^ C.show_env ctx.env
          in
          log#serror msg;
          raise (Failure "Unexpected environment update"));
      Ok read_value

let read_place_unwrap (config : C.config) (access : access_kind) (p : E.place)
    (ctx : C.eval_ctx) : V.typed_value =
  match read_place config access p ctx with
  | Error e -> raise (Failure ("Unreachable: " ^ show_path_fail_kind e))
  | Ok v -> v

(** Update the value at a given place *)
let write_place (_config : C.config) (access : access_kind) (p : E.place)
    (nv : V.typed_value) (ctx : C.eval_ctx) : C.eval_ctx path_access_result =
  let access = access_kind_to_projection_access access in
  (* The update function substitutes the value with the new value *)
  let update _ = nv in
  match access_place access update p ctx with
  | Error err -> Error err
  | Ok (ctx, _) ->
      (* We ignore the read value *)
      Ok ctx

let write_place_unwrap (config : C.config) (access : access_kind) (p : E.place)
    (nv : V.typed_value) (ctx : C.eval_ctx) : C.eval_ctx =
  match write_place config access p nv ctx with
  | Error e -> raise (Failure ("Unreachable: " ^ show_path_fail_kind e))
  | Ok ctx -> ctx

(** Compute an expanded ADT bottom value *)
let compute_expanded_bottom_adt_value (tyctx : T.type_decl T.TypeDeclId.Map.t)
    (def_id : T.TypeDeclId.id) (opt_variant_id : T.VariantId.id option)
    (regions : T.erased_region list) (types : T.ety list) : V.typed_value =
  (* Lookup the definition and check if it is an enumeration - it
     should be an enumeration if and only if the projection element
     is a field projection with *some* variant id. Retrieve the list
     of fields at the same time. *)
  let def = T.TypeDeclId.Map.find def_id tyctx in
  assert (List.length regions = List.length def.T.region_params);
  (* Compute the field types *)
  let field_types =
    Subst.type_decl_get_instantiated_field_etypes def opt_variant_id types
  in
  (* Initialize the expanded value *)
  let fields = List.map mk_bottom field_types in
  let av = V.Adt { variant_id = opt_variant_id; field_values = fields } in
  let ty = T.Adt (T.AdtId def_id, regions, types) in
  { V.value = av; V.ty }

(** Compute an expanded Option bottom value *)
let compute_expanded_bottom_option_value (variant_id : T.VariantId.id)
    (param_ty : T.ety) : V.typed_value =
  (* Note that the variant can be [Some] or [None]: we expand bottom values
   * when writing to fields or setting discriminants *)
  let field_values =
    if variant_id = T.option_some_id then [ mk_bottom param_ty ]
    else if variant_id = T.option_none_id then []
    else raise (Failure "Unreachable")
  in
  let av = V.Adt { variant_id = Some variant_id; field_values } in
  let ty = T.Adt (T.Assumed T.Option, [], [ param_ty ]) in
  { V.value = av; ty }

(** Compute an expanded tuple bottom value *)
let compute_expanded_bottom_tuple_value (field_types : T.ety list) :
    V.typed_value =
  (* Generate the field values *)
  let fields = List.map mk_bottom field_types in
  let v = V.Adt { variant_id = None; field_values = fields } in
  let ty = T.Adt (T.Tuple, [], field_types) in
  { V.value = v; V.ty }

(** Auxiliary helper to expand {!V.Bottom} values.

    During compilation, rustc desaggregates the ADT initializations. The
    consequence is that the following rust code:
    {[
      let x = Cons a b;
    ]}

    Looks like this in MIR:
    {[
      (x as Cons).0 = a;
      (x as Cons).1 = b;
      set_discriminant(x, 0); // If [Cons] is the variant of index 0
    ]}

    The consequence is that we may sometimes need to write fields to values
    which are currently {!V.Bottom}. When doing this, we first expand the value
    to, say, [Cons Bottom Bottom] (note that field projection contains information
    about which variant we should project to, which is why we *can* set the
    variant index when writing one of its fields).
*)
let expand_bottom_value_from_projection (config : C.config)
    (access : access_kind) (p : E.place) (remaining_pes : int)
    (pe : E.projection_elem) (ty : T.ety) (ctx : C.eval_ctx) : C.eval_ctx =
  (* Debugging *)
  log#ldebug
    (lazy
      ("expand_bottom_value_from_projection:\n" ^ "pe: "
     ^ E.show_projection_elem pe ^ "\n" ^ "ty: " ^ T.show_ety ty));
  (* Prepare the update: we need to take the proper prefix of the place
     during whose evaluation we got stuck *)
  let projection' =
    fst
      (Collections.List.split_at p.projection
         (List.length p.projection - remaining_pes))
  in
  let p' = { p with projection = projection' } in
  (* Compute the expanded value.
     The type of the {!V.Bottom} value should be a tuple or an ADT.
     Note that the projection element we got stuck at should be a
     field projection, and gives the variant id if the {!V.Bottom} value
     is an enumeration value.
     Also, the expanded value should be the proper ADT variant or a tuple
     with the proper arity, with all the fields initialized to {!V.Bottom}
  *)
  let nv =
    match (pe, ty) with
    (* "Regular" ADTs *)
    | ( Field (ProjAdt (def_id, opt_variant_id), _),
        T.Adt (T.AdtId def_id', regions, types) ) ->
        assert (def_id = def_id');
        compute_expanded_bottom_adt_value ctx.type_context.type_decls def_id
          opt_variant_id regions types
    (* Option *)
    | Field (ProjOption variant_id, _), T.Adt (T.Assumed T.Option, [], [ ty ])
      ->
        compute_expanded_bottom_option_value variant_id ty
    (* Tuples *)
    | Field (ProjTuple arity, _), T.Adt (T.Tuple, [], tys) ->
        assert (arity = List.length tys);
        (* Generate the field values *)
        compute_expanded_bottom_tuple_value tys
    | _ ->
        raise
          (Failure
             ("Unreachable: " ^ E.show_projection_elem pe ^ ", " ^ T.show_ety ty))
  in
  (* Update the context by inserting the expanded value at the proper place *)
  match write_place config access p' nv ctx with
  | Ok ctx -> ctx
  | Error _ -> raise (Failure "Unreachable")

(** Update the environment to be able to read a place.

    When reading a place, we may be stuck along the way because some value
    is borrowed, we reach a symbolic value, etc. In this situation [read_place]
    fails while returning precise information about the failure. This function
    uses this information to update the environment (by ending borrows,
    expanding symbolic values) until we manage to fully read the place.
 *)
let rec update_ctx_along_read_place (config : C.config) (access : access_kind)
    (p : E.place) : cm_fun =
 fun cf ctx ->
  (* Attempt to read the place: if it fails, update the environment and retry *)
  match read_place config access p ctx with
  | Ok _ -> cf ctx
  | Error err ->
      let cc =
        match err with
        | FailSharedLoan bids -> end_outer_borrows config bids
        | FailMutLoan bid -> end_outer_borrow config bid
        | FailInactivatedMutBorrow bid ->
            activate_inactivated_mut_borrow config bid
        | FailSymbolic (i, sp) ->
            (* Expand the symbolic value *)
            let proj, _ =
              Collections.List.split_at p.projection
                (List.length p.projection - i)
            in
            let prefix = { p with projection = proj } in
            expand_symbolic_value_no_branching config sp
              (Some (Synth.mk_mplace prefix ctx))
        | FailBottom (_, _, _) ->
            (* We can't expand {!V.Bottom} values while reading them *)
            raise (Failure "Found [Bottom] while reading a place")
        | FailBorrow _ -> raise (Failure "Could not read a borrow")
      in
      comp cc (update_ctx_along_read_place config access p) cf ctx

(** Update the environment to be able to write to a place.

    See {!update_ctx_along_read_place}.
*)
let rec update_ctx_along_write_place (config : C.config) (access : access_kind)
    (p : E.place) : cm_fun =
 fun cf ctx ->
  (* Attempt to *read* (yes, *read*: we check the access to the place, and
     write to it later) the place: if it fails, update the environment and retry *)
  match read_place config access p ctx with
  | Ok _ -> cf ctx
  | Error err ->
      (* Update the context *)
      let cc =
        match err with
        | FailSharedLoan bids -> end_outer_borrows config bids
        | FailMutLoan bid -> end_outer_borrow config bid
        | FailInactivatedMutBorrow bid ->
            activate_inactivated_mut_borrow config bid
        | FailSymbolic (_pe, sp) ->
            (* Expand the symbolic value *)
            expand_symbolic_value_no_branching config sp
              (Some (Synth.mk_mplace p ctx))
        | FailBottom (remaining_pes, pe, ty) ->
            (* Expand the {!V.Bottom} value *)
            fun cf ctx ->
             let ctx =
               expand_bottom_value_from_projection config access p remaining_pes
                 pe ty ctx
             in
             cf ctx
        | FailBorrow _ -> raise (Failure "Could not write to a borrow")
      in
      (* Retry *)
      comp cc (update_ctx_along_write_place config access p) cf ctx

(** Small utility used to break control-flow *)
exception UpdateCtx of cm_fun

(** End the loans at a given place: read the value, if it contains a loan,
    end this loan, repeat.

    This is used when reading or borrowing values. We typically
    first call {!update_ctx_along_read_place} or {!update_ctx_along_write_place}
    to get access to the value, then call this function to "prepare" the value:
    when moving values, we can't move a value which contains loans and thus need
    to end them, etc.
 *)
let rec end_loans_at_place (config : C.config) (access : access_kind)
    (p : E.place) : cm_fun =
 fun cf ctx ->
  (* Iterator to explore a value and update the context whenever we find
   * loans.
   * We use exceptions to make it handy: whenever we update the
   * context, we raise an exception wrapping the updated context.
   * *)
  let obj =
    object
      inherit [_] V.iter_typed_value as super

      method! visit_borrow_content env bc =
        match bc with
        | V.SharedBorrow _ | V.MutBorrow (_, _) ->
            (* Nothing special to do *) super#visit_borrow_content env bc
        | V.InactivatedMutBorrow (_, bid) ->
            (* We need to activate inactivated borrows *)
            let cc = activate_inactivated_mut_borrow config bid in
            raise (UpdateCtx cc)

      method! visit_loan_content env lc =
        match lc with
        | V.SharedLoan (bids, v) -> (
            (* End the loans if we need a modification access, otherwise dive into
               the shared value *)
            match access with
            | Read -> super#visit_SharedLoan env bids v
            | Write | Move ->
                let cc = end_outer_borrows config bids in
                raise (UpdateCtx cc))
        | V.MutLoan bid ->
            (* We always need to end mutable borrows *)
            let cc = end_outer_borrow config bid in
            raise (UpdateCtx cc)
    end
  in

  (* First, retrieve the value *)
  match read_place config access p ctx with
  | Error _ -> raise (Failure "Unreachable")
  | Ok v -> (
      (* Inspect the value and update the context while doing so.
         If the context gets updated: perform a recursive call (many things
         may have been updated in the context: we need to re-read the value
         at place [p] - and this value may actually not be accessible
         anymore...)
      *)
      try
        obj#visit_typed_value () v;
        (* No context update required: apply the continuation *)
        cf ctx
      with UpdateCtx cc ->
        (* We need to update the context: compose the caugth continuation with
         * a recursive call to reinspect the value *)
        comp cc (end_loans_at_place config access p) cf ctx)

(** Drop (end) outer loans and borrows at a given place, which should be
    seen as an l-value (we will write to it later, but need to drop
    the borrows before writing).

    This is used to drop values when evaluating the drop statement or before
    writing to a place.
    
    [end_borrows]:
    - if true: end all the loans and borrows we find, starting with the outer
      ones. This is used when evaluating the {!LlbcAst.Drop} statement (see {!InterpreterStatements.drop_value})
    - if false: only end the outer loans. This is used by {!InterpreterStatements.assign_to_place}
      or to drop the loans in the local variables when popping a frame.
    TODO: remove this option, it is actually not used anymore (should always be
    false).

    Note that we don't do what is defined in the formalization: we move the
    value to a temporary dummy value, then explore this value and end the
    loans/borrows inside as long as we find some, starting with the outer
    ones, then move the resulting value back to where it was. This shouldn't
    make any difference, really (note that the place is *inside* a borrow,
    if we end the borrow, we won't be able to reinsert the value back).
 *)
let drop_outer_borrows_loans_at_lplace (config : C.config) (end_borrows : bool)
    (p : E.place) : cm_fun =
 fun cf ctx ->
  (* Move the current value in the place outside of this place and into
   * a dummy variable *)
  let access = Write in
  let v = read_place_unwrap config access p ctx in
  let ctx = write_place_unwrap config access p (mk_bottom v.V.ty) ctx in
  let ctx = C.ctx_push_dummy_var ctx v in
  (* Auxiliary function *)
  let rec drop : cm_fun =
   fun cf ctx ->
    (* Read the value *)
    let v = C.ctx_read_first_dummy_var ctx in
    (* Check if there are loans or borrows to end *)
    match get_first_outer_loan_or_borrow_in_value end_borrows v with
    | None ->
        (* We are done: simply call the continuation *)
        cf ctx
    | Some c ->
        (* There are: end them then retry *)
        let cc =
          match c with
          | LoanContent (V.SharedLoan (bids, _)) ->
              end_outer_borrows config bids
          | LoanContent (V.MutLoan bid)
          | BorrowContent (V.MutBorrow (bid, _) | SharedBorrow (_, bid)) ->
              end_outer_borrow config bid
          | BorrowContent (V.InactivatedMutBorrow (_, bid)) ->
              (* First activate the borrow *)
              activate_inactivated_mut_borrow config bid
        in
        (* Retry *)
        comp cc drop cf ctx
  in
  (* Apply the drop function *)
  let cc = drop in
  (* Pop the temporary value and reinsert it *)
  let cc =
    comp cc (fun cf ctx ->
        (* Pop *)
        let ctx, v = C.ctx_pop_dummy_var ctx in
        (* Reinsert *)
        let ctx = write_place_unwrap config access p v ctx in
        (* Sanity check *)
        if end_borrows then (
          assert (not (loans_in_value v));
          assert (not (borrows_in_value v)))
        else assert (not (outer_loans_in_value v));
        (* Continue *)
        cf ctx)
  in
  (* Continue *)
  cc cf ctx

(** Copy a value, and return the resulting value.

    Note that copying values might update the context. For instance, when
    copying shared borrows, we need to insert new shared borrows in the context.
 
    Also, this function is actually more general than it should be: it can be used
    to copy concrete ADT values, while ADT copy should be done through the Copy
    trait (i.e., by calling a dedicated function). This is why we added a parameter
    to control this copy. Note that here by ADT we mean the user-defined ADTs
    (not tuples or assumed types).
    
    TODO: move
 *)
let rec copy_value (allow_adt_copy : bool) (config : C.config)
    (ctx : C.eval_ctx) (v : V.typed_value) : C.eval_ctx * V.typed_value =
  log#ldebug
    (lazy
      ("copy_value: "
      ^ typed_value_to_string ctx v
      ^ "\n- context:\n" ^ eval_ctx_to_string ctx));
  (* Remark: at some point we rewrote this function to use iterators, but then
   * we reverted the changes: the result was less clear actually. In particular,
   * the fact that we have exhaustive matches below makes very obvious the cases
   * in which we need to fail *)
  match v.V.value with
  | V.Primitive _ -> (ctx, v)
  | V.Adt av ->
      (* Sanity check *)
      (match v.V.ty with
      | T.Adt (T.Assumed (T.Box | Vec), _, _) ->
          raise (Failure "Can't copy an assumed value other than Option")
      | T.Adt (T.AdtId _, _, _) -> assert allow_adt_copy
      | T.Adt ((T.Assumed Option | T.Tuple), _, _) -> () (* Ok *)
      | _ -> raise (Failure "Unreachable"));
      let ctx, fields =
        List.fold_left_map
          (copy_value allow_adt_copy config)
          ctx av.field_values
      in
      (ctx, { v with V.value = V.Adt { av with field_values = fields } })
  | V.Bottom -> raise (Failure "Can't copy ⊥")
  | V.Borrow bc -> (
      (* We can only copy shared borrows *)
      match bc with
      | SharedBorrow (mv, bid) ->
          (* We need to create a new borrow id for the copied borrow, and
           * update the context accordingly *)
          let bid' = C.fresh_borrow_id () in
          let ctx = reborrow_shared bid bid' ctx in
          (ctx, { v with V.value = V.Borrow (SharedBorrow (mv, bid')) })
      | MutBorrow (_, _) -> raise (Failure "Can't copy a mutable borrow")
      | V.InactivatedMutBorrow _ ->
          raise (Failure "Can't copy an inactivated mut borrow"))
  | V.Loan lc -> (
      (* We can only copy shared loans *)
      match lc with
      | V.MutLoan _ -> raise (Failure "Can't copy a mutable loan")
      | V.SharedLoan (_, sv) ->
          (* We don't copy the shared loan: only the shared value inside *)
          copy_value allow_adt_copy config ctx sv)
  | V.Symbolic sp ->
      (* We can copy only if the type is "primitively" copyable.
       * Note that in the general case, copy is a trait: copying values
       * thus requires calling the proper function. Here, we copy values
       * for very simple types such as integers, shared borrows, etc. *)
      assert (ty_is_primitively_copyable (Subst.erase_regions sp.V.sv_ty));
      (* If the type is copyable, we simply return the current value. Side
       * remark: what is important to look at when copying symbolic values
       * is symbolic expansion. The important subcase is the expansion of shared
       * borrows: when doing so, every occurrence of the same symbolic value
       * must use a fresh borrow id. *)
      (ctx, v)

(** Small utility.
    
    Prepare a place which is to be used as the destination of an assignment:
    update the environment along the paths, end the loans at this place, etc.

    Return the updated context and the (updated) value at the end of the
    place. This value should not contain any loan or borrow (and we check
    it is the case). Note that this value is very likely to contain {!V.Bottom}
    subvalues.
    
    [end_borrows]: if false, we only end the outer loans we find. If true, we
    end all the loans and the borrows we find.
    TODO: end_borrows is not necessary anymore.
 *)
let prepare_lplace (config : C.config) (end_borrows : bool) (p : E.place)
    (cf : V.typed_value -> m_fun) : m_fun =
 fun ctx ->
  log#ldebug
    (lazy
      ("prepare_lplace:" ^ "\n- p: " ^ place_to_string ctx p
     ^ "\n- Initial context:\n" ^ eval_ctx_to_string ctx));
  (* Access the place *)
  let access = Write in
  let cc = update_ctx_along_write_place config access p in
  (* End the borrows and loans, starting with the borrows *)
  let cc = comp cc (drop_outer_borrows_loans_at_lplace config end_borrows p) in
  (* Read the value and check it *)
  let read_check cf : m_fun =
   fun ctx ->
    let v = read_place_unwrap config access p ctx in
    (* Sanity checks *)
    if end_borrows then (
      assert (not (loans_in_value v));
      assert (not (borrows_in_value v)))
    else assert (not (outer_loans_in_value v));
    (* Continue *)
    cf v ctx
  in
  (* Compose and apply the continuations *)
  comp cc read_check cf ctx
