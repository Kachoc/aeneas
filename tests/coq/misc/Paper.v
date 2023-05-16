(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [paper] *)
Require Import Primitives.
Import Primitives.
Require Import Coq.ZArith.ZArith.
Local Open Scope Primitives_scope.
Module Paper.

(** [paper::ref_incr] *)
Definition ref_incr_fwd_back (x : i32) : result i32 :=
  i32_add x 1%i32.

(** [paper::test_incr] *)
Definition test_incr_fwd : result unit :=
  x <- ref_incr_fwd_back 0%i32;
  if negb (x s= 1%i32) then Fail_ Failure else Return tt
.

(** Unit test for [paper::test_incr] *)
Check (test_incr_fwd )%return.

(** [paper::choose] *)
Definition choose_fwd (T : Type) (b : bool) (x : T) (y : T) : result T :=
  if b then Return x else Return y
.

(** [paper::choose] *)
Definition choose_back
  (T : Type) (b : bool) (x : T) (y : T) (ret : T) : result (T * T) :=
  if b then Return (ret, y) else Return (x, ret)
.

(** [paper::test_choose] *)
Definition test_choose_fwd : result unit :=
  z <- choose_fwd i32 true 0%i32 0%i32;
  z0 <- i32_add z 1%i32;
  if negb (z0 s= 1%i32)
  then Fail_ Failure
  else (
    p <- choose_back i32 true 0%i32 0%i32 z0;
    let (x, y) := p in
    if negb (x s= 1%i32)
    then Fail_ Failure
    else if negb (y s= 0%i32) then Fail_ Failure else Return tt)
.

(** Unit test for [paper::test_choose] *)
Check (test_choose_fwd )%return.

(** [paper::List] *)
Inductive List_t (T : Type) :=
| ListCons : T -> List_t T -> List_t T
| ListNil : List_t T
.

Arguments ListCons {T} _ _.
Arguments ListNil {T}.

(** [paper::list_nth_mut] *)
Fixpoint list_nth_mut_fwd (T : Type) (l : List_t T) (i : u32) : result T :=
  match l with
  | ListCons x tl =>
    if i s= 0%u32
    then Return x
    else (i0 <- u32_sub i 1%u32; list_nth_mut_fwd T tl i0)
  | ListNil => Fail_ Failure
  end
.

(** [paper::list_nth_mut] *)
Fixpoint list_nth_mut_back
  (T : Type) (l : List_t T) (i : u32) (ret : T) : result (List_t T) :=
  match l with
  | ListCons x tl =>
    if i s= 0%u32
    then Return (ListCons ret tl)
    else (
      i0 <- u32_sub i 1%u32;
      tl0 <- list_nth_mut_back T tl i0 ret;
      Return (ListCons x tl0))
  | ListNil => Fail_ Failure
  end
.

(** [paper::sum] *)
Fixpoint sum_fwd (l : List_t i32) : result i32 :=
  match l with
  | ListCons x tl => i <- sum_fwd tl; i32_add x i
  | ListNil => Return 0%i32
  end
.

(** [paper::test_nth] *)
Definition test_nth_fwd : result unit :=
  let l := ListNil in
  let l0 := ListCons 3%i32 l in
  let l1 := ListCons 2%i32 l0 in
  x <- list_nth_mut_fwd i32 (ListCons 1%i32 l1) 2%u32;
  x0 <- i32_add x 1%i32;
  l2 <- list_nth_mut_back i32 (ListCons 1%i32 l1) 2%u32 x0;
  i <- sum_fwd l2;
  if negb (i s= 7%i32) then Fail_ Failure else Return tt
.

(** Unit test for [paper::test_nth] *)
Check (test_nth_fwd )%return.

(** [paper::call_choose] *)
Definition call_choose_fwd (p : (u32 * u32)) : result u32 :=
  let (px, py) := p in
  pz <- choose_fwd u32 true px py;
  pz0 <- u32_add pz 1%u32;
  p0 <- choose_back u32 true px py pz0;
  let (px0, _) := p0 in
  Return px0
.

End Paper .
