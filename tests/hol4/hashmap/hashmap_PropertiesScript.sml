(*open boolTheory arithmeticTheory integerTheory intLib listTheory stringTheory*)
(*open primitivesArithTheory primitivesBaseTacLib ilistTheory primitivesTheory *)
open primitivesLib listTheory ilistTheory hashmap_TypesTheory hashmap_FunsTheory

val _ = new_theory "hashmap_Properties"


Type key_t = “:usize”

Definition for_all_def:
  for_all p [] = T ∧
  for_all p (x :: ls) = (p x ∧ for_all p ls)
End

(* Conversion from “:list_t” to “:list” *)
Definition list_t_v:
  (list_t_v (ListNil : 't list_t) : (key_t # 't) list = []) /\
  (list_t_v (ListCons k v tl) = (k, v) :: list_t_v tl)
End

(* Invariants *)
Definition lookup_def:
  lookup key [] = NONE /\
  lookup key ((k, v) :: ls) =
    if k = key then SOME v else lookup key ls
End

Definition slot_t_lookup_def:
  slot_t_lookup key ls = lookup key (list_t_v ls)
End

Definition remove_def:
  remove key [] = [] ∧
  remove key ((k, v) :: ls) =
    if k = key then ls else (k, v) :: remove key ls
End

Definition slot_t_remove_def:
  slot_t_remove key ls = remove key (list_t_v ls)
End

