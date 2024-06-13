(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [rename_attribute] *)
module RenameAttribute
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** Trait declaration: [rename_attribute::BoolTrait]
    Source: 'tests/src/rename_attribute.rs', lines 7:0-7:19 *)
noeq type boolTest_t (self : Type0) = { getTest : self -> result bool; }

(** [rename_attribute::{(rename_attribute::BoolTrait for bool)}::get_bool]:
    Source: 'tests/src/rename_attribute.rs', lines 21:4-21:30 *)
let boolTraitBool_get_bool (self : bool) : result bool =
  Ok self

(** Trait implementation: [rename_attribute::{(rename_attribute::BoolTrait for bool)}]
    Source: 'tests/src/rename_attribute.rs', lines 20:0-20:23 *)
let boolImplBool : boolTest_t bool = { getTest = boolTraitBool_get_bool; }

(** [rename_attribute::BoolTrait::ret_true]:
    Source: 'tests/src/rename_attribute.rs', lines 14:4-14:30 *)
let boolTrait_retTest
  (#self : Type0) (self_clause : boolTest_t self) (self1 : self) :
  result bool
  =
  Ok true

(** [rename_attribute::test_bool_trait]:
    Source: 'tests/src/rename_attribute.rs', lines 27:0-27:42 *)
let boolFn (t : Type0) (x : bool) : result bool =
  let* b = boolTraitBool_get_bool x in
  if b then boolTrait_retTest boolImplBool x else Ok false

(** [rename_attribute::SimpleEnum]
    Source: 'tests/src/rename_attribute.rs', lines 35:0-35:15 *)
type variantsTest_t =
| SimpleEnum_Variant1 : variantsTest_t
| SimpleEnum_SecondVariant : variantsTest_t
| SimpleEnum_ThirdVariant : variantsTest_t

(** [rename_attribute::Foo]
    Source: 'tests/src/rename_attribute.rs', lines 43:0-43:10 *)
type structTest_t = { FieldTest : u32; }

(** [rename_attribute::C]
    Source: 'tests/src/rename_attribute.rs', lines 49:0-49:12 *)
let const_test_body : result u32 = let* i = u32_add 100 10 in u32_add i 1
let const_test : u32 = eval_global const_test_body

(** [rename_attribute::factorial]: decreases clause
    Source: 'tests/src/rename_attribute.rs', lines 55:0-55:27 *)
unfold let factfn_decreases (n : u64) : nat = admit ()

(** [rename_attribute::factorial]:
    Source: 'tests/src/rename_attribute.rs', lines 55:0-55:27 *)
let rec factfn (n : u64) : Tot (result u64) (decreases (factfn_decreases n)) =
  if n <= 1
  then Ok 1
  else let* i = u64_sub n 1 in let* i1 = factfn i in u64_mul n i1

(** [rename_attribute::sum]: decreases clause
    Source: 'tests/src/rename_attribute.rs', lines 64:0-64:27 *)
unfold
let no_borrows_sum_loop_decreases (max : u32) (i : u32) (s : u32) : nat =
  admit ()

(** [rename_attribute::sum]: loop 0:
    Source: 'tests/src/rename_attribute.rs', lines 64:0-64:27 *)
let rec no_borrows_sum_loop
  (max : u32) (i : u32) (s : u32) :
  Tot (result u32) (decreases (no_borrows_sum_loop_decreases max i s))
  =
  if i < max
  then
    let* s1 = u32_add s i in
    let* i1 = u32_add i 1 in
    no_borrows_sum_loop max i1 s1
  else u32_mul s 2

(** [rename_attribute::sum]:
    Source: 'tests/src/rename_attribute.rs', lines 64:0-64:27 *)
let no_borrows_sum (max : u32) : result u32 =
  no_borrows_sum_loop max 0 0

