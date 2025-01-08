(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [adt_borrows] *)
module AdtBorrows
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [adt_borrows::SharedWrapper]
    Source: 'tests/src/adt-borrows.rs', lines 7:0-7:35 *)
type sharedWrapper_t (t : Type0) = t

(** [adt_borrows::{adt_borrows::SharedWrapper<'a, T>}::create]:
    Source: 'tests/src/adt-borrows.rs', lines 10:4-12:5 *)
let sharedWrapper_create (#t : Type0) (x : t) : result (sharedWrapper_t t) =
  Ok x

(** [adt_borrows::{adt_borrows::SharedWrapper<'a, T>}::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 14:4-16:5 *)
let sharedWrapper_unwrap (#t : Type0) (self : sharedWrapper_t t) : result t =
  Ok self

(** [adt_borrows::use_shared_wrapper]:
    Source: 'tests/src/adt-borrows.rs', lines 19:0-24:1 *)
let use_shared_wrapper : result unit =
  let* w = sharedWrapper_create 0 in
  let* p = sharedWrapper_unwrap w in
  if 0 = p then Ok () else Fail Failure

(** [adt_borrows::SharedWrapper1]
    Source: 'tests/src/adt-borrows.rs', lines 26:0-28:1 *)
type sharedWrapper1_t (t : Type0) = { x : t; }

(** [adt_borrows::{adt_borrows::SharedWrapper1<'a, T>}#1::create]:
    Source: 'tests/src/adt-borrows.rs', lines 31:4-33:5 *)
let sharedWrapper1_create (#t : Type0) (x : t) : result (sharedWrapper1_t t) =
  Ok { x }

(** [adt_borrows::{adt_borrows::SharedWrapper1<'a, T>}#1::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 35:4-37:5 *)
let sharedWrapper1_unwrap (#t : Type0) (self : sharedWrapper1_t t) : result t =
  Ok self.x

(** [adt_borrows::use_shared_wrapper1]:
    Source: 'tests/src/adt-borrows.rs', lines 40:0-45:1 *)
let use_shared_wrapper1 : result unit =
  let* w = sharedWrapper1_create 0 in
  let* p = sharedWrapper1_unwrap w in
  if 0 = p then Ok () else Fail Failure

(** [adt_borrows::SharedWrapper2]
    Source: 'tests/src/adt-borrows.rs', lines 47:0-50:1 *)
type sharedWrapper2_t (t : Type0) = { x : t; y : t; }

(** [adt_borrows::{adt_borrows::SharedWrapper2<'a, 'b, T>}#2::create]:
    Source: 'tests/src/adt-borrows.rs', lines 53:4-55:5 *)
let sharedWrapper2_create
  (#t : Type0) (x : t) (y : t) : result (sharedWrapper2_t t) =
  Ok { x; y }

(** [adt_borrows::{adt_borrows::SharedWrapper2<'a, 'b, T>}#2::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 57:4-59:5 *)
let sharedWrapper2_unwrap
  (#t : Type0) (self : sharedWrapper2_t t) : result (t & t) =
  Ok (self.x, self.y)

(** [adt_borrows::use_shared_wrapper2]:
    Source: 'tests/src/adt-borrows.rs', lines 62:0-69:1 *)
let use_shared_wrapper2 : result unit =
  let* w = sharedWrapper2_create 0 1 in
  let* p = sharedWrapper2_unwrap w in
  let (px, py) = p in
  if 0 = px then if 1 = py then Ok () else Fail Failure else Fail Failure

(** [adt_borrows::MutWrapper]
    Source: 'tests/src/adt-borrows.rs', lines 71:0-71:36 *)
type mutWrapper_t (t : Type0) = t

(** [adt_borrows::{adt_borrows::MutWrapper<'a, T>}#3::create]:
    Source: 'tests/src/adt-borrows.rs', lines 74:4-76:5 *)
let mutWrapper_create
  (#t : Type0) (x : t) : result ((mutWrapper_t t) & (mutWrapper_t t -> t)) =
  Ok (x, (fun ret -> ret))

(** [adt_borrows::{adt_borrows::MutWrapper<'a, T>}#3::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 78:4-80:5 *)
let mutWrapper_unwrap
  (#t : Type0) (self : mutWrapper_t t) : result (t & (t -> mutWrapper_t t)) =
  let back = fun ret -> ret in Ok (self, back)

(** [adt_borrows::{adt_borrows::MutWrapper<'a, T>}#3::id]:
    Source: 'tests/src/adt-borrows.rs', lines 82:4-84:5 *)
let mutWrapper_id
  (#t : Type0) (self : mutWrapper_t t) :
  result ((mutWrapper_t t) & (mutWrapper_t t -> mutWrapper_t t))
  =
  let back = fun ret -> ret in Ok (self, back)

(** [adt_borrows::use_mut_wrapper]:
    Source: 'tests/src/adt-borrows.rs', lines 87:0-93:1 *)
let use_mut_wrapper : result unit =
  let* (w, create_back) = mutWrapper_create 0 in
  let* (p, unwrap_back) = mutWrapper_unwrap w in
  let* p1 = i32_add p 1 in
  let x = create_back (unwrap_back p1) in
  if x = 1 then Ok () else Fail Failure

(** [adt_borrows::use_mut_wrapper_id]:
    Source: 'tests/src/adt-borrows.rs', lines 95:0-97:1 *)
let use_mut_wrapper_id
  (#t : Type0) (x : mutWrapper_t t) :
  result ((mutWrapper_t t) & (mutWrapper_t t -> mutWrapper_t t))
  =
  let* (mw, id_back) = mutWrapper_id x in
  let back = fun ret -> id_back ret in
  Ok (mw, back)

(** [adt_borrows::MutWrapper1]
    Source: 'tests/src/adt-borrows.rs', lines 99:0-101:1 *)
type mutWrapper1_t (t : Type0) = { x : t; }

(** [adt_borrows::{adt_borrows::MutWrapper1<'a, T>}#4::create]:
    Source: 'tests/src/adt-borrows.rs', lines 104:4-106:5 *)
let mutWrapper1_create
  (#t : Type0) (x : t) : result ((mutWrapper1_t t) & (mutWrapper1_t t -> t)) =
  let back = fun ret -> ret.x in Ok ({ x }, back)

(** [adt_borrows::{adt_borrows::MutWrapper1<'a, T>}#4::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 108:4-110:5 *)
let mutWrapper1_unwrap
  (#t : Type0) (self : mutWrapper1_t t) : result (t & (t -> mutWrapper1_t t)) =
  let back = fun ret -> { x = ret } in Ok (self.x, back)

(** [adt_borrows::{adt_borrows::MutWrapper1<'a, T>}#4::id]:
    Source: 'tests/src/adt-borrows.rs', lines 112:4-114:5 *)
let mutWrapper1_id
  (#t : Type0) (self : mutWrapper1_t t) :
  result ((mutWrapper1_t t) & (mutWrapper1_t t -> mutWrapper1_t t))
  =
  Ok (self, (fun ret -> ret))

(** [adt_borrows::use_mut_wrapper1]:
    Source: 'tests/src/adt-borrows.rs', lines 117:0-123:1 *)
let use_mut_wrapper1 : result unit =
  let* (w, create_back) = mutWrapper1_create 0 in
  let* (p, unwrap_back) = mutWrapper1_unwrap w in
  let* p1 = i32_add p 1 in
  let x = create_back (unwrap_back p1) in
  if x = 1 then Ok () else Fail Failure

(** [adt_borrows::use_mut_wrapper1_id]:
    Source: 'tests/src/adt-borrows.rs', lines 125:0-127:1 *)
let use_mut_wrapper1_id
  (#t : Type0) (x : mutWrapper1_t t) :
  result ((mutWrapper1_t t) & (mutWrapper1_t t -> mutWrapper1_t t))
  =
  mutWrapper1_id x

(** [adt_borrows::MutWrapper2]
    Source: 'tests/src/adt-borrows.rs', lines 129:0-132:1 *)
type mutWrapper2_t (t : Type0) = { x : t; y : t; }

(** [adt_borrows::{adt_borrows::MutWrapper2<'a, 'b, T>}#5::create]:
    Source: 'tests/src/adt-borrows.rs', lines 135:4-137:5 *)
let mutWrapper2_create
  (#t : Type0) (x : t) (y : t) :
  result ((mutWrapper2_t t) & (mutWrapper2_t t -> t) & (mutWrapper2_t t -> t))
  =
  let back'a = fun ret -> ret.x in
  let back'b = fun ret -> ret.y in
  Ok ({ x; y }, back'a, back'b)

(** [adt_borrows::{adt_borrows::MutWrapper2<'a, 'b, T>}#5::unwrap]:
    Source: 'tests/src/adt-borrows.rs', lines 139:4-141:5 *)
let mutWrapper2_unwrap
  (#t : Type0) (self : mutWrapper2_t t) :
  result ((t & t) & (t -> mutWrapper2_t t) & (t -> mutWrapper2_t t))
  =
  let back'a = fun ret -> { self with x = ret } in
  let back'b = fun ret -> { self with y = ret } in
  Ok ((self.x, self.y), back'a, back'b)

(** [adt_borrows::{adt_borrows::MutWrapper2<'a, 'b, T>}#5::id]:
    Source: 'tests/src/adt-borrows.rs', lines 143:4-145:5 *)
let mutWrapper2_id
  (#t : Type0) (self : mutWrapper2_t t) :
  result ((mutWrapper2_t t) & (mutWrapper2_t t -> mutWrapper2_t t) &
    (mutWrapper2_t t -> mutWrapper2_t t))
  =
  let back'a = fun ret -> { self with x = ret.x } in
  let back'b = fun ret -> { self with y = ret.y } in
  Ok (self, back'a, back'b)

(** [adt_borrows::use_mut_wrapper2]:
    Source: 'tests/src/adt-borrows.rs', lines 148:0-157:1 *)
let use_mut_wrapper2 : result unit =
  let* (w, create_back, create_back1) = mutWrapper2_create 0 10 in
  let* (p, unwrap_back, unwrap_back1) = mutWrapper2_unwrap w in
  let (px, py) = p in
  let* px1 = i32_add px 1 in
  let* py1 = i32_add py 1 in
  let x = create_back { w with x = (unwrap_back px1).x } in
  if x = 1
  then
    let y = create_back1 { w with y = (unwrap_back1 py1).y } in
    if y = 11 then Ok () else Fail Failure
  else Fail Failure

(** [adt_borrows::use_mut_wrapper2_id]:
    Source: 'tests/src/adt-borrows.rs', lines 159:0-161:1 *)
let use_mut_wrapper2_id
  (#t : Type0) (x : mutWrapper2_t t) :
  result ((mutWrapper2_t t) & (mutWrapper2_t t -> mutWrapper2_t t) &
    (mutWrapper2_t t -> mutWrapper2_t t))
  =
  let* (mw, id_back, id_back1) = mutWrapper2_id x in
  let back'a = fun ret -> { x with x = (id_back { mw with x = ret.x }).x } in
  let back'b = fun ret -> { x with y = (id_back1 { mw with y = ret.y }).y } in
  Ok (mw, back'a, back'b)

(** [adt_borrows::array_shared_borrow]:
    Source: 'tests/src/adt-borrows.rs', lines 170:0-172:1 *)
let array_shared_borrow (#n : usize) (x : array u32 n) : result (array u32 n) =
  Ok x

(** [adt_borrows::array_mut_borrow]:
    Source: 'tests/src/adt-borrows.rs', lines 174:0-176:1 *)
let array_mut_borrow
  (#n : usize) (x : array u32 n) :
  result ((array u32 n) & (array u32 n -> array u32 n))
  =
  Ok (x, (fun ret -> ret))

(** [adt_borrows::use_array_mut_borrow1]:
    Source: 'tests/src/adt-borrows.rs', lines 178:0-180:1 *)
let use_array_mut_borrow1
  (#n : usize) (x : array u32 n) :
  result ((array u32 n) & (array u32 n -> array u32 n))
  =
  array_mut_borrow x

(** [adt_borrows::use_array_mut_borrow2]:
    Source: 'tests/src/adt-borrows.rs', lines 182:0-185:1 *)
let use_array_mut_borrow2
  (#n : usize) (x : array u32 n) :
  result ((array u32 n) & (array u32 n -> array u32 n))
  =
  let* (x1, array_mut_borrow_back) = array_mut_borrow x in
  let* (a, array_mut_borrow_back1) = array_mut_borrow x1 in
  let back =
    fun ret -> let x2 = array_mut_borrow_back1 ret in array_mut_borrow_back x2
    in
  Ok (a, back)

(** [adt_borrows::boxed_slice_shared_borrow]:
    Source: 'tests/src/adt-borrows.rs', lines 187:0-189:1 *)
let boxed_slice_shared_borrow (x : slice u32) : result (slice u32) =
  Ok x

(** [adt_borrows::boxed_slice_mut_borrow]:
    Source: 'tests/src/adt-borrows.rs', lines 191:0-193:1 *)
let boxed_slice_mut_borrow
  (x : slice u32) : result ((slice u32) & (slice u32 -> slice u32)) =
  Ok (x, (fun ret -> ret))

(** [adt_borrows::use_boxed_slice_mut_borrow1]:
    Source: 'tests/src/adt-borrows.rs', lines 195:0-197:1 *)
let use_boxed_slice_mut_borrow1
  (x : slice u32) : result ((slice u32) & (slice u32 -> slice u32)) =
  boxed_slice_mut_borrow x

(** [adt_borrows::use_boxed_slice_mut_borrow2]:
    Source: 'tests/src/adt-borrows.rs', lines 199:0-202:1 *)
let use_boxed_slice_mut_borrow2
  (x : slice u32) : result ((slice u32) & (slice u32 -> slice u32)) =
  let* (x1, boxed_slice_mut_borrow_back) = boxed_slice_mut_borrow x in
  let* (s, boxed_slice_mut_borrow_back1) = boxed_slice_mut_borrow x1 in
  let back =
    fun ret ->
      let s1 = boxed_slice_mut_borrow_back1 ret in
      boxed_slice_mut_borrow_back s1 in
  Ok (s, back)

(** [adt_borrows::SharedList]
    Source: 'tests/src/adt-borrows.rs', lines 207:0-210:1 *)
type sharedList_t (t : Type0) =
| SharedList_Nil : sharedList_t t
| SharedList_Cons : t -> sharedList_t t -> sharedList_t t

(** [adt_borrows::{adt_borrows::SharedList<'a, T>}#6::push]:
    Source: 'tests/src/adt-borrows.rs', lines 214:4-216:5 *)
let sharedList_push
  (#t : Type0) (self : sharedList_t t) (x : t) : result (sharedList_t t) =
  Ok (SharedList_Cons x self)

(** [adt_borrows::{adt_borrows::SharedList<'a, T>}#6::pop]:
    Source: 'tests/src/adt-borrows.rs', lines 218:4-224:5 *)
let sharedList_pop
  (#t : Type0) (self : sharedList_t t) : result (t & (sharedList_t t)) =
  begin match self with
  | SharedList_Nil -> Fail Failure
  | SharedList_Cons hd tl -> Ok (hd, tl)
  end

(** [adt_borrows::MutList]
    Source: 'tests/src/adt-borrows.rs', lines 227:0-230:1 *)
type mutList_t (t : Type0) =
| MutList_Nil : mutList_t t
| MutList_Cons : t -> mutList_t t -> mutList_t t

(** [adt_borrows::{adt_borrows::MutList<'a, T>}#7::push]:
    Source: 'tests/src/adt-borrows.rs', lines 234:4-236:5 *)
let mutList_push
  (#t : Type0) (self : mutList_t t) (x : t) :
  result ((mutList_t t) & (mutList_t t -> ((mutList_t t) & t)))
  =
  let back =
    fun ret ->
      let (x1, ml) =
        begin match ret with
        | MutList_Cons x2 ml1 -> (x2, ml1)
        | _ -> (x, self)
        end in
      (ml, x1) in
  Ok ((MutList_Cons x self), back)

(** [adt_borrows::{adt_borrows::MutList<'a, T>}#7::pop]:
    Source: 'tests/src/adt-borrows.rs', lines 238:4-244:5 *)
let mutList_pop
  (#t : Type0) (self : mutList_t t) :
  result ((t & (mutList_t t)) & ((t & (mutList_t t)) -> mutList_t t))
  =
  begin match self with
  | MutList_Nil -> Fail Failure
  | MutList_Cons hd tl ->
    let back = fun ret -> let (x, ml) = ret in MutList_Cons x ml in
    Ok ((hd, tl), back)
  end

(** [adt_borrows::wrap_shared_in_option]:
    Source: 'tests/src/adt-borrows.rs', lines 247:0-249:1 *)
let wrap_shared_in_option (#t : Type0) (x : t) : result (option t) =
  Ok (Some x)

(** [adt_borrows::wrap_mut_in_option]:
    Source: 'tests/src/adt-borrows.rs', lines 251:0-253:1 *)
let wrap_mut_in_option
  (#t : Type0) (x : t) : result ((option t) & (option t -> t)) =
  let back = fun ret -> begin match ret with | Some x1 -> x1 | _ -> x end in
  Ok ((Some x), back)

(** [adt_borrows::List]
    Source: 'tests/src/adt-borrows.rs', lines 255:0-258:1 *)
type list_t (t : Type0) =
| List_Cons : t -> list_t t -> list_t t
| List_Nil : list_t t

(** [adt_borrows::nth_shared]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 261:4-270:1 *)
let rec nth_shared_loop
  (#t : Type0) (ls : list_t t) (i : u32) : result (option t) =
  begin match ls with
  | List_Cons x tl ->
    if i = 0
    then Ok (Some x)
    else let* i1 = u32_sub i 1 in nth_shared_loop tl i1
  | List_Nil -> Ok None
  end

(** [adt_borrows::nth_shared]:
    Source: 'tests/src/adt-borrows.rs', lines 260:0-270:1 *)
let nth_shared (#t : Type0) (ls : list_t t) (i : u32) : result (option t) =
  nth_shared_loop ls i

(** [adt_borrows::nth_mut]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 273:4-282:1 *)
let rec nth_mut_loop
  (#t : Type0) (ls : list_t t) (i : u32) :
  result ((option t) & (option t -> list_t t))
  =
  begin match ls with
  | List_Cons x tl ->
    if i = 0
    then
      let back =
        fun ret ->
          let x1 = begin match ret with | Some x2 -> x2 | _ -> x end in
          List_Cons x1 tl in
      Ok ((Some x), back)
    else
      let* i1 = u32_sub i 1 in
      let* (o, back) = nth_mut_loop tl i1 in
      let back1 = fun ret -> let tl1 = back ret in List_Cons x tl1 in
      Ok (o, back1)
  | List_Nil -> let back = fun ret -> List_Nil in Ok (None, back)
  end

(** [adt_borrows::nth_mut]:
    Source: 'tests/src/adt-borrows.rs', lines 272:0-282:1 *)
let nth_mut
  (#t : Type0) (ls : list_t t) (i : u32) :
  result ((option t) & (option t -> list_t t))
  =
  nth_mut_loop ls i

(** [adt_borrows::update_array_mut_borrow]:
    Source: 'tests/src/adt-borrows.rs', lines 284:0-286:1 *)
let update_array_mut_borrow
  (a : array u32 32) :
  result ((array u32 32) & (array u32 32 -> array u32 32))
  =
  Ok (a, (fun ret -> ret))

(** [adt_borrows::array_mut_borrow_loop1]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 289:4-291:5 *)
let rec array_mut_borrow_loop1_loop
  (b : bool) (a : array u32 32) : result (array u32 32) =
  if b
  then
    let* (a1, update_array_mut_borrow_back) = update_array_mut_borrow a in
    let* a2 = array_mut_borrow_loop1_loop true a1 in
    Ok (update_array_mut_borrow_back a2)
  else Ok a

(** [adt_borrows::array_mut_borrow_loop1]:
    Source: 'tests/src/adt-borrows.rs', lines 288:0-292:1 *)
let array_mut_borrow_loop1
  (b : bool) (a : array u32 32) : result (array u32 32) =
  array_mut_borrow_loop1_loop b a

(** [adt_borrows::array_mut_borrow_loop2]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 295:4-297:5 *)
let rec array_mut_borrow_loop2_loop
  (b : bool) (a : array u32 32) :
  result ((array u32 32) & (array u32 32 -> array u32 32))
  =
  if b
  then
    let* (a1, update_array_mut_borrow_back) = update_array_mut_borrow a in
    let* (a2, back) = array_mut_borrow_loop2_loop true a1 in
    let back1 = fun ret -> let a3 = back ret in update_array_mut_borrow_back a3
      in
    Ok (a2, back1)
  else Ok (a, (fun ret -> ret))

(** [adt_borrows::array_mut_borrow_loop2]:
    Source: 'tests/src/adt-borrows.rs', lines 294:0-299:1 *)
let array_mut_borrow_loop2
  (b : bool) (a : array u32 32) :
  result ((array u32 32) & (array u32 32 -> array u32 32))
  =
  array_mut_borrow_loop2_loop b a

(** [adt_borrows::copy_shared_array]:
    Source: 'tests/src/adt-borrows.rs', lines 301:0-303:1 *)
let copy_shared_array (a : array u32 32) : result (array u32 32) =
  Ok a

(** [adt_borrows::array_shared_borrow_loop1]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 306:4-308:5 *)
let rec array_shared_borrow_loop1_loop
  (b : bool) (a : array u32 32) : result unit =
  if b
  then let* a1 = copy_shared_array a in array_shared_borrow_loop1_loop true a1
  else Ok ()

(** [adt_borrows::array_shared_borrow_loop1]:
    Source: 'tests/src/adt-borrows.rs', lines 305:0-309:1 *)
let array_shared_borrow_loop1 (b : bool) (a : array u32 32) : result unit =
  array_shared_borrow_loop1_loop b a

(** [adt_borrows::array_shared_borrow_loop2]: loop 0:
    Source: 'tests/src/adt-borrows.rs', lines 312:4-314:5 *)
let rec array_shared_borrow_loop2_loop
  (b : bool) (a : array u32 32) : result (array u32 32) =
  if b
  then let* a1 = copy_shared_array a in array_shared_borrow_loop2_loop true a1
  else Ok a

(** [adt_borrows::array_shared_borrow_loop2]:
    Source: 'tests/src/adt-borrows.rs', lines 311:0-316:1 *)
let array_shared_borrow_loop2
  (b : bool) (a : array u32 32) : result (array u32 32) =
  array_shared_borrow_loop2_loop b a

