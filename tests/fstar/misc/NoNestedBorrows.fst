(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [no_nested_borrows] *)
module NoNestedBorrows
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [no_nested_borrows::Pair] *)
type pair_t (t1 t2 : Type0) = { pair_x : t1; pair_y : t2; }

(** [no_nested_borrows::List] *)
type list_t (t : Type0) =
| ListCons : t -> list_t t -> list_t t
| ListNil : list_t t

(** [no_nested_borrows::One] *)
type one_t (t1 : Type0) = | OneOne : t1 -> one_t t1

(** [no_nested_borrows::EmptyEnum] *)
type empty_enum_t = | EmptyEnumEmpty : empty_enum_t

(** [no_nested_borrows::Enum] *)
type enum_t = | EnumVariant1 : enum_t | EnumVariant2 : enum_t

(** [no_nested_borrows::EmptyStruct] *)
type empty_struct_t = unit

(** [no_nested_borrows::Sum] *)
type sum_t (t1 t2 : Type0) =
| SumLeft : t1 -> sum_t t1 t2
| SumRight : t2 -> sum_t t1 t2

(** [no_nested_borrows::neg_test] *)
let neg_test_fwd (x : i32) : result i32 =
  i32_neg x

(** [no_nested_borrows::add_test] *)
let add_test_fwd (x : u32) (y : u32) : result u32 =
  u32_add x y

(** [no_nested_borrows::subs_test] *)
let subs_test_fwd (x : u32) (y : u32) : result u32 =
  u32_sub x y

(** [no_nested_borrows::div_test] *)
let div_test_fwd (x : u32) (y : u32) : result u32 =
  u32_div x y

(** [no_nested_borrows::div_test1] *)
let div_test1_fwd (x : u32) : result u32 =
  u32_div x 2

(** [no_nested_borrows::rem_test] *)
let rem_test_fwd (x : u32) (y : u32) : result u32 =
  u32_rem x y

(** [no_nested_borrows::cast_test] *)
let cast_test_fwd (x : u32) : result i32 =
  scalar_cast U32 I32 x

(** [no_nested_borrows::test2] *)
let test2_fwd : result unit =
  let* _ = u32_add 23 44 in Return ()

(** Unit test for [no_nested_borrows::test2] *)
let _ = assert_norm (test2_fwd = Return ())

(** [no_nested_borrows::get_max] *)
let get_max_fwd (x : u32) (y : u32) : result u32 =
  if x >= y then Return x else Return y

(** [no_nested_borrows::test3] *)
let test3_fwd : result unit =
  let* x = get_max_fwd 4 3 in
  let* y = get_max_fwd 10 11 in
  let* z = u32_add x y in
  if not (z = 15) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test3] *)
let _ = assert_norm (test3_fwd = Return ())

(** [no_nested_borrows::test_neg1] *)
let test_neg1_fwd : result unit =
  let* y = i32_neg 3 in if not (y = -3) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_neg1] *)
let _ = assert_norm (test_neg1_fwd = Return ())

(** [no_nested_borrows::refs_test1] *)
let refs_test1_fwd : result unit =
  if not (1 = 1) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::refs_test1] *)
let _ = assert_norm (refs_test1_fwd = Return ())

(** [no_nested_borrows::refs_test2] *)
let refs_test2_fwd : result unit =
  if not (2 = 2)
  then Fail Failure
  else
    if not (0 = 0)
    then Fail Failure
    else
      if not (2 = 2)
      then Fail Failure
      else if not (2 = 2) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::refs_test2] *)
let _ = assert_norm (refs_test2_fwd = Return ())

(** [no_nested_borrows::test_list1] *)
let test_list1_fwd : result unit =
  Return ()

(** Unit test for [no_nested_borrows::test_list1] *)
let _ = assert_norm (test_list1_fwd = Return ())

(** [no_nested_borrows::test_box1] *)
let test_box1_fwd : result unit =
  let b = 1 in let x = b in if not (x = 1) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_box1] *)
let _ = assert_norm (test_box1_fwd = Return ())