Definition slot_s_inv_def:
  slot_s_inv (i : int) (ls : (key_t # 'b) list) : bool = (
    (∀ k. lookup k ls ≠ NONE ⇒ lookup k (remove k ls) = NONE) ∧
    (∀ k v. MEM (k, v) ls ⇒
      ∃ hk. hash_key_fwd k = Return hk ⇒
        usize_to_int hk = i)
    )
End

Definition slot_t_inv_def:
  slot_t_inv (i : int) (s : 't list_t) = slot_s_inv i (list_t_v s)
End

(* Representation function of the hash map as a list of slots *)
Definition hash_map_t_v_def:
  hash_map_t_v (hm : 't hash_map_t) : (key_t # 't) list list =
    MAP list_t_v (vec_to_list hm.hash_map_slots)
End

(* Representation function of the hash map as an associative list *)
Definition hash_map_t_al_v_def:
  hash_map_t_al_v (hm : 't hash_map_t) : (key_t # 't) list = FLAT (hash_map_t_v hm)
End

Definition slots_s_inv_def:
  slots_s_inv (s : 'a list_t list) =
    ∀ (i : int). 0 ≤ i ⇒ i < len s ⇒ slot_t_inv i (index i s)
End

Definition slots_t_inv_def:
  slots_t_inv (s : 'a list_t vec) = slots_s_inv (vec_to_list s)
End

Definition hash_map_t_base_inv_def:
  hash_map_t_base_inv (hm : 't hash_map_t) =
    let al = hash_map_t_al_v hm in
    (* [num_entries] correctly tracks the number of entries in the table *)
    usize_to_int hm.hash_map_num_entries = len al /\
    (* Slots invariant *)
    slots_t_inv hm.hash_map_slots ∧
    (* The capacity must be > 0 (otherwise we can't resize, because when we
       resize we multiply the capacity by two) *)
    len (vec_to_list hm.hash_map_slots) > 0 ∧
    (* Load computation *)
    (let capacity = len (vec_to_list hm.hash_map_slots) in
     let (dividend, divisor) = hm.hash_map_max_load_factor in
     let dividend = usize_to_int dividend in
     let divisor = usize_to_int divisor in
     0 < dividend /\ dividend < divisor /\
     capacity * dividend >= divisor /\
     usize_to_int (hm.hash_map_max_load) = (capacity * dividend) / divisor
    )
End

(* The invariant that we reveal to the user *)
Definition hash_map_t_inv_def:
  hash_map_t_inv (hm : 't hash_map_t) : bool = (
    (* Base invariant *)
    hash_map_t_base_inv hm /\
    (* The hash map is either: not overloaded, or we can't resize it *)
    (let (dividend, divisor) = hm.hash_map_max_load_factor in
     (usize_to_int hm.hash_map_num_entries <= usize_to_int hm.hash_map_max_load) ∨
     (len (vec_to_list hm.hash_map_slots) * 2 * usize_to_int dividend > usize_max)
    )
  )
End

(* The specification functions that we reveal in the top-level theorems *)
Definition len_s_def:
  len_s hm = len (hash_map_t_al_v hm)
End

Definition hash_mod_key_def:
  hash_mod_key k (l : int) : int =
    case hash_key_fwd k of
    | Return k => usize_to_int k % l
    | _ => ARB
End

Definition slots_t_lookup_def:
  slots_t_find (s : 't list_t list) (k : key_t) : 't option = 
    let i = hash_mod_key k (len s) in
    let slot = index i s in
    slot_t_lookup k slot
End

Definition find_s_def:
  find_s (hm : 't hash_map_t) (k : key_t) : 't option =
    slots_t_find (vec_to_list hm.hash_map_slots) k
End

(* Proofs *)


(* TODO: move *)
Theorem for_all_append:
  ∀ p ls0 ls1. for_all p ls0 ⇒ for_all p ls1 ⇒ for_all p (ls0 ++ ls1)
Proof
  Induct_on ‘ls0’ >> fs [for_all_def]
QED

Theorem hash_map_allocate_slots_loop_fwd_spec:
  ∀ slots n.
    for_all (\x. x = ListNil) (vec_to_list slots) ⇒
    len (vec_to_list slots) + usize_to_int n ≤ usize_max ⇒
    ∃ nslots. hash_map_allocate_slots_loop_fwd slots n = Return nslots ∧
      len (vec_to_list nslots) = len (vec_to_list slots) + usize_to_int n ∧
      for_all (\x. x = ListNil) (vec_to_list nslots)
Proof
  Induct_on ‘usize_to_int n’ >> rw [] >> massage >- int_tac >>
  pure_once_rewrite_tac [hash_map_allocate_slots_loop_fwd_def] >>
  fs [usize_gt_def] >> massage >> fs [] >>
  case_tac
  >-(
    sg ‘len (vec_to_list slots) ≤ usize_max’ >- int_tac >>
    (* TODO: massage needs to know that len is >= 0 *)
    qspec_assume ‘vec_to_list slots’ len_pos >>
    progress >- (
      fs [vec_len_def] >>
      massage >>
      int_tac) >>
    progress >>
    gvs [] >>
    (* TODO: progress doesn't work here *)
    last_x_assum (qspec_assume ‘a'’) >>
    massage >> gvs [] >>
    sg ‘v = usize_to_int n - 1’ >- int_tac >> fs [] >>
    (* *)
    progress
    >-(irule for_all_append >> fs [for_all_def])
    >-(fs [vec_len_def, len_append, len_def] >> int_tac)
    >-(fs [vec_len_def, len_append, len_def] >> int_tac)
  ) >>
  fs [] >>
  int_tac
QED

(*
Theorem nth_mut_fwd_spec:
  !(ls : 't list_t) (i : u32).
    u32_to_int i < len (list_t_v ls) ==>
    case nth_mut_fwd ls i of
    | Return x => x = index (u32_to_int i) (list_t_v ls)
    | Fail _ => F
    | Diverge => F
Proof
  Induct_on ‘ls’ >> rw [list_t_v_def, len_def] >~ [‘ListNil’]
  >-(massage >> int_tac) >>
  pure_once_rewrite_tac [nth_mut_fwd_def] >> rw [] >>
  fs [index_eq] >>
  progress >> progress
QED

val _ = save_spec_thm "nth_mut_fwd_spec"

val _ = new_constant ("insert", “: u32 -> 't -> (u32 # 't) list_t -> (u32 # 't) list_t result”)
val insert_def = new_axiom ("insert_def", “
 insert (key : u32) (value : 't) (ls : (u32 # 't) list_t) : (u32 # 't) list_t result =
  case ls of
  | ListCons (ckey, cvalue) tl =>
    if ckey = key
    then Return (ListCons (ckey, value) tl)
    else
      do
      tl0 <- insert key value tl;
      Return (ListCons (ckey, cvalue) tl0)
      od
  | ListNil => Return (ListCons (key, value) ListNil)
 ”)

(* Property that keys are pairwise distinct *)
val distinct_keys_def = Define ‘
  distinct_keys (ls : (u32 # 't) list) =
    !i j.
      0 ≤ i ⇒ i < j ⇒ j < len ls ⇒
      FST (index i ls) ≠ FST (index j ls)
’

(* Lemma about ‘insert’, without the invariant *)
Theorem insert_lem_aux:
  !ls key value.
    (* The keys are pairwise distinct *)
    case insert key value ls of
    | Return ls1 =>
      (* We updated the binding *)
      lookup key ls1 = SOME value /\
      (* The other bindings are left unchanged *)
      (!k. k <> key ==> lookup k ls = lookup k ls1)
    | Fail _ => F
    | Diverge => F
Proof
  Induct_on ‘ls’ >> rw [list_t_v_def] >~ [‘ListNil’] >>
  pure_once_rewrite_tac [insert_def] >> rw []
  >- (rw [lookup_def, lookup_raw_def, list_t_v_def])
  >- (rw [lookup_def, lookup_raw_def, list_t_v_def]) >>
  case_tac >> rw []
  >- (rw [lookup_def, lookup_raw_def, list_t_v_def])
  >- (rw [lookup_def, lookup_raw_def, list_t_v_def]) >>
  progress >>
  fs [lookup_def, lookup_raw_def, list_t_v_def]
QED

(*
 * Invariant proof 1
 *)

Theorem distinct_keys_cons:
  ∀ k v ls.
  (∀ i. 0 ≤ i ⇒ i < len ls ⇒ FST (index i ls) ≠ k) ⇒
  distinct_keys ls ⇒
  distinct_keys ((k,v) :: ls)
Proof
  rw [] >>
  rw [distinct_keys_def] >>
  Cases_on ‘i = 0’ >> fs []
  >-(
    (* Use the first hypothesis *)
    fs [index_eq] >>
    last_x_assum (qspecl_assume [‘j - 1’]) >>
    sg ‘0 ≤ j - 1’ >- int_tac >>
    fs [len_def] >>
    sg ‘j - 1 < len ls’ >- int_tac >>
    fs []
  ) >>
  (* Use the second hypothesis *)
  sg ‘0 < i’ >- int_tac >>
  sg ‘0 < j’ >- int_tac >>
  fs [distinct_keys_def, index_eq, len_def] >>
  first_x_assum (qspecl_assume [‘i - 1’, ‘j - 1’]) >>
  sg ‘0 ≤ i - 1 ∧ i - 1 < j - 1 ∧ j - 1 < len ls’ >- int_tac >>
  fs []
QED

Theorem distinct_keys_tail:
  ∀ k v ls.
  distinct_keys ((k,v) :: ls) ⇒
  distinct_keys ls
Proof
  rw [distinct_keys_def] >>
  last_x_assum (qspecl_assume [‘i + 1’, ‘j + 1’]) >>
  fs [len_def] >>
  sg ‘0 ≤ i + 1 ∧ i + 1 < j + 1 ∧ j + 1 < 1 + len ls’ >- int_tac >> fs [] >>
  sg ‘0 < i + 1 ∧ 0 < j + 1’ >- int_tac >> fs [index_eq] >>
  sg ‘i + 1 - 1 = i ∧ j + 1 - 1 = j’ >- int_tac >> fs []
QED

Theorem insert_index_neq:
  ∀ q k v ls0 ls1 i.
  (∀ j. 0 ≤ j ∧ j < len (list_t_v ls0) ⇒ q ≠ FST (index j (list_t_v ls0))) ⇒
  q ≠ k ⇒
  insert k v ls0 = Return ls1 ⇒
  0 ≤ i ⇒
  i < len (list_t_v ls1) ⇒
  FST (index i (list_t_v ls1)) ≠ q
Proof
  ntac 3 strip_tac >>
  Induct_on ‘ls0’ >> rw [] >~ [‘ListNil’]
  >-(
    fs [insert_def] >>
    sg ‘ls1 = ListCons (k,v) ListNil’ >- fs [] >> fs [list_t_v_def, len_def] >>
    sg ‘i = 0’ >- int_tac >> fs [index_eq]) >>
  Cases_on ‘t’ >>
  Cases_on ‘i = 0’ >> fs []
  >-(
    qpat_x_assum ‘insert _ _ _ = _’ mp_tac >>
    simp [MK_BOUNDED insert_def 1, bind_def] >>
    Cases_on ‘q' = k’ >> rw []
    >- (fs [list_t_v_def, index_eq]) >>
    Cases_on ‘insert k v ls0’ >> fs [] >>
    gvs [list_t_v_def, index_eq] >>
    first_x_assum (qspec_assume ‘0’) >>
    fs [len_def] >>
    strip_tac >>
    qspec_assume ‘list_t_v ls0’ len_pos >>
    sg ‘0 < 1 + len (list_t_v ls0)’ >- int_tac >>
    fs []) >>
  qpat_x_assum ‘insert _ _ _ = _’ mp_tac >>
  simp [MK_BOUNDED insert_def 1, bind_def] >>
  Cases_on ‘q' = k’ >> rw []
  >-(
    fs [list_t_v_def, index_eq, len_def] >>
    first_x_assum (qspec_assume ‘i’) >> rfs []) >>
  Cases_on ‘insert k v ls0’ >> fs [] >>
  gvs [list_t_v_def, index_eq] >>
  last_x_assum (qspec_assume ‘i - 1’) >>
  fs [len_def] >>
  sg ‘0 ≤ i - 1 ∧ i - 1 < len (list_t_v a)’ >- int_tac >> fs [] >>
  first_x_assum irule >>
  rw [] >>
  last_x_assum (qspec_assume ‘j + 1’) >>
  rfs [] >>
  sg ‘j + 1 < 1 + len (list_t_v ls0) ∧ j + 1 − 1 = j ∧ j + 1 ≠ 0’ >- int_tac >> fs []
QED

Theorem distinct_keys_insert_index_neq:
  ∀ k v q r ls0 ls1 i.
  distinct_keys ((q,r)::list_t_v ls0) ⇒
  q ≠ k ⇒
  insert k v ls0 = Return ls1 ⇒
  0 ≤ i ⇒
  i < len (list_t_v ls1) ⇒
  FST (index i (list_t_v ls1)) ≠ q
Proof
  rw [] >>
  (* Use the first assumption to prove the following assertion *)
  sg ‘∀ j. 0 ≤ j ∧ j < len (list_t_v ls0) ⇒ q ≠ FST (index j (list_t_v ls0))’
  >-(
    strip_tac >>
    fs [distinct_keys_def] >>
    last_x_assum (qspecl_assume [‘0’, ‘j + 1’]) >>
    fs [index_eq] >>
    sg ‘j + 1 - 1 = j’ >- int_tac >> fs [len_def] >>
    rw []>>
    first_x_assum irule >> int_tac) >>
  qspecl_assume [‘q’, ‘k’, ‘v’, ‘ls0’, ‘ls1’, ‘i’] insert_index_neq >>
  fs []
QED

Theorem distinct_keys_insert:
  ∀ k v ls0 ls1.
  distinct_keys (list_t_v ls0) ⇒
  insert k v ls0 = Return ls1 ⇒
  distinct_keys (list_t_v ls1)
Proof
  Induct_on ‘ls0’ >~ [‘ListNil’]
  >-(
    rw [distinct_keys_def, list_t_v_def, insert_def] >>
    fs [list_t_v_def, len_def] >>
    int_tac) >>  
  Cases >>
  pure_once_rewrite_tac [insert_def] >> fs[] >>
  rw [] >> fs []
  >-(
    (* k = q *)
    last_x_assum ignore_tac >>
    fs [distinct_keys_def] >>
    rw [] >>
    last_x_assum (qspecl_assume [‘i’, ‘j’]) >>
    rfs [list_t_v_def, len_def] >>
    sg ‘0 < j’ >- int_tac >>
    Cases_on ‘i = 0’ >> gvs [index_eq]) >>
  (* k ≠ q: recursion *)
  Cases_on ‘insert k v ls0’ >> fs [bind_def] >>
  last_x_assum (qspecl_assume [‘k’, ‘v’, ‘a’]) >>
  gvs [list_t_v_def] >>
  imp_res_tac distinct_keys_tail >> fs [] >>
  irule distinct_keys_cons >> rw [] >>
  metis_tac [distinct_keys_insert_index_neq]
QED  

Theorem insert_lem:
  !ls key value.
    (* The keys are pairwise distinct *)
    distinct_keys (list_t_v ls) ==>
    case insert key value ls of
    | Return ls1 =>
      (* We updated the binding *)
      lookup key ls1 = SOME value /\
      (* The other bindings are left unchanged *)
      (!k. k <> key ==> lookup k ls = lookup k ls1) ∧
      (* The keys are still pairwise disjoint *)
      distinct_keys (list_t_v ls1)
    | Fail _ => F
    | Diverge => F
Proof
  rw [] >>
  qspecl_assume [‘ls’, ‘key’, ‘value’] insert_lem_aux >>
  case_tac >> fs [] >>
  metis_tac [distinct_keys_insert]
QED

(*
 * Invariant proof 2: functional version of the invariant
 *)

val pairwise_rel_def = Define ‘
  pairwise_rel p [] = T ∧
  pairwise_rel p (x :: ls) = (for_all (p x) ls ∧ pairwise_rel p ls)
’

val distinct_keys_f_def = Define ‘
  distinct_keys_f (ls : (u32 # 't) list) =
    pairwise_rel (\x y. FST x ≠ FST y) ls
’

Theorem distinct_keys_f_insert_for_all:
  ∀k v k1 ls0 ls1.
  k1 ≠ k ⇒
  for_all (λy. k1 ≠ FST y) (list_t_v ls0) ⇒
  pairwise_rel (λx y. FST x ≠ FST y) (list_t_v ls0) ⇒
  insert k v ls0 = Return ls1 ⇒
  for_all (λy. k1 ≠ FST y) (list_t_v ls1)
Proof
  Induct_on ‘ls0’ >> rw [pairwise_rel_def] >~ [‘ListNil’] >>
  gvs [list_t_v_def, pairwise_rel_def, for_all_def]
  >-(gvs [MK_BOUNDED insert_def 1, bind_def, list_t_v_def, for_all_def]) >>
  pat_undisch_tac ‘insert _ _ _ = _’ >>
  simp [MK_BOUNDED insert_def 1, bind_def] >>
  Cases_on ‘t’ >> rw [] >> gvs [list_t_v_def, pairwise_rel_def, for_all_def] >>
  Cases_on ‘insert k v ls0’ >>
  gvs [distinct_keys_f_def, list_t_v_def, pairwise_rel_def, for_all_def] >>
  metis_tac []
QED

Theorem distinct_keys_f_insert:
  ∀ k v ls0 ls1.
  distinct_keys_f (list_t_v ls0) ⇒
  insert k v ls0 = Return ls1 ⇒
  distinct_keys_f (list_t_v ls1)
Proof
  Induct_on ‘ls0’ >> rw [distinct_keys_f_def] >~ [‘ListNil’]
  >-(
    fs [list_t_v_def, insert_def] >>
    gvs [list_t_v_def, pairwise_rel_def, for_all_def]) >>
  last_x_assum (qspecl_assume [‘k’, ‘v’]) >>
  pat_undisch_tac ‘insert _ _ _ = _’ >>
  simp [MK_BOUNDED insert_def 1, bind_def] >>
  (* TODO: improve case_tac *)
  Cases_on ‘t’ >> rw [] >> gvs [list_t_v_def, pairwise_rel_def, for_all_def] >>
  Cases_on ‘insert k v ls0’ >>
  gvs [distinct_keys_f_def, list_t_v_def, pairwise_rel_def, for_all_def] >>
  metis_tac [distinct_keys_f_insert_for_all]
QED

(*
 * Proving equivalence between the two version - exercise.
 *)
Theorem for_all_quant:
  ∀p ls. for_all p ls ⇔ ∀i. 0 ≤ i ⇒ i < len ls ⇒ p (index i ls)
Proof
  strip_tac >> Induct_on ‘ls’
  >-(rw [for_all_def, len_def] >> int_tac) >>
  rw [for_all_def, len_def, index_eq] >>
  equiv_tac
  >-(
    rw [] >>
    Cases_on ‘i = 0’ >> fs [] >>
    first_x_assum irule >>
    int_tac) >>
  rw []
  >-(
    first_x_assum (qspec_assume ‘0’) >> fs [] >>
    first_x_assum irule >>
    qspec_assume ‘ls’ len_pos >>
    int_tac) >>
  first_x_assum (qspec_assume ‘i + 1’) >>
  fs [] >>
  sg ‘i + 1 ≠ 0 ∧ i + 1 - 1 = i’ >- int_tac >> fs [] >>
  first_x_assum irule >> int_tac
QED

Theorem pairwise_rel_quant:
  ∀p ls. pairwise_rel p ls ⇔
    (∀i j. 0 ≤ i ⇒ i < j ⇒ j < len ls ⇒ p (index i ls) (index j ls))
Proof
  strip_tac >> Induct_on ‘ls’
  >-(rw [pairwise_rel_def, len_def] >> int_tac) >>
  rw [pairwise_rel_def, len_def] >>
  equiv_tac
  >-(
    (* ==> *)
    rw [] >>
    sg ‘0 < j’ >- int_tac >>
    Cases_on ‘i = 0’
    >-(
      simp [index_eq] >>
      qspecl_assume [‘p h’, ‘ls’] (iffLR for_all_quant) >>
      first_x_assum irule >> fs [] >> int_tac
    ) >>
    rw [index_eq] >>
    first_x_assum irule >> int_tac
  ) >>
  (* <== *)
  rw []
  >-(
    rw [for_all_quant] >>
    first_x_assum (qspecl_assume [‘0’, ‘i + 1’]) >>
    sg ‘0 < i + 1 ∧ i + 1 - 1 = i’ >- int_tac >>
    fs [index_eq] >>
    first_x_assum irule >> int_tac
  ) >>
  sg ‘pairwise_rel p ls’
  >-(
    rw [pairwise_rel_def] >>
    first_x_assum (qspecl_assume [‘i' + 1’, ‘j' + 1’]) >>
    sg ‘0 < i' + 1 ∧ 0 < j' + 1’ >- int_tac >>
    fs [index_eq, int_add_minus_same_eq] >>
    first_x_assum irule >> int_tac
  ) >>
  fs []
QED

Theorem distinct_keys_f_eq_distinct_keys:
  ∀ ls.
  distinct_keys_f ls ⇔ distinct_keys ls
Proof
  rw [distinct_keys_def, distinct_keys_f_def] >>
  qspecl_assume [‘(λx y. FST x ≠ FST y)’, ‘ls’] pairwise_rel_quant >>
  fs []
QED

val _ = export_theory ()
