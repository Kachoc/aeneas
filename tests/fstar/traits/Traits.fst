(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [traits] *)
module Traits
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** Trait declaration: [traits::BoolTrait]
    Source: 'tests/src/traits.rs', lines 3:0-11:1 *)
noeq type boolTrait_t (self : Type0) = {
  get_bool : self -> result bool;
  ret_true : self -> result bool;
}

(** [traits::{traits::BoolTrait for bool}::get_bool]:
    Source: 'tests/src/traits.rs', lines 14:4-16:5 *)
let boolTraitBool_get_bool (self : bool) : result bool =
  Ok self

(** [traits::{traits::BoolTrait for bool}::ret_true]:
    Source: 'tests/src/traits.rs', lines 8:4-10:5 *)
let boolTraitBool_ret_true (self : bool) : result bool =
  Ok true

(** Trait implementation: [traits::{traits::BoolTrait for bool}]
    Source: 'tests/src/traits.rs', lines 13:0-17:1 *)
let boolTraitBool : boolTrait_t bool = {
  get_bool = boolTraitBool_get_bool;
  ret_true = boolTraitBool_ret_true;
}

(** [traits::test_bool_trait_bool]:
    Source: 'tests/src/traits.rs', lines 19:0-21:1 *)
let test_bool_trait_bool (x : bool) : result bool =
  let* b = boolTraitBool_get_bool x in
  if b then boolTraitBool_ret_true x else Ok false