(** [no_nested_borrows::copy_int] *)
let copy_int_fwd (x : i32) : result i32 =
  Return x

(** [no_nested_borrows::test_unreachable] *)
let test_unreachable_fwd (b : bool) : result unit =
  if b then Fail Failure else Return ()

(** [no_nested_borrows::test_panic] *)
let test_panic_fwd (b : bool) : result unit =
  if b then Fail Failure else Return ()

(** [no_nested_borrows::test_copy_int] *)
let test_copy_int_fwd : result unit =
  let* y = copy_int_fwd 0 in if not (0 = y) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_copy_int] *)
let _ = assert_norm (test_copy_int_fwd = Return ())

(** [no_nested_borrows::is_cons] *)
let is_cons_fwd (t : Type0) (l : list_t t) : result bool =
  begin match l with
  | ListCons x l0 -> Return true
  | ListNil -> Return false
  end

(** [no_nested_borrows::test_is_cons] *)
let test_is_cons_fwd : result unit =
  let l = ListNil in
  let* b = is_cons_fwd i32 (ListCons 0 l) in
  if not b then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_is_cons] *)
let _ = assert_norm (test_is_cons_fwd = Return ())

(** [no_nested_borrows::split_list] *)
let split_list_fwd (t : Type0) (l : list_t t) : result (t & (list_t t)) =
  begin match l with
  | ListCons hd tl -> Return (hd, tl)
  | ListNil -> Fail Failure
  end

(** [no_nested_borrows::test_split_list] *)
let test_split_list_fwd : result unit =
  let l = ListNil in
  let* p = split_list_fwd i32 (ListCons 0 l) in
  let (hd, _) = p in
  if not (hd = 0) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_split_list] *)
let _ = assert_norm (test_split_list_fwd = Return ())

(** [no_nested_borrows::choose] *)
let choose_fwd (t : Type0) (b : bool) (x : t) (y : t) : result t =
  if b then Return x else Return y

(** [no_nested_borrows::choose] *)
let choose_back
  (t : Type0) (b : bool) (x : t) (y : t) (ret : t) : result (t & t) =
  if b then Return (ret, y) else Return (x, ret)

(** [no_nested_borrows::choose_test] *)
let choose_test_fwd : result unit =
  let* z = choose_fwd i32 true 0 0 in
  let* z0 = i32_add z 1 in
  if not (z0 = 1)
  then Fail Failure
  else
    let* (x, y) = choose_back i32 true 0 0 z0 in
    if not (x = 1)
    then Fail Failure
    else if not (y = 0) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::choose_test] *)
let _ = assert_norm (choose_test_fwd = Return ())

(** [no_nested_borrows::test_char] *)
let test_char_fwd : result char =
  Return 'a'

(** [no_nested_borrows::NodeElem] *)
type node_elem_t (t : Type0) =
| NodeElemCons : tree_t t -> node_elem_t t -> node_elem_t t
| NodeElemNil : node_elem_t t

(** [no_nested_borrows::Tree] *)
and tree_t (t : Type0) =
| TreeLeaf : t -> tree_t t
| TreeNode : t -> node_elem_t t -> tree_t t -> tree_t t

(** [no_nested_borrows::list_length] *)
let rec list_length_fwd (t : Type0) (l : list_t t) : result u32 =
  begin match l with
  | ListCons x l1 -> let* i = list_length_fwd t l1 in u32_add 1 i
  | ListNil -> Return 0
  end

(** [no_nested_borrows::list_nth_shared] *)
let rec list_nth_shared_fwd (t : Type0) (l : list_t t) (i : u32) : result t =
  begin match l with
  | ListCons x tl ->
    if i = 0
    then Return x
    else let* i0 = u32_sub i 1 in list_nth_shared_fwd t tl i0
  | ListNil -> Fail Failure
  end

(** [no_nested_borrows::list_nth_mut] *)
let rec list_nth_mut_fwd (t : Type0) (l : list_t t) (i : u32) : result t =
  begin match l with
  | ListCons x tl ->
    if i = 0
    then Return x
    else let* i0 = u32_sub i 1 in list_nth_mut_fwd t tl i0
  | ListNil -> Fail Failure
  end

