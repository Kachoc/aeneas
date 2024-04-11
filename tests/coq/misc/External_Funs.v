(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [external]: function definitions *)
Require Import Primitives.
Import Primitives.
Require Import Coq.ZArith.ZArith.
Require Import List.
Import ListNotations.
Local Open Scope Primitives_scope.
Require Import External_Types.
Include External_Types.
Require Import External_FunsExternal.
Include External_FunsExternal.
Module External_Funs.

(** [external::swap]:
    Source: 'src/external.rs', lines 6:0-6:46 *)
Definition swap
  (T : Type) (x : T) (y : T) (st : state) : result (state * (T * T)) :=
  core_mem_swap T x y st
.

(** [external::test_new_non_zero_u32]:
    Source: 'src/external.rs', lines 11:0-11:60 *)
Definition test_new_non_zero_u32
  (x : u32) (st : state) : result (state * core_num_nonzero_NonZeroU32_t) :=
  p <- core_num_nonzero_NonZeroU32_new x st;
  let (st1, o) := p in
  core_option_Option_unwrap core_num_nonzero_NonZeroU32_t o st1
.

(** [external::test_vec]:
    Source: 'src/external.rs', lines 17:0-17:17 *)
Definition test_vec : result unit :=
  _ <- alloc_vec_Vec_push u32 (alloc_vec_Vec_new u32) 0%u32; Ok tt
.

(** Unit test for [external::test_vec] *)
Check (test_vec )%return.

(** [external::custom_swap]:
    Source: 'src/external.rs', lines 24:0-24:66 *)
Definition custom_swap
  (T : Type) (x : T) (y : T) (st : state) :
  result (state * (T * (T -> state -> result (state * (T * T)))))
  :=
  p <- core_mem_swap T x y st;
  let (st1, p1) := p in
  let (x1, y1) := p1 in
  let back := fun (ret : T) (st2 : state) => Ok (st2, (ret, y1)) in
  Ok (st1, (x1, back))
.

(** [external::test_custom_swap]:
    Source: 'src/external.rs', lines 29:0-29:59 *)
Definition test_custom_swap
  (x : u32) (y : u32) (st : state) : result (state * (u32 * u32)) :=
  p <- custom_swap u32 x y st;
  let (st1, p1) := p in
  let (_, custom_swap_back) := p1 in
  p2 <- custom_swap_back 1%u32 st1;
  let (_, p3) := p2 in
  let (x1, y1) := p3 in
  Ok (st1, (x1, y1))
.

(** [external::test_swap_non_zero]:
    Source: 'src/external.rs', lines 35:0-35:44 *)
Definition test_swap_non_zero (x : u32) (st : state) : result (state * u32) :=
  p <- swap u32 x 0%u32 st;
  let (st1, p1) := p in
  let (x1, _) := p1 in
  if x1 s= 0%u32 then Fail_ Failure else Ok (st1, x1)
.

End External_Funs.