(** [traits::{traits::BoolTrait for core::option::Option<T>}#1::get_bool]:
    Source: 'tests/src/traits.rs', lines 25:4-30:5 *)
let boolTraitOption_get_bool (#t : Type0) (self : option t) : result bool =
  begin match self with | None -> Ok false | Some _ -> Ok true end

(** [traits::{traits::BoolTrait for core::option::Option<T>}#1::ret_true]:
    Source: 'tests/src/traits.rs', lines 8:4-10:5 *)
let boolTraitOption_ret_true (#t : Type0) (self : option t) : result bool =
  Ok true

(** Trait implementation: [traits::{traits::BoolTrait for core::option::Option<T>}#1]
    Source: 'tests/src/traits.rs', lines 24:0-31:1 *)
let boolTraitOption (t : Type0) : boolTrait_t (option t) = {
  get_bool = boolTraitOption_get_bool;
  ret_true = boolTraitOption_ret_true;
}

(** [traits::test_bool_trait_option]:
    Source: 'tests/src/traits.rs', lines 33:0-35:1 *)
let test_bool_trait_option (#t : Type0) (x : option t) : result bool =
  let* b = boolTraitOption_get_bool x in
  if b then boolTraitOption_ret_true x else Ok false

(** [traits::test_bool_trait]:
    Source: 'tests/src/traits.rs', lines 37:0-39:1 *)
let test_bool_trait
  (#t : Type0) (boolTraitInst : boolTrait_t t) (x : t) : result bool =
  boolTraitInst.get_bool x

(** Trait declaration: [traits::ToU64]
    Source: 'tests/src/traits.rs', lines 41:0-43:1 *)
noeq type toU64_t (self : Type0) = { to_u64 : self -> result u64; }

(** [traits::{traits::ToU64 for u64}#2::to_u64]:
    Source: 'tests/src/traits.rs', lines 46:4-48:5 *)
let toU64U64_to_u64 (self : u64) : result u64 =
  Ok self

(** Trait implementation: [traits::{traits::ToU64 for u64}#2]
    Source: 'tests/src/traits.rs', lines 45:0-49:1 *)
let toU64U64 : toU64_t u64 = { to_u64 = toU64U64_to_u64; }

(** [traits::{traits::ToU64 for (A, A)}#3::to_u64]:
    Source: 'tests/src/traits.rs', lines 52:4-54:5 *)
let toU64Pair_to_u64
  (#a : Type0) (toU64Inst : toU64_t a) (self : (a & a)) : result u64 =
  let (x, x1) = self in
  let* i = toU64Inst.to_u64 x in
  let* i1 = toU64Inst.to_u64 x1 in
  u64_add i i1

(** Trait implementation: [traits::{traits::ToU64 for (A, A)}#3]
    Source: 'tests/src/traits.rs', lines 51:0-55:1 *)
let toU64Pair (#a : Type0) (toU64Inst : toU64_t a) : toU64_t (a & a) = {
  to_u64 = toU64Pair_to_u64 toU64Inst;
}

(** [traits::f]:
    Source: 'tests/src/traits.rs', lines 57:0-59:1 *)
let f (#t : Type0) (toU64Inst : toU64_t t) (x : (t & t)) : result u64 =
  toU64Pair_to_u64 toU64Inst x

(** [traits::g]:
    Source: 'tests/src/traits.rs', lines 61:0-66:1 *)
let g
  (#t : Type0) (toU64PairInst : toU64_t (t & t)) (x : (t & t)) : result u64 =
  toU64PairInst.to_u64 x

(** [traits::h0]:
    Source: 'tests/src/traits.rs', lines 68:0-70:1 *)
let h0 (x : u64) : result u64 =
  toU64U64_to_u64 x

(** [traits::Wrapper]
    Source: 'tests/src/traits.rs', lines 72:0-74:1 *)
type wrapper_t (t : Type0) = { x : t; }

(** [traits::{traits::ToU64 for traits::Wrapper<T>}#4::to_u64]:
    Source: 'tests/src/traits.rs', lines 77:4-79:5 *)
let toU64traitsWrapper_to_u64
  (#t : Type0) (toU64Inst : toU64_t t) (self : wrapper_t t) : result u64 =
  toU64Inst.to_u64 self.x

(** Trait implementation: [traits::{traits::ToU64 for traits::Wrapper<T>}#4]
    Source: 'tests/src/traits.rs', lines 76:0-80:1 *)
let toU64traitsWrapper (#t : Type0) (toU64Inst : toU64_t t) : toU64_t
  (wrapper_t t) = {
  to_u64 = toU64traitsWrapper_to_u64 toU64Inst;
}

(** [traits::h1]:
    Source: 'tests/src/traits.rs', lines 82:0-84:1 *)
let h1 (x : wrapper_t u64) : result u64 =
  toU64traitsWrapper_to_u64 toU64U64 x

(** [traits::h2]:
    Source: 'tests/src/traits.rs', lines 86:0-88:1 *)
let h2 (#t : Type0) (toU64Inst : toU64_t t) (x : wrapper_t t) : result u64 =
  toU64traitsWrapper_to_u64 toU64Inst x

(** Trait declaration: [traits::ToType]
    Source: 'tests/src/traits.rs', lines 90:0-92:1 *)
noeq type toType_t (self : Type0) (t : Type0) = { to_type : self -> result t; }

(** [traits::{traits::ToType<bool> for u64}#5::to_type]:
    Source: 'tests/src/traits.rs', lines 95:4-97:5 *)
let toTypeU64Bool_to_type (self : u64) : result bool =
  Ok (self > 0)

(** Trait implementation: [traits::{traits::ToType<bool> for u64}#5]
    Source: 'tests/src/traits.rs', lines 94:0-98:1 *)
let toTypeU64Bool : toType_t u64 bool = { to_type = toTypeU64Bool_to_type; }

(** Trait declaration: [traits::OfType]
    Source: 'tests/src/traits.rs', lines 100:0-104:1 *)
noeq type ofType_t (self : Type0) = {
  of_type : (#t : Type0) -> (toTypeInst : toType_t t self) -> t -> result self;
}

(** [traits::h3]:
    Source: 'tests/src/traits.rs', lines 106:0-108:1 *)
let h3
  (#t1 : Type0) (#t2 : Type0) (ofTypeInst : ofType_t t1) (toTypeInst : toType_t
  t2 t1) (y : t2) :
  result t1
  =
  ofTypeInst.of_type toTypeInst y

(** Trait declaration: [traits::OfTypeBis]
    Source: 'tests/src/traits.rs', lines 111:0-118:1 *)
noeq type ofTypeBis_t (self : Type0) (t : Type0) = {
  toTypeInst : toType_t t self;
  of_type : t -> result self;
}

(** [traits::h4]:
    Source: 'tests/src/traits.rs', lines 120:0-122:1 *)
let h4
  (#t1 : Type0) (#t2 : Type0) (ofTypeBisInst : ofTypeBis_t t1 t2) (toTypeInst :
  toType_t t2 t1) (y : t2) :
  result t1
  =
  ofTypeBisInst.of_type y

(** [traits::TestType]
    Source: 'tests/src/traits.rs', lines 124:0-124:26 *)
type testType_t (t : Type0) = t

(** [traits::{traits::TestType<T>}#6::test::TestType1]
    Source: 'tests/src/traits.rs', lines 129:8-129:30 *)
type testType_test_TestType1_t = u64

(** [traits::{traits::TestType<T>}#6::test::{traits::{traits::TestType<T>}#6::test::TestTrait for traits::{traits::TestType<T>}#6::test::TestType1}::test]:
    Source: 'tests/src/traits.rs', lines 141:12-143:13 *)
let testType_test_TestTraittraitsTestTypetestTestType1_test
  (self : testType_test_TestType1_t) : result bool =
  Ok (self > 1)

(** [traits::{traits::TestType<T>}#6::test]:
    Source: 'tests/src/traits.rs', lines 128:4-149:5 *)
let testType_test
  (#t : Type0) (toU64Inst : toU64_t t) (self : testType_t t) (x : t) :
  result bool
  =
  let* x1 = toU64Inst.to_u64 x in
  if x1 > 0
  then testType_test_TestTraittraitsTestTypetestTestType1_test 0
  else Ok false

(** [traits::BoolWrapper]
    Source: 'tests/src/traits.rs', lines 152:0-152:33 *)
type boolWrapper_t = bool

(** [traits::{traits::ToType<T> for traits::BoolWrapper}#7::to_type]:
    Source: 'tests/src/traits.rs', lines 158:4-160:5 *)
let toTypetraitsBoolWrapperT_to_type
  (#t : Type0) (toTypeBoolTInst : toType_t bool t) (self : boolWrapper_t) :
  result t
  =
  toTypeBoolTInst.to_type self

(** Trait implementation: [traits::{traits::ToType<T> for traits::BoolWrapper}#7]
    Source: 'tests/src/traits.rs', lines 154:0-161:1 *)
let toTypetraitsBoolWrapperT (#t : Type0) (toTypeBoolTInst : toType_t bool t) :
  toType_t boolWrapper_t t = {
  to_type = toTypetraitsBoolWrapperT_to_type toTypeBoolTInst;
}

(** [traits::WithConstTy::LEN2]
    Source: 'tests/src/traits.rs', lines 166:4-166:27 *)
let with_const_ty_len2_default_body (self : Type0) (len : usize)
  : result usize =
  Ok 32
let with_const_ty_len2_default (self : Type0) (len : usize) : usize =
  eval_global (with_const_ty_len2_default_body self len)

(** Trait declaration: [traits::WithConstTy]
    Source: 'tests/src/traits.rs', lines 163:0-174:1 *)
noeq type withConstTy_t (self : Type0) (len : usize) = {
  cLEN1 : usize;
  cLEN2 : usize;
  tV : Type0;
  tW : Type0;
  toU64traitsWithConstTyWInst : toU64_t tW;
  f : tW -> array u8 len -> result tW;
}

(** [traits::{traits::WithConstTy<32: usize> for bool}#8::LEN1]
    Source: 'tests/src/traits.rs', lines 177:4-177:27 *)
let with_const_ty_bool32_len1_body : result usize = Ok 12
let with_const_ty_bool32_len1 : usize =
  eval_global with_const_ty_bool32_len1_body

(** [traits::{traits::WithConstTy<32: usize> for bool}#8::f]:
    Source: 'tests/src/traits.rs', lines 182:4-182:42 *)
let withConstTyBool32_f (i : u64) (a : array u8 32) : result u64 =
  Ok i

(** Trait implementation: [traits::{traits::WithConstTy<32: usize> for bool}#8]
    Source: 'tests/src/traits.rs', lines 176:0-183:1 *)
let withConstTyBool32 : withConstTy_t bool 32 = {
  cLEN1 = with_const_ty_bool32_len1;
  cLEN2 = with_const_ty_len2_default bool 32;
  tV = u8;
  tW = u64;
  toU64traitsWithConstTyWInst = toU64U64;
  f = withConstTyBool32_f;
}

(** [traits::use_with_const_ty1]:
    Source: 'tests/src/traits.rs', lines 185:0-187:1 *)
let use_with_const_ty1
  (#h : Type0) (#len : usize) (withConstTyInst : withConstTy_t h len) :
  result usize
  =
  Ok withConstTyInst.cLEN1

(** [traits::use_with_const_ty2]:
    Source: 'tests/src/traits.rs', lines 189:0-189:76 *)
let use_with_const_ty2
  (#h : Type0) (#len : usize) (withConstTyInst : withConstTy_t h len)
  (w : withConstTyInst.tW) :
  result unit
  =
  Ok ()

(** [traits::use_with_const_ty3]:
    Source: 'tests/src/traits.rs', lines 191:0-193:1 *)
let use_with_const_ty3
  (#h : Type0) (#len : usize) (withConstTyInst : withConstTy_t h len)
  (x : withConstTyInst.tW) :
  result u64
  =
  withConstTyInst.toU64traitsWithConstTyWInst.to_u64 x

(** [traits::test_where1]:
    Source: 'tests/src/traits.rs', lines 195:0-195:43 *)
let test_where1 (#t : Type0) (_x : t) : result unit =
  Ok ()

(** [traits::test_where2]:
    Source: 'tests/src/traits.rs', lines 196:0-196:60 *)
let test_where2
  (#t : Type0) (withConstTyT32Inst : withConstTy_t t 32) (_x : u32) :
  result unit
  =
  Ok ()

(** Trait declaration: [traits::ParentTrait0]
    Source: 'tests/src/traits.rs', lines 202:0-206:1 *)
noeq type parentTrait0_t (self : Type0) = {
  tW : Type0;
  get_name : self -> result string;
  get_w : self -> result tW;
}

(** Trait declaration: [traits::ParentTrait1]
    Source: 'tests/src/traits.rs', lines 207:0-207:25 *)
type parentTrait1_t (self : Type0) = unit

(** Trait declaration: [traits::ChildTrait]
    Source: 'tests/src/traits.rs', lines 208:0-208:52 *)
noeq type childTrait_t (self : Type0) = {
  parentTrait0Inst : parentTrait0_t self;
  parentTrait1Inst : parentTrait1_t self;
}

(** [traits::test_child_trait1]:
    Source: 'tests/src/traits.rs', lines 211:0-213:1 *)
let test_child_trait1
  (#t : Type0) (childTraitInst : childTrait_t t) (x : t) : result string =
  childTraitInst.parentTrait0Inst.get_name x

(** [traits::test_child_trait2]:
    Source: 'tests/src/traits.rs', lines 215:0-217:1 *)
let test_child_trait2
  (#t : Type0) (childTraitInst : childTrait_t t) (x : t) :
  result childTraitInst.parentTrait0Inst.tW
  =
  childTraitInst.parentTrait0Inst.get_w x

(** [traits::order1]:
    Source: 'tests/src/traits.rs', lines 221:0-221:62 *)
let order1
  (#t : Type0) (#u : Type0) (parentTrait0Inst : parentTrait0_t t)
  (parentTrait0Inst1 : parentTrait0_t u) :
  result unit
  =
  Ok ()

(** Trait declaration: [traits::ChildTrait1]
    Source: 'tests/src/traits.rs', lines 224:0-224:38 *)
noeq type childTrait1_t (self : Type0) = {
  parentTrait1Inst : parentTrait1_t self;
}

(** Trait implementation: [traits::{traits::ParentTrait1 for usize}#9]
    Source: 'tests/src/traits.rs', lines 226:0-226:30 *)
let parentTrait1Usize : parentTrait1_t usize = ()

(** Trait implementation: [traits::{traits::ChildTrait1 for usize}#10]
    Source: 'tests/src/traits.rs', lines 227:0-227:29 *)
let childTrait1Usize : childTrait1_t usize = {
  parentTrait1Inst = parentTrait1Usize;
}

(** Trait declaration: [traits::Iterator]
    Source: 'tests/src/traits.rs', lines 231:0-233:1 *)
noeq type iterator_t (self : Type0) = { tItem : Type0; }

(** Trait declaration: [traits::IntoIterator]
    Source: 'tests/src/traits.rs', lines 235:0-241:1 *)
noeq type intoIterator_t (self : Type0) = {
  tItem : Type0;
  tIntoIter : Type0;
  iteratortraitsIntoIteratorIntoIterInst : iterator_t tIntoIter;
  into_iter : self -> result tIntoIter;
}

(** Trait declaration: [traits::FromResidual]
    Source: 'tests/src/traits.rs', lines 252:0-252:24 *)
type fromResidual_t (self : Type0) (t : Type0) = unit

(** Trait declaration: [traits::Try]
    Source: 'tests/src/traits.rs', lines 248:0-250:1 *)
noeq type try_t (self : Type0) = {
  tResidual : Type0;
  fromResidualSelftraitsTryResidualInst : fromResidual_t self tResidual;
}

(** Trait declaration: [traits::WithTarget]
    Source: 'tests/src/traits.rs', lines 254:0-256:1 *)
noeq type withTarget_t (self : Type0) = { tTarget : Type0; }

(** Trait declaration: [traits::ParentTrait2]
    Source: 'tests/src/traits.rs', lines 258:0-260:1 *)
noeq type parentTrait2_t (self : Type0) = {
  tU : Type0;
  withTargettraitsParentTrait2UInst : withTarget_t tU;
}

(** Trait declaration: [traits::ChildTrait2]
    Source: 'tests/src/traits.rs', lines 262:0-264:1 *)
noeq type childTrait2_t (self : Type0) = {
  parentTrait2Inst : parentTrait2_t self;
  convert : parentTrait2Inst.tU -> result
    parentTrait2Inst.withTargettraitsParentTrait2UInst.tTarget;
}

(** Trait implementation: [traits::{traits::WithTarget for u32}#11]
    Source: 'tests/src/traits.rs', lines 266:0-268:1 *)
let withTargetU32 : withTarget_t u32 = { tTarget = u32; }

(** Trait implementation: [traits::{traits::ParentTrait2 for u32}#12]
    Source: 'tests/src/traits.rs', lines 270:0-272:1 *)
let parentTrait2U32 : parentTrait2_t u32 = {
  tU = u32;
  withTargettraitsParentTrait2UInst = withTargetU32;
}

(** [traits::{traits::ChildTrait2 for u32}#13::convert]:
    Source: 'tests/src/traits.rs', lines 275:4-277:5 *)
let childTrait2U32_convert (x : u32) : result u32 =
  Ok x

(** Trait implementation: [traits::{traits::ChildTrait2 for u32}#13]
    Source: 'tests/src/traits.rs', lines 274:0-278:1 *)
let childTrait2U32 : childTrait2_t u32 = {
  parentTrait2Inst = parentTrait2U32;
  convert = childTrait2U32_convert;
}

(** Trait declaration: [traits::CFnOnce]
    Source: 'tests/src/traits.rs', lines 288:0-292:1 *)
noeq type cFnOnce_t (self : Type0) (args : Type0) = {
  tOutput : Type0;
  call_once : self -> args -> result tOutput;
}

(** Trait declaration: [traits::CFnMut]
    Source: 'tests/src/traits.rs', lines 294:0-296:1 *)
noeq type cFnMut_t (self : Type0) (args : Type0) = {
  cFnOnceInst : cFnOnce_t self args;
  call_mut : self -> args -> result (cFnOnceInst.tOutput & self);
}

(** Trait declaration: [traits::CFn]
    Source: 'tests/src/traits.rs', lines 298:0-300:1 *)
noeq type cFn_t (self : Type0) (args : Type0) = {
  cFnMutInst : cFnMut_t self args;
  call : self -> args -> result cFnMutInst.cFnOnceInst.tOutput;
}

(** Trait declaration: [traits::GetTrait]
    Source: 'tests/src/traits.rs', lines 302:0-305:1 *)
noeq type getTrait_t (self : Type0) = { tW : Type0; get_w : self -> result tW;
}

(** [traits::test_get_trait]:
    Source: 'tests/src/traits.rs', lines 307:0-309:1 *)
let test_get_trait
  (#t : Type0) (getTraitInst : getTrait_t t) (x : t) : result getTraitInst.tW =
  getTraitInst.get_w x

(** Trait declaration: [traits::Trait]
    Source: 'tests/src/traits.rs', lines 312:0-314:1 *)
noeq type trait_t (self : Type0) = { cLEN : usize; }

(** [traits::{traits::Trait for @Array<T, N>}#14::LEN]
    Source: 'tests/src/traits.rs', lines 317:4-317:25 *)
let trait_array_len_body (t : Type0) (n : usize) : result usize = Ok n
let trait_array_len (t : Type0) (n : usize) : usize =
  eval_global (trait_array_len_body t n)

(** Trait implementation: [traits::{traits::Trait for @Array<T, N>}#14]
    Source: 'tests/src/traits.rs', lines 316:0-318:1 *)
let traitArray (t : Type0) (n : usize) : trait_t (array t n) = {
  cLEN = trait_array_len t n;
}

(** [traits::{traits::Trait for traits::Wrapper<T>}#15::LEN]
    Source: 'tests/src/traits.rs', lines 321:4-321:25 *)
let traittraits_wrapper_len_body (#t : Type0) (traitInst : trait_t t)
  : result usize =
  Ok 0
let traittraits_wrapper_len (#t : Type0) (traitInst : trait_t t) : usize =
  eval_global (traittraits_wrapper_len_body traitInst)

(** Trait implementation: [traits::{traits::Trait for traits::Wrapper<T>}#15]
    Source: 'tests/src/traits.rs', lines 320:0-322:1 *)
let traittraitsWrapper (#t : Type0) (traitInst : trait_t t) : trait_t
  (wrapper_t t) = {
  cLEN = traittraits_wrapper_len traitInst;
}

(** [traits::use_wrapper_len]:
    Source: 'tests/src/traits.rs', lines 324:0-326:1 *)
let use_wrapper_len (#t : Type0) (traitInst : trait_t t) : result usize =
  Ok (traittraitsWrapper traitInst).cLEN

(** [traits::Foo]
    Source: 'tests/src/traits.rs', lines 328:0-331:1 *)
type foo_t (t : Type0) (u : Type0) = { x : t; y : u; }

(** [core::result::Result]
    Source: '/rustc/library/core/src/result.rs', lines 527:0-527:21
    Name pattern: core::result::Result *)
type core_result_Result_t (t : Type0) (e : Type0) =
| Core_result_Result_Ok : t -> core_result_Result_t t e
| Core_result_Result_Err : e -> core_result_Result_t t e

(** [traits::{traits::Foo<T, U>}#16::FOO]
    Source: 'tests/src/traits.rs', lines 334:4-334:43 *)
let foo_foo_body (#t : Type0) (u : Type0) (traitInst : trait_t t)
  : result (core_result_Result_t t i32) =
  Ok (Core_result_Result_Err 0)
let foo_foo (#t : Type0) (u : Type0) (traitInst : trait_t t)
  : core_result_Result_t t i32 =
  eval_global (foo_foo_body u traitInst)

(** [traits::use_foo1]:
    Source: 'tests/src/traits.rs', lines 337:0-339:1 *)
let use_foo1
  (#t : Type0) (u : Type0) (traitInst : trait_t t) :
  result (core_result_Result_t t i32)
  =
  Ok (foo_foo u traitInst)

(** [traits::use_foo2]:
    Source: 'tests/src/traits.rs', lines 341:0-343:1 *)
let use_foo2
  (t : Type0) (#u : Type0) (traitInst : trait_t u) :
  result (core_result_Result_t u i32)
  =
  Ok (foo_foo t traitInst)

(** [traits::BoolTrait::ret_true]:
    Source: 'tests/src/traits.rs', lines 8:4-10:5 *)
let boolTrait_ret_true_default
  (#self : Type0) (self_clause : boolTrait_t self) (self1 : self) :
  result bool
  =
  Ok true

(** Trait declaration: [traits::{traits::TestType<T>}#6::test::TestTrait]
    Source: 'tests/src/traits.rs', lines 130:8-132:9 *)
noeq type testType_test_TestTrait_t (self : Type0) = {
  test : self -> result bool;
}

(** Trait implementation: [traits::{traits::TestType<T>}#6::test::{traits::{traits::TestType<T>}#6::test::TestTrait for traits::{traits::TestType<T>}#6::test::TestType1}]
    Source: 'tests/src/traits.rs', lines 140:8-144:9 *)
let testType_test_TestTraittraitsTestTypetestTestType1 :
  testType_test_TestTrait_t testType_test_TestType1_t = {
  test = testType_test_TestTraittraitsTestTypetestTestType1_test;
}