(** [no_nested_borrows::list_nth_mut] *)
let rec list_nth_mut_back
  (t : Type0) (l : list_t t) (i : u32) (ret : t) : result (list_t t) =
  begin match l with
  | ListCons x tl ->
    if i = 0
    then Return (ListCons ret tl)
    else
      let* i0 = u32_sub i 1 in
      let* tl0 = list_nth_mut_back t tl i0 ret in
      Return (ListCons x tl0)
  | ListNil -> Fail Failure
  end

(** [no_nested_borrows::list_rev_aux] *)
let rec list_rev_aux_fwd
  (t : Type0) (li : list_t t) (lo : list_t t) : result (list_t t) =
  begin match li with
  | ListCons hd tl -> list_rev_aux_fwd t tl (ListCons hd lo)
  | ListNil -> Return lo
  end

(** [no_nested_borrows::list_rev] *)
let list_rev_fwd_back (t : Type0) (l : list_t t) : result (list_t t) =
  let li = mem_replace_fwd (list_t t) l ListNil in
  list_rev_aux_fwd t li ListNil

(** [no_nested_borrows::test_list_functions] *)
let test_list_functions_fwd : result unit =
  let l = ListNil in
  let l0 = ListCons 2 l in
  let l1 = ListCons 1 l0 in
  let* i = list_length_fwd i32 (ListCons 0 l1) in
  if not (i = 3)
  then Fail Failure
  else
    let* i0 = list_nth_shared_fwd i32 (ListCons 0 l1) 0 in
    if not (i0 = 0)
    then Fail Failure
    else
      let* i1 = list_nth_shared_fwd i32 (ListCons 0 l1) 1 in
      if not (i1 = 1)
      then Fail Failure
      else
        let* i2 = list_nth_shared_fwd i32 (ListCons 0 l1) 2 in
        if not (i2 = 2)
        then Fail Failure
        else
          let* ls = list_nth_mut_back i32 (ListCons 0 l1) 1 3 in
          let* i3 = list_nth_shared_fwd i32 ls 0 in
          if not (i3 = 0)
          then Fail Failure
          else
            let* i4 = list_nth_shared_fwd i32 ls 1 in
            if not (i4 = 3)
            then Fail Failure
            else
              let* i5 = list_nth_shared_fwd i32 ls 2 in
              if not (i5 = 2) then Fail Failure else Return ()

(** Unit test for [no_nested_borrows::test_list_functions] *)
let _ = assert_norm (test_list_functions_fwd = Return ())

(** [no_nested_borrows::id_mut_pair1] *)
let id_mut_pair1_fwd (t1 t2 : Type0) (x : t1) (y : t2) : result (t1 & t2) =
  Return (x, y)

(** [no_nested_borrows::id_mut_pair1] *)
let id_mut_pair1_back
  (t1 t2 : Type0) (x : t1) (y : t2) (ret : (t1 & t2)) : result (t1 & t2) =
  let (x0, x1) = ret in Return (x0, x1)

(** [no_nested_borrows::id_mut_pair2] *)
let id_mut_pair2_fwd (t1 t2 : Type0) (p : (t1 & t2)) : result (t1 & t2) =
  let (x, x0) = p in Return (x, x0)

(** [no_nested_borrows::id_mut_pair2] *)
let id_mut_pair2_back
  (t1 t2 : Type0) (p : (t1 & t2)) (ret : (t1 & t2)) : result (t1 & t2) =
  let (x, x0) = ret in Return (x, x0)

(** [no_nested_borrows::id_mut_pair3] *)
let id_mut_pair3_fwd (t1 t2 : Type0) (x : t1) (y : t2) : result (t1 & t2) =
  Return (x, y)

(** [no_nested_borrows::id_mut_pair3] *)
let id_mut_pair3_back'a
  (t1 t2 : Type0) (x : t1) (y : t2) (ret : t1) : result t1 =
  Return ret

