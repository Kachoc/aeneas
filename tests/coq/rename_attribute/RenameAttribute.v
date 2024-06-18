(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [rename_attribute] *)
Require Import Primitives.
Import Primitives.
Require Import Coq.ZArith.ZArith.
Require Import List.
Import ListNotations.
Local Open Scope Primitives_scope.
Module RenameAttribute.

(** Trait declaration: [rename_attribute::BoolTrait]
    Source: 'tests/src/rename_attribute.rs', lines 7:0-7:19 *)
Record BoolTest_t (Self : Type) := mkBoolTest_t {
  BoolTest_t_getTest : Self -> result bool;
}.

Arguments mkBoolTest_t { _ }.
Arguments BoolTest_t_getTest { _ }.

(** [rename_attribute::{(rename_attribute::BoolTrait for bool)}::get_bool]:
    Source: 'tests/src/rename_attribute.rs', lines 21:4-21:30 *)
Definition boolTraitBool_getTest (self : bool) : result bool :=
  Ok self.

(** Trait implementation: [rename_attribute::{(rename_attribute::BoolTrait for bool)}]
    Source: 'tests/src/rename_attribute.rs', lines 20:0-20:23 *)
Definition BoolImpl : BoolTest_t bool := {|
  BoolTest_t_getTest := boolTraitBool_getTest;
|}.

(** [rename_attribute::BoolTrait::ret_true]:
    Source: 'tests/src/rename_attribute.rs', lines 14:4-14:30 *)
Definition boolTrait_retTest
  {Self : Type} (self_clause : BoolTest_t Self) (self : Self) : result bool :=
  Ok true
.

(** [rename_attribute::test_bool_trait]:
    Source: 'tests/src/rename_attribute.rs', lines 27:0-27:42 *)
Definition boolFn (T : Type) (x : bool) : result bool :=
  b <- boolTraitBool_getTest x;
  if b then boolTrait_retTest BoolImpl x else Ok false
.

(** [rename_attribute::SimpleEnum]
    Source: 'tests/src/rename_attribute.rs', lines 35:0-35:15 *)
Inductive VariantsTest_t :=
| VariantsTest_Variant1 : VariantsTest_t
| VariantsTest_SecondVariant : VariantsTest_t
| VariantsTest_ThirdVariant : VariantsTest_t
.

(** [rename_attribute::Foo]
    Source: 'tests/src/rename_attribute.rs', lines 43:0-43:10 *)
Record StructTest_t := mkStructTest_t { structTest_FieldTest : u32; }.

(** [rename_attribute::C]
    Source: 'tests/src/rename_attribute.rs', lines 49:0-49:12 *)
Definition const_test_body : result u32 :=
  i <- u32_add 100%u32 10%u32; u32_add i 1%u32
.
Definition const_test : u32 := const_test_body%global.

(** [rename_attribute::CA]
    Source: 'tests/src/rename_attribute.rs', lines 52:0-52:13 *)
Definition const_aeneas11_body : result u32 := u32_add 10%u32 1%u32.
Definition const_aeneas11 : u32 := const_aeneas11_body%global.

(** [rename_attribute::factorial]:
    Source: 'tests/src/rename_attribute.rs', lines 55:0-55:27 *)
Fixpoint factfn (n : u64) : result u64 :=
  if n s<= 1%u64
  then Ok 1%u64
  else (i <- u64_sub n 1%u64; i1 <- factfn i; u64_mul n i1)
.

(** [rename_attribute::sum]: loop 0:
    Source: 'tests/src/rename_attribute.rs', lines 64:0-64:27 *)
Fixpoint no_borrows_sum_loop (max : u32) (i : u32) (s : u32) : result u32 :=
  if i s< max
  then (
    s1 <- u32_add s i; i1 <- u32_add i 1%u32; no_borrows_sum_loop max i1 s1)
  else u32_mul s 2%u32
.

(** [rename_attribute::sum]:
    Source: 'tests/src/rename_attribute.rs', lines 64:0-64:27 *)
Definition no_borrows_sum (max : u32) : result u32 :=
  no_borrows_sum_loop max 0%u32 0%u32
.

End RenameAttribute.
