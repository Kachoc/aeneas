(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [paper] *)
Require Import Primitives.
Import Primitives.
Require Import Coq.ZArith.ZArith.
Require Import List.
Import ListNotations.
Local Open Scope Primitives_scope.
Module Paper.

(** [paper::ref_incr]:
    Source: 'tests/src/paper.rs', lines 7:0-9:1 *)
Definition ref_incr (x : i32) : result i32 :=
  i32_add x 1%i32.

(** [paper::test_incr]:
    Source: 'tests/src/paper.rs', lines 11:0-15:1 *)
Definition test_incr : result unit :=
  x <- ref_incr 0%i32; if x s= 1%i32 then Ok tt else Fail_ Failure
.

(** Unit test for [paper::test_incr] *)
Check (test_incr)%return.

(** [paper::choose]:
    Source: 'tests/src/paper.rs', lines 18:0-24:1 *)
Definition choose
  {T : Type} (b : bool) (x : T) (y : T) : result (T * (T -> (T * T))) :=
  if b
  then let back := fun (ret : T) => (ret, y) in Ok (x, back)
  else let back := fun (ret : T) => (x, ret) in Ok (y, back)
.

(** [paper::test_choose]:
    Source: 'tests/src/paper.rs', lines 26:0-34:1 *)
Definition test_choose : result unit :=
  p <- choose true 0%i32 0%i32;
  let (z, choose_back) := p in
  z1 <- i32_add z 1%i32;
  if z1 s= 1%i32
  then
    let (x, y) := choose_back z1 in
    if x s= 1%i32
    then if y s= 0%i32 then Ok tt else Fail_ Failure
    else Fail_ Failure
  else Fail_ Failure
.

(** Unit test for [paper::test_choose] *)
Check (test_choose)%return.

(** [paper::List]
    Source: 'tests/src/paper.rs', lines 38:0-41:1 *)
Inductive List_t (T : Type) :=
| List_Cons : T -> List_t T -> List_t T
| List_Nil : List_t T
.

Arguments List_Cons { _ }.
Arguments List_Nil { _ }.

(** [paper::list_nth_mut]:
    Source: 'tests/src/paper.rs', lines 45:0-58:1 *)
Fixpoint list_nth_mut
  {T : Type} (l : List_t T) (i : u32) : result (T * (T -> List_t T)) :=
  match l with
  | List_Cons x tl =>
    if i s= 0%u32
    then let back := fun (ret : T) => List_Cons ret tl in Ok (x, back)
    else (
      i1 <- u32_sub i 1%u32;
      p <- list_nth_mut tl i1;
      let (t, list_nth_mut_back) := p in
      let back :=
        fun (ret : T) => let tl1 := list_nth_mut_back ret in List_Cons x tl1 in
      Ok (t, back))
  | List_Nil => Fail_ Failure
  end
.

(** [paper::sum]:
    Source: 'tests/src/paper.rs', lines 60:0-69:1 *)
Fixpoint sum (l : List_t i32) : result i32 :=
  match l with
  | List_Cons x tl => i <- sum tl; i32_add x i
  | List_Nil => Ok 0%i32
  end
.

(** [paper::test_nth]:
    Source: 'tests/src/paper.rs', lines 71:0-76:1 *)
Definition test_nth : result unit :=
  let l := List_Cons 3%i32 List_Nil in
  let l1 := List_Cons 2%i32 l in
  p <- list_nth_mut (List_Cons 1%i32 l1) 2%u32;
  let (x, list_nth_mut_back) := p in
  x1 <- i32_add x 1%i32;
  let l2 := list_nth_mut_back x1 in
  i <- sum l2;
  if i s= 7%i32 then Ok tt else Fail_ Failure
.

(** Unit test for [paper::test_nth] *)
Check (test_nth)%return.

(** [paper::call_choose]:
    Source: 'tests/src/paper.rs', lines 79:0-85:1 *)
Definition call_choose (p : (u32 * u32)) : result u32 :=
  let (px, py) := p in
  p1 <- choose true px py;
  let (pz, choose_back) := p1 in
  pz1 <- u32_add pz 1%u32;
  let (px1, _) := choose_back pz1 in
  Ok px1
.

End Paper.