(** [no_nested_borrows::id_mut_pair3] *)
let id_mut_pair3_back'b
  (t1 t2 : Type0) (x : t1) (y : t2) (ret : t2) : result t2 =
  Return ret

(** [no_nested_borrows::id_mut_pair4] *)
let id_mut_pair4_fwd (t1 t2 : Type0) (p : (t1 & t2)) : result (t1 & t2) =
  let (x, x0) = p in Return (x, x0)

(** [no_nested_borrows::id_mut_pair4] *)
let id_mut_pair4_back'a
  (t1 t2 : Type0) (p : (t1 & t2)) (ret : t1) : result t1 =
  Return ret

(** [no_nested_borrows::id_mut_pair4] *)
let id_mut_pair4_back'b
  (t1 t2 : Type0) (p : (t1 & t2)) (ret : t2) : result t2 =
  Return ret

(** [no_nested_borrows::StructWithTuple] *)
type struct_with_tuple_t (t1 t2 : Type0) = { struct_with_tuple_p : (t1 & t2); }

(** [no_nested_borrows::new_tuple1] *)
let new_tuple1_fwd : result (struct_with_tuple_t u32 u32) =
  Return (Mkstruct_with_tuple_t (1, 2))

(** [no_nested_borrows::new_tuple2] *)
let new_tuple2_fwd : result (struct_with_tuple_t i16 i16) =
  Return (Mkstruct_with_tuple_t (1, 2))

(** [no_nested_borrows::new_tuple3] *)
let new_tuple3_fwd : result (struct_with_tuple_t u64 i64) =
  Return (Mkstruct_with_tuple_t (1, 2))

(** [no_nested_borrows::StructWithPair] *)
type struct_with_pair_t (t1 t2 : Type0) =
{
  struct_with_pair_p : pair_t t1 t2;
}

(** [no_nested_borrows::new_pair1] *)
let new_pair1_fwd : result (struct_with_pair_t u32 u32) =
  Return (Mkstruct_with_pair_t (Mkpair_t 1 2))

(** [no_nested_borrows::test_constants] *)
let test_constants_fwd : result unit =
  let* swt = new_tuple1_fwd in
  let (i, _) = swt.struct_with_tuple_p in
  if not (i = 1)
  then Fail Failure
  else
    let* swt0 = new_tuple2_fwd in
    let (i0, _) = swt0.struct_with_tuple_p in
    if not (i0 = 1)
    then Fail Failure
    else
      let* swt1 = new_tuple3_fwd in
      let (i1, _) = swt1.struct_with_tuple_p in
      if not (i1 = 1)
      then Fail Failure
      else
        let* swp = new_pair1_fwd in
        if not (swp.struct_with_pair_p.pair_x = 1)
        then Fail Failure
        else Return ()

(** Unit test for [no_nested_borrows::test_constants] *)
let _ = assert_norm (test_constants_fwd = Return ())

(** [no_nested_borrows::test_weird_borrows1] *)
let test_weird_borrows1_fwd : result unit =
  Return ()

(** Unit test for [no_nested_borrows::test_weird_borrows1] *)
let _ = assert_norm (test_weird_borrows1_fwd = Return ())

(** [no_nested_borrows::test_mem_replace] *)
let test_mem_replace_fwd_back (px : u32) : result u32 =
  let y = mem_replace_fwd u32 px 1 in
  if not (y = 0) then Fail Failure else Return 2

(** [no_nested_borrows::test_shared_borrow_bool1] *)
let test_shared_borrow_bool1_fwd (b : bool) : result u32 =
  if b then Return 0 else Return 1

(** [no_nested_borrows::test_shared_borrow_bool2] *)
let test_shared_borrow_bool2_fwd : result u32 =
  Return 0

(** [no_nested_borrows::test_shared_borrow_enum1] *)
let test_shared_borrow_enum1_fwd (l : list_t u32) : result u32 =
  begin match l with | ListCons i l0 -> Return 1 | ListNil -> Return 0 end

(** [no_nested_borrows::test_shared_borrow_enum2] *)
let test_shared_borrow_enum2_fwd : result u32 =
  Return 0

