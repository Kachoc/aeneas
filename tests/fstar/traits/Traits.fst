(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [traits] *)
module Traits
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** Trait declaration: [traits::BoolTrait]
    Source: 'src/traits.rs', lines 1:0-1:19 *)
noeq type boolTrait_t (self : Type0) = { get_bool : self -> result bool; }

(** [traits::{(traits::BoolTrait for bool)}::get_bool]:
    Source: 'src/traits.rs', lines 12:4-12:30 *)
let boolTraitBool_get_bool (self : bool) : result bool =
  Ok self

(** Trait implementation: [traits::{(traits::BoolTrait for bool)}]
    Source: 'src/traits.rs', lines 11:0-11:23 *)
let boolTraitBool : boolTrait_t bool = { get_bool = boolTraitBool_get_bool; }

(** [traits::BoolTrait::ret_true]:
    Source: 'src/traits.rs', lines 6:4-6:30 *)
let boolTrait_ret_true
  (#self : Type0) (self_clause : boolTrait_t self) (self1 : self) :
  result bool
  =
  Ok true

(** [traits::test_bool_trait_bool]:
    Source: 'src/traits.rs', lines 17:0-17:44 *)
let test_bool_trait_bool (x : bool) : result bool =
  let* b = boolTraitBool_get_bool x in
  if b then boolTrait_ret_true boolTraitBool x else Ok false

(** [traits::{(traits::BoolTrait for core::option::Option<T>)#1}::get_bool]:
    Source: 'src/traits.rs', lines 23:4-23:30 *)
let boolTraitOption_get_bool (t : Type0) (self : option t) : result bool =
  begin match self with | None -> Ok false | Some _ -> Ok true end

(** Trait implementation: [traits::{(traits::BoolTrait for core::option::Option<T>)#1}]
    Source: 'src/traits.rs', lines 22:0-22:31 *)
let boolTraitOption (t : Type0) : boolTrait_t (option t) = {
  get_bool = boolTraitOption_get_bool t;
}

(** [traits::test_bool_trait_option]:
    Source: 'src/traits.rs', lines 31:0-31:54 *)
let test_bool_trait_option (t : Type0) (x : option t) : result bool =
  let* b = boolTraitOption_get_bool t x in
  if b then boolTrait_ret_true (boolTraitOption t) x else Ok false

(** [traits::test_bool_trait]:
    Source: 'src/traits.rs', lines 35:0-35:50 *)
let test_bool_trait
  (t : Type0) (boolTraitInst : boolTrait_t t) (x : t) : result bool =
  boolTraitInst.get_bool x

(** Trait declaration: [traits::ToU64]
    Source: 'src/traits.rs', lines 39:0-39:15 *)
noeq type toU64_t (self : Type0) = { to_u64 : self -> result u64; }

(** [traits::{(traits::ToU64 for u64)#2}::to_u64]:
    Source: 'src/traits.rs', lines 44:4-44:26 *)
let toU64U64_to_u64 (self : u64) : result u64 =
  Ok self

(** Trait implementation: [traits::{(traits::ToU64 for u64)#2}]
    Source: 'src/traits.rs', lines 43:0-43:18 *)
let toU64U64 : toU64_t u64 = { to_u64 = toU64U64_to_u64; }

(** [traits::{(traits::ToU64 for (A, A))#3}::to_u64]:
    Source: 'src/traits.rs', lines 50:4-50:26 *)
let toU64Pair_to_u64
  (a : Type0) (toU64Inst : toU64_t a) (self : (a & a)) : result u64 =
  let (x, x1) = self in
  let* i = toU64Inst.to_u64 x in
  let* i1 = toU64Inst.to_u64 x1 in
  u64_add i i1

(** Trait implementation: [traits::{(traits::ToU64 for (A, A))#3}]
    Source: 'src/traits.rs', lines 49:0-49:31 *)
let toU64Pair (a : Type0) (toU64Inst : toU64_t a) : toU64_t (a & a) = {
  to_u64 = toU64Pair_to_u64 a toU64Inst;
}

(** [traits::f]:
    Source: 'src/traits.rs', lines 55:0-55:36 *)
let f (t : Type0) (toU64Inst : toU64_t t) (x : (t & t)) : result u64 =
  toU64Pair_to_u64 t toU64Inst x

(** [traits::g]:
    Source: 'src/traits.rs', lines 59:0-61:18 *)
let g
  (t : Type0) (toU64PairInst : toU64_t (t & t)) (x : (t & t)) : result u64 =
  toU64PairInst.to_u64 x

(** [traits::h0]:
    Source: 'src/traits.rs', lines 66:0-66:24 *)
let h0 (x : u64) : result u64 =
  toU64U64_to_u64 x

(** [traits::Wrapper]
    Source: 'src/traits.rs', lines 70:0-70:21 *)
type wrapper_t (t : Type0) = { x : t; }

(** [traits::{(traits::ToU64 for traits::Wrapper<T>)#4}::to_u64]:
    Source: 'src/traits.rs', lines 75:4-75:26 *)
let toU64traitsWrapper_to_u64
  (t : Type0) (toU64Inst : toU64_t t) (self : wrapper_t t) : result u64 =
  toU64Inst.to_u64 self.x

(** Trait implementation: [traits::{(traits::ToU64 for traits::Wrapper<T>)#4}]
    Source: 'src/traits.rs', lines 74:0-74:35 *)
let toU64traitsWrapper (t : Type0) (toU64Inst : toU64_t t) : toU64_t (wrapper_t
  t) = {
  to_u64 = toU64traitsWrapper_to_u64 t toU64Inst;
}

(** [traits::h1]:
    Source: 'src/traits.rs', lines 80:0-80:33 *)
let h1 (x : wrapper_t u64) : result u64 =
  toU64traitsWrapper_to_u64 u64 toU64U64 x

(** [traits::h2]:
    Source: 'src/traits.rs', lines 84:0-84:41 *)
let h2 (t : Type0) (toU64Inst : toU64_t t) (x : wrapper_t t) : result u64 =
  toU64traitsWrapper_to_u64 t toU64Inst x

(** Trait declaration: [traits::ToType]
    Source: 'src/traits.rs', lines 88:0-88:19 *)
noeq type toType_t (self t : Type0) = { to_type : self -> result t; }

(** [traits::{(traits::ToType<bool> for u64)#5}::to_type]:
    Source: 'src/traits.rs', lines 93:4-93:28 *)
let toTypeU64Bool_to_type (self : u64) : result bool =
  Ok (self > 0)

(** Trait implementation: [traits::{(traits::ToType<bool> for u64)#5}]
    Source: 'src/traits.rs', lines 92:0-92:25 *)
let toTypeU64Bool : toType_t u64 bool = { to_type = toTypeU64Bool_to_type; }

(** Trait declaration: [traits::OfType]
    Source: 'src/traits.rs', lines 98:0-98:16 *)
noeq type ofType_t (self : Type0) = {
  of_type : (t : Type0) -> (toTypeInst : toType_t t self) -> t -> result self;
}

(** [traits::h3]:
    Source: 'src/traits.rs', lines 104:0-104:50 *)
let h3
  (t1 t2 : Type0) (ofTypeInst : ofType_t t1) (toTypeInst : toType_t t2 t1)
  (y : t2) :
  result t1
  =
  ofTypeInst.of_type t2 toTypeInst y

(** Trait declaration: [traits::OfTypeBis]
    Source: 'src/traits.rs', lines 109:0-109:36 *)
noeq type ofTypeBis_t (self t : Type0) = {
  toTypeInst : toType_t t self;
  of_type : t -> result self;
}

(** [traits::h4]:
    Source: 'src/traits.rs', lines 118:0-118:57 *)
let h4
  (t1 t2 : Type0) (ofTypeBisInst : ofTypeBis_t t1 t2) (toTypeInst : toType_t t2
  t1) (y : t2) :
  result t1
  =
  ofTypeBisInst.of_type y

(** [traits::TestType]
    Source: 'src/traits.rs', lines 122:0-122:22 *)
type testType_t (t : Type0) = t

(** [traits::{traits::TestType<T>#6}::test::TestType1]
    Source: 'src/traits.rs', lines 127:8-127:24 *)
type testType_test_TestType1_t = u64

(** Trait declaration: [traits::{traits::TestType<T>#6}::test::TestTrait]
    Source: 'src/traits.rs', lines 128:8-128:23 *)
noeq type testType_test_TestTrait_t (self : Type0) = {
  test : self -> result bool;
}

(** [traits::{traits::TestType<T>#6}::test::{(traits::{traits::TestType<T>#6}::test::TestTrait for traits::{traits::TestType<T>#6}::test::TestType1)}::test]:
    Source: 'src/traits.rs', lines 139:12-139:34 *)
let testType_test_TestTraittraitsTestTypetestTestType1_test
  (self : testType_test_TestType1_t) : result bool =
  Ok (self > 1)

(** Trait implementation: [traits::{traits::TestType<T>#6}::test::{(traits::{traits::TestType<T>#6}::test::TestTrait for traits::{traits::TestType<T>#6}::test::TestType1)}]
    Source: 'src/traits.rs', lines 138:8-138:36 *)
let testType_test_TestTraittraitsTestTypetestTestType1 :
  testType_test_TestTrait_t testType_test_TestType1_t = {
  test = testType_test_TestTraittraitsTestTypetestTestType1_test;
}

(** [traits::{traits::TestType<T>#6}::test]:
    Source: 'src/traits.rs', lines 126:4-126:36 *)
let testType_test
  (t : Type0) (toU64Inst : toU64_t t) (self : testType_t t) (x : t) :
  result bool
  =
  let* x1 = toU64Inst.to_u64 x in
  if x1 > 0
  then testType_test_TestTraittraitsTestTypetestTestType1_test 0
  else Ok false

(** [traits::BoolWrapper]
    Source: 'src/traits.rs', lines 150:0-150:22 *)
type boolWrapper_t = bool

(** [traits::{(traits::ToType<T> for traits::BoolWrapper)#7}::to_type]:
    Source: 'src/traits.rs', lines 156:4-156:25 *)
let toTypetraitsBoolWrapperT_to_type
  (t : Type0) (toTypeBoolTInst : toType_t bool t) (self : boolWrapper_t) :
  result t
  =
  toTypeBoolTInst.to_type self

(** Trait implementation: [traits::{(traits::ToType<T> for traits::BoolWrapper)#7}]
    Source: 'src/traits.rs', lines 152:0-152:33 *)
let toTypetraitsBoolWrapperT (t : Type0) (toTypeBoolTInst : toType_t bool t) :
  toType_t boolWrapper_t t = {
  to_type = toTypetraitsBoolWrapperT_to_type t toTypeBoolTInst;
}

(** [traits::WithConstTy::LEN2]
    Source: 'src/traits.rs', lines 164:4-164:21 *)
let with_const_ty_len2_default_body : result usize = Ok 32
let with_const_ty_len2_default : usize =
  eval_global with_const_ty_len2_default_body

(** Trait declaration: [traits::WithConstTy]
    Source: 'src/traits.rs', lines 161:0-161:39 *)
noeq type withConstTy_t (self : Type0) (len : usize) = {
  cLEN1 : usize;
  cLEN2 : usize;
  tV : Type0;
  tW : Type0;
  tW_clause_0 : toU64_t tW;
  f : tW -> array u8 len -> result tW;
}

(** [traits::{(traits::WithConstTy<32: usize> for bool)#8}::LEN1]
    Source: 'src/traits.rs', lines 175:4-175:21 *)
let with_const_ty_bool32_len1_body : result usize = Ok 12
let with_const_ty_bool32_len1 : usize =
  eval_global with_const_ty_bool32_len1_body

(** [traits::{(traits::WithConstTy<32: usize> for bool)#8}::f]:
    Source: 'src/traits.rs', lines 180:4-180:39 *)
let withConstTyBool32_f (i : u64) (a : array u8 32) : result u64 =
  Ok i

(** Trait implementation: [traits::{(traits::WithConstTy<32: usize> for bool)#8}]
    Source: 'src/traits.rs', lines 174:0-174:29 *)
let withConstTyBool32 : withConstTy_t bool 32 = {
  cLEN1 = with_const_ty_bool32_len1;
  cLEN2 = with_const_ty_len2_default;
  tV = u8;
  tW = u64;
  tW_clause_0 = toU64U64;
  f = withConstTyBool32_f;
}

(** [traits::use_with_const_ty1]:
    Source: 'src/traits.rs', lines 183:0-183:75 *)
let use_with_const_ty1
  (h : Type0) (len : usize) (withConstTyInst : withConstTy_t h len) :
  result usize
  =
  Ok withConstTyInst.cLEN1

(** [traits::use_with_const_ty2]:
    Source: 'src/traits.rs', lines 187:0-187:73 *)
let use_with_const_ty2
  (h : Type0) (len : usize) (withConstTyInst : withConstTy_t h len)
  (w : withConstTyInst.tW) :
  result unit
  =
  Ok ()

(** [traits::use_with_const_ty3]:
    Source: 'src/traits.rs', lines 189:0-189:80 *)
let use_with_const_ty3
  (h : Type0) (len : usize) (withConstTyInst : withConstTy_t h len)
  (x : withConstTyInst.tW) :
  result u64
  =
  withConstTyInst.tW_clause_0.to_u64 x

(** [traits::test_where1]:
    Source: 'src/traits.rs', lines 193:0-193:40 *)
let test_where1 (t : Type0) (_x : t) : result unit =
  Ok ()

(** [traits::test_where2]:
    Source: 'src/traits.rs', lines 194:0-194:57 *)
let test_where2
  (t : Type0) (withConstTyT32Inst : withConstTy_t t 32) (_x : u32) :
  result unit
  =
  Ok ()

(** Trait declaration: [traits::ParentTrait0]
    Source: 'src/traits.rs', lines 200:0-200:22 *)
noeq type parentTrait0_t (self : Type0) = {
  tW : Type0;
  get_name : self -> result string;
  get_w : self -> result tW;
}

(** Trait declaration: [traits::ParentTrait1]
    Source: 'src/traits.rs', lines 205:0-205:22 *)
type parentTrait1_t (self : Type0) = unit

(** Trait declaration: [traits::ChildTrait]
    Source: 'src/traits.rs', lines 206:0-206:49 *)
noeq type childTrait_t (self : Type0) = {
  parentTrait0Inst : parentTrait0_t self;
  parentTrait1Inst : parentTrait1_t self;
}

(** [traits::test_child_trait1]:
    Source: 'src/traits.rs', lines 209:0-209:56 *)
let test_child_trait1
  (t : Type0) (childTraitInst : childTrait_t t) (x : t) : result string =
  childTraitInst.parentTrait0Inst.get_name x

(** [traits::test_child_trait2]:
    Source: 'src/traits.rs', lines 213:0-213:54 *)
let test_child_trait2
  (t : Type0) (childTraitInst : childTrait_t t) (x : t) :
  result childTraitInst.parentTrait0Inst.tW
  =
  childTraitInst.parentTrait0Inst.get_w x

(** [traits::order1]:
    Source: 'src/traits.rs', lines 219:0-219:59 *)
let order1
  (t u : Type0) (parentTrait0Inst : parentTrait0_t t) (parentTrait0Inst1 :
  parentTrait0_t u) :
  result unit
  =
  Ok ()

(** Trait declaration: [traits::ChildTrait1]
    Source: 'src/traits.rs', lines 222:0-222:35 *)
noeq type childTrait1_t (self : Type0) = {
  parentTrait1Inst : parentTrait1_t self;
}

(** Trait implementation: [traits::{(traits::ParentTrait1 for usize)#9}]
    Source: 'src/traits.rs', lines 224:0-224:27 *)
let parentTrait1Usize : parentTrait1_t usize = ()

(** Trait implementation: [traits::{(traits::ChildTrait1 for usize)#10}]
    Source: 'src/traits.rs', lines 225:0-225:26 *)
let childTrait1Usize : childTrait1_t usize = {
  parentTrait1Inst = parentTrait1Usize;
}

(** Trait declaration: [traits::Iterator]
    Source: 'src/traits.rs', lines 229:0-229:18 *)
noeq type iterator_t (self : Type0) = { tItem : Type0; }

(** Trait declaration: [traits::IntoIterator]
    Source: 'src/traits.rs', lines 233:0-233:22 *)
noeq type intoIterator_t (self : Type0) = {
  tItem : Type0;
  tIntoIter : Type0;
  tIntoIter_clause_0 : iterator_t tIntoIter;
  into_iter : self -> result tIntoIter;
}

(** Trait declaration: [traits::FromResidual]
    Source: 'src/traits.rs', lines 250:0-250:21 *)
type fromResidual_t (self t : Type0) = unit

(** Trait declaration: [traits::Try]
    Source: 'src/traits.rs', lines 246:0-246:48 *)
noeq type try_t (self : Type0) = {
  tResidual : Type0;
  fromResidualSelftraitsTryResidualInst : fromResidual_t self tResidual;
}

(** Trait declaration: [traits::WithTarget]
    Source: 'src/traits.rs', lines 252:0-252:20 *)
noeq type withTarget_t (self : Type0) = { tTarget : Type0; }

(** Trait declaration: [traits::ParentTrait2]
    Source: 'src/traits.rs', lines 256:0-256:22 *)
noeq type parentTrait2_t (self : Type0) = {
  tU : Type0;
  tU_clause_0 : withTarget_t tU;
}

(** Trait declaration: [traits::ChildTrait2]
    Source: 'src/traits.rs', lines 260:0-260:35 *)
noeq type childTrait2_t (self : Type0) = {
  parentTrait2Inst : parentTrait2_t self;
  convert : parentTrait2Inst.tU -> result parentTrait2Inst.tU_clause_0.tTarget;
}

(** Trait implementation: [traits::{(traits::WithTarget for u32)#11}]
    Source: 'src/traits.rs', lines 264:0-264:23 *)
let withTargetU32 : withTarget_t u32 = { tTarget = u32; }

(** Trait implementation: [traits::{(traits::ParentTrait2 for u32)#12}]
    Source: 'src/traits.rs', lines 268:0-268:25 *)
let parentTrait2U32 : parentTrait2_t u32 = {
  tU = u32;
  tU_clause_0 = withTargetU32;
}

(** [traits::{(traits::ChildTrait2 for u32)#13}::convert]:
    Source: 'src/traits.rs', lines 273:4-273:29 *)
let childTrait2U32_convert (x : u32) : result u32 =
  Ok x

(** Trait implementation: [traits::{(traits::ChildTrait2 for u32)#13}]
    Source: 'src/traits.rs', lines 272:0-272:24 *)
let childTrait2U32 : childTrait2_t u32 = {
  parentTrait2Inst = parentTrait2U32;
  convert = childTrait2U32_convert;
}

(** Trait declaration: [traits::CFnOnce]
    Source: 'src/traits.rs', lines 286:0-286:23 *)
noeq type cFnOnce_t (self args : Type0) = {
  tOutput : Type0;
  call_once : self -> args -> result tOutput;
}

(** Trait declaration: [traits::CFnMut]
    Source: 'src/traits.rs', lines 292:0-292:37 *)
noeq type cFnMut_t (self args : Type0) = {
  cFnOnceInst : cFnOnce_t self args;
  call_mut : self -> args -> result (cFnOnceInst.tOutput & self);
}

(** Trait declaration: [traits::CFn]
    Source: 'src/traits.rs', lines 296:0-296:33 *)
noeq type cFn_t (self args : Type0) = {
  cFnMutInst : cFnMut_t self args;
  call : self -> args -> result cFnMutInst.cFnOnceInst.tOutput;
}

(** Trait declaration: [traits::GetTrait]
    Source: 'src/traits.rs', lines 300:0-300:18 *)
noeq type getTrait_t (self : Type0) = { tW : Type0; get_w : self -> result tW;
}

(** [traits::test_get_trait]:
    Source: 'src/traits.rs', lines 305:0-305:49 *)
let test_get_trait
  (t : Type0) (getTraitInst : getTrait_t t) (x : t) : result getTraitInst.tW =
  getTraitInst.get_w x

