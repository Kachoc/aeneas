-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [traits]
import Base
open Primitives
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

namespace traits

/- Trait declaration: [traits::BoolTrait]
   Source: 'tests/src/traits.rs', lines 2:0-10:1 -/
structure BoolTrait (Self : Type) where
  get_bool : Self → Result Bool

/- [traits::{traits::BoolTrait for bool}::get_bool]:
   Source: 'tests/src/traits.rs', lines 13:4-15:5 -/
def BoolTraitBool.get_bool (self : Bool) : Result Bool :=
  Result.ok self

/- Trait implementation: [traits::{traits::BoolTrait for bool}]
   Source: 'tests/src/traits.rs', lines 12:0-16:1 -/
@[reducible]
def BoolTraitBool : BoolTrait Bool := {
  get_bool := BoolTraitBool.get_bool
}

/- [traits::BoolTrait::ret_true]:
   Source: 'tests/src/traits.rs', lines 7:4-9:5 -/
def BoolTrait.ret_true
  {Self : Type} (self_clause : BoolTrait Self) (self : Self) : Result Bool :=
  Result.ok true

/- [traits::test_bool_trait_bool]:
   Source: 'tests/src/traits.rs', lines 18:0-20:1 -/
def test_bool_trait_bool (x : Bool) : Result Bool :=
  do
  let b ← BoolTraitBool.get_bool x
  if b
  then BoolTrait.ret_true BoolTraitBool x
  else Result.ok false

/- [traits::{traits::BoolTrait for core::option::Option<T>}#1::get_bool]:
   Source: 'tests/src/traits.rs', lines 24:4-29:5 -/
def BoolTraitOption.get_bool (T : Type) (self : Option T) : Result Bool :=
  match self with
  | none => Result.ok false
  | some _ => Result.ok true

/- Trait implementation: [traits::{traits::BoolTrait for core::option::Option<T>}#1]
   Source: 'tests/src/traits.rs', lines 23:0-30:1 -/
@[reducible]
def BoolTraitOption (T : Type) : BoolTrait (Option T) := {
  get_bool := BoolTraitOption.get_bool T
}

/- [traits::test_bool_trait_option]:
   Source: 'tests/src/traits.rs', lines 32:0-34:1 -/
def test_bool_trait_option (T : Type) (x : Option T) : Result Bool :=
  do
  let b ← BoolTraitOption.get_bool T x
  if b
  then BoolTrait.ret_true (BoolTraitOption T) x
  else Result.ok false

/- [traits::test_bool_trait]:
   Source: 'tests/src/traits.rs', lines 36:0-38:1 -/
def test_bool_trait
  (T : Type) (BoolTraitInst : BoolTrait T) (x : T) : Result Bool :=
  BoolTraitInst.get_bool x

/- Trait declaration: [traits::ToU64]
   Source: 'tests/src/traits.rs', lines 40:0-42:1 -/
structure ToU64 (Self : Type) where
  to_u64 : Self → Result U64

/- [traits::{traits::ToU64 for u64}#2::to_u64]:
   Source: 'tests/src/traits.rs', lines 45:4-47:5 -/
def ToU64U64.to_u64 (self : U64) : Result U64 :=
  Result.ok self

/- Trait implementation: [traits::{traits::ToU64 for u64}#2]
   Source: 'tests/src/traits.rs', lines 44:0-48:1 -/
@[reducible]
def ToU64U64 : ToU64 U64 := {
  to_u64 := ToU64U64.to_u64
}

/- [traits::{traits::ToU64 for (A, A)}#3::to_u64]:
   Source: 'tests/src/traits.rs', lines 51:4-53:5 -/
def ToU64Pair.to_u64
  (A : Type) (ToU64Inst : ToU64 A) (self : (A × A)) : Result U64 :=
  do
  let (t, t1) := self
  let i ← ToU64Inst.to_u64 t
  let i1 ← ToU64Inst.to_u64 t1
  i + i1

/- Trait implementation: [traits::{traits::ToU64 for (A, A)}#3]
   Source: 'tests/src/traits.rs', lines 50:0-54:1 -/
@[reducible]
def ToU64Pair (A : Type) (ToU64Inst : ToU64 A) : ToU64 (A × A) := {
  to_u64 := ToU64Pair.to_u64 A ToU64Inst
}

/- [traits::f]:
   Source: 'tests/src/traits.rs', lines 56:0-58:1 -/
def f (T : Type) (ToU64Inst : ToU64 T) (x : (T × T)) : Result U64 :=
  ToU64Pair.to_u64 T ToU64Inst x

/- [traits::g]:
   Source: 'tests/src/traits.rs', lines 60:0-65:1 -/
def g
  (T : Type) (ToU64PairInst : ToU64 (T × T)) (x : (T × T)) : Result U64 :=
  ToU64PairInst.to_u64 x

/- [traits::h0]:
   Source: 'tests/src/traits.rs', lines 67:0-69:1 -/
def h0 (x : U64) : Result U64 :=
  ToU64U64.to_u64 x

/- [traits::Wrapper]
   Source: 'tests/src/traits.rs', lines 71:0-73:1 -/
structure Wrapper (T : Type) where
  x : T

/- [traits::{traits::ToU64 for traits::Wrapper<T>}#4::to_u64]:
   Source: 'tests/src/traits.rs', lines 76:4-78:5 -/
def ToU64traitsWrapper.to_u64
  (T : Type) (ToU64Inst : ToU64 T) (self : Wrapper T) : Result U64 :=
  ToU64Inst.to_u64 self.x

/- Trait implementation: [traits::{traits::ToU64 for traits::Wrapper<T>}#4]
   Source: 'tests/src/traits.rs', lines 75:0-79:1 -/
@[reducible]
def ToU64traitsWrapper (T : Type) (ToU64Inst : ToU64 T) : ToU64 (Wrapper T)
  := {
  to_u64 := ToU64traitsWrapper.to_u64 T ToU64Inst
}

/- [traits::h1]:
   Source: 'tests/src/traits.rs', lines 81:0-83:1 -/
def h1 (x : Wrapper U64) : Result U64 :=
  ToU64traitsWrapper.to_u64 U64 ToU64U64 x

/- [traits::h2]:
   Source: 'tests/src/traits.rs', lines 85:0-87:1 -/
def h2 (T : Type) (ToU64Inst : ToU64 T) (x : Wrapper T) : Result U64 :=
  ToU64traitsWrapper.to_u64 T ToU64Inst x

/- Trait declaration: [traits::ToType]
   Source: 'tests/src/traits.rs', lines 89:0-91:1 -/
structure ToType (Self T : Type) where
  to_type : Self → Result T

/- [traits::{traits::ToType<bool> for u64}#5::to_type]:
   Source: 'tests/src/traits.rs', lines 94:4-96:5 -/
def ToTypeU64Bool.to_type (self : U64) : Result Bool :=
  Result.ok (self > 0#u64)

/- Trait implementation: [traits::{traits::ToType<bool> for u64}#5]
   Source: 'tests/src/traits.rs', lines 93:0-97:1 -/
@[reducible]
def ToTypeU64Bool : ToType U64 Bool := {
  to_type := ToTypeU64Bool.to_type
}

/- Trait declaration: [traits::OfType]
   Source: 'tests/src/traits.rs', lines 99:0-103:1 -/
structure OfType (Self : Type) where
  of_type : forall (T : Type) (ToTypeInst : ToType T Self), T → Result Self

/- [traits::h3]:
   Source: 'tests/src/traits.rs', lines 105:0-107:1 -/
def h3
  (T1 T2 : Type) (OfTypeInst : OfType T1) (ToTypeInst : ToType T2 T1) 
  (y : T2) :
  Result T1
  :=
  OfTypeInst.of_type T2 ToTypeInst y

/- Trait declaration: [traits::OfTypeBis]
   Source: 'tests/src/traits.rs', lines 110:0-117:1 -/
structure OfTypeBis (Self T : Type) where
  ToTypeInst : ToType T Self
  of_type : T → Result Self

/- [traits::h4]:
   Source: 'tests/src/traits.rs', lines 119:0-121:1 -/
def h4
  (T1 T2 : Type) (OfTypeBisInst : OfTypeBis T1 T2) (ToTypeInst : ToType T2 T1)
  (y : T2) :
  Result T1
  :=
  OfTypeBisInst.of_type y

/- [traits::TestType]
   Source: 'tests/src/traits.rs', lines 123:0-123:26 -/
@[reducible] def TestType (T : Type) := T

/- [traits::{traits::TestType<T>}#6::test::TestType1]
   Source: 'tests/src/traits.rs', lines 128:8-128:30 -/
@[reducible] def TestType.test.TestType1 := U64

/- Trait declaration: [traits::{traits::TestType<T>}#6::test::TestTrait]
   Source: 'tests/src/traits.rs', lines 129:8-131:9 -/
structure TestType.test.TestTrait (Self : Type) where
  test : Self → Result Bool

/- [traits::{traits::TestType<T>}#6::test::{traits::{traits::TestType<T>}#6::test::TestTrait for traits::{traits::TestType<T>}#6::test::TestType1}::test]:
   Source: 'tests/src/traits.rs', lines 140:12-142:13 -/
def TestType.test.TestTraittraitsTestTypetestTestType1.test
  (self : TestType.test.TestType1) : Result Bool :=
  Result.ok (self > 1#u64)

/- Trait implementation: [traits::{traits::TestType<T>}#6::test::{traits::{traits::TestType<T>}#6::test::TestTrait for traits::{traits::TestType<T>}#6::test::TestType1}]
   Source: 'tests/src/traits.rs', lines 139:8-143:9 -/
@[reducible]
def TestType.test.TestTraittraitsTestTypetestTestType1 :
  TestType.test.TestTrait TestType.test.TestType1 := {
  test := TestType.test.TestTraittraitsTestTypetestTestType1.test
}

/- [traits::{traits::TestType<T>}#6::test]:
   Source: 'tests/src/traits.rs', lines 127:4-148:5 -/
def TestType.test
  (T : Type) (ToU64Inst : ToU64 T) (self : TestType T) (x : T) : Result Bool :=
  do
  let x1 ← ToU64Inst.to_u64 x
  if x1 > 0#u64
  then TestType.test.TestTraittraitsTestTypetestTestType1.test 0#u64
  else Result.ok false

/- [traits::BoolWrapper]
   Source: 'tests/src/traits.rs', lines 151:0-151:33 -/
@[reducible] def BoolWrapper := Bool

/- [traits::{traits::ToType<T> for traits::BoolWrapper}#7::to_type]:
   Source: 'tests/src/traits.rs', lines 157:4-159:5 -/
def ToTypetraitsBoolWrapperT.to_type
  (T : Type) (ToTypeBoolTInst : ToType Bool T) (self : BoolWrapper) :
  Result T
  :=
  ToTypeBoolTInst.to_type self

/- Trait implementation: [traits::{traits::ToType<T> for traits::BoolWrapper}#7]
   Source: 'tests/src/traits.rs', lines 153:0-160:1 -/
@[reducible]
def ToTypetraitsBoolWrapperT (T : Type) (ToTypeBoolTInst : ToType Bool T) :
  ToType BoolWrapper T := {
  to_type := ToTypetraitsBoolWrapperT.to_type T ToTypeBoolTInst
}

/- [traits::WithConstTy::LEN2]
   Source: 'tests/src/traits.rs', lines 165:4-165:27 -/
def WithConstTy.LEN2_default_body (Self : Type) (LEN : Usize) : Result Usize :=
  Result.ok 32#usize
def WithConstTy.LEN2_default (Self : Type) (LEN : Usize) : Usize :=
  eval_global (WithConstTy.LEN2_default_body Self LEN)

/- Trait declaration: [traits::WithConstTy]
   Source: 'tests/src/traits.rs', lines 162:0-173:1 -/
structure WithConstTy (Self : Type) (LEN : Usize) where
  LEN1 : Usize
  LEN2 : Usize
  V : Type
  W : Type
  ToU64traitsWithConstTyWInst : ToU64 W
  f : W → Array U8 LEN → Result W

/- [traits::{traits::WithConstTy<32: usize> for bool}#8::LEN1]
   Source: 'tests/src/traits.rs', lines 176:4-176:27 -/
def WithConstTyBool32.LEN1_body : Result Usize := Result.ok 12#usize
def WithConstTyBool32.LEN1 : Usize := eval_global WithConstTyBool32.LEN1_body

/- [traits::{traits::WithConstTy<32: usize> for bool}#8::f]:
   Source: 'tests/src/traits.rs', lines 181:4-181:42 -/
def WithConstTyBool32.f (i : U64) (a : Array U8 32#usize) : Result U64 :=
  Result.ok i

/- Trait implementation: [traits::{traits::WithConstTy<32: usize> for bool}#8]
   Source: 'tests/src/traits.rs', lines 175:0-182:1 -/
@[reducible]
def WithConstTyBool32 : WithConstTy Bool 32#usize := {
  LEN1 := WithConstTyBool32.LEN1
  LEN2 := WithConstTy.LEN2_default Bool 32#usize
  V := U8
  W := U64
  ToU64traitsWithConstTyWInst := ToU64U64
  f := WithConstTyBool32.f
}

/- [traits::use_with_const_ty1]:
   Source: 'tests/src/traits.rs', lines 184:0-186:1 -/
def use_with_const_ty1
  (H : Type) (LEN : Usize) (WithConstTyInst : WithConstTy H LEN) :
  Result Usize
  :=
  Result.ok WithConstTyInst.LEN1

/- [traits::use_with_const_ty2]:
   Source: 'tests/src/traits.rs', lines 188:0-188:76 -/
def use_with_const_ty2
  (H : Type) (LEN : Usize) (WithConstTyInst : WithConstTy H LEN)
  (w : WithConstTyInst.W) :
  Result Unit
  :=
  Result.ok ()

/- [traits::use_with_const_ty3]:
   Source: 'tests/src/traits.rs', lines 190:0-192:1 -/
def use_with_const_ty3
  (H : Type) (LEN : Usize) (WithConstTyInst : WithConstTy H LEN)
  (x : WithConstTyInst.W) :
  Result U64
  :=
  WithConstTyInst.ToU64traitsWithConstTyWInst.to_u64 x

/- [traits::test_where1]:
   Source: 'tests/src/traits.rs', lines 194:0-194:43 -/
def test_where1 (T : Type) (_x : T) : Result Unit :=
  Result.ok ()

/- [traits::test_where2]:
   Source: 'tests/src/traits.rs', lines 195:0-195:60 -/
def test_where2
  (T : Type) (WithConstTyT32Inst : WithConstTy T 32#usize) (_x : U32) :
  Result Unit
  :=
  Result.ok ()

/- Trait declaration: [traits::ParentTrait0]
   Source: 'tests/src/traits.rs', lines 201:0-205:1 -/
structure ParentTrait0 (Self : Type) where
  W : Type
  get_name : Self → Result String
  get_w : Self → Result W

/- Trait declaration: [traits::ParentTrait1]
   Source: 'tests/src/traits.rs', lines 206:0-206:25 -/
structure ParentTrait1 (Self : Type) where

/- Trait declaration: [traits::ChildTrait]
   Source: 'tests/src/traits.rs', lines 207:0-207:52 -/
structure ChildTrait (Self : Type) where
  ParentTrait0Inst : ParentTrait0 Self
  ParentTrait1Inst : ParentTrait1 Self

/- [traits::test_child_trait1]:
   Source: 'tests/src/traits.rs', lines 210:0-212:1 -/
def test_child_trait1
  (T : Type) (ChildTraitInst : ChildTrait T) (x : T) : Result String :=
  ChildTraitInst.ParentTrait0Inst.get_name x

/- [traits::test_child_trait2]:
   Source: 'tests/src/traits.rs', lines 214:0-216:1 -/
def test_child_trait2
  (T : Type) (ChildTraitInst : ChildTrait T) (x : T) :
  Result ChildTraitInst.ParentTrait0Inst.W
  :=
  ChildTraitInst.ParentTrait0Inst.get_w x

/- [traits::order1]:
   Source: 'tests/src/traits.rs', lines 220:0-220:62 -/
def order1
  (T U : Type) (ParentTrait0Inst : ParentTrait0 T) (ParentTrait0Inst1 :
  ParentTrait0 U) :
  Result Unit
  :=
  Result.ok ()

/- Trait declaration: [traits::ChildTrait1]
   Source: 'tests/src/traits.rs', lines 223:0-223:38 -/
structure ChildTrait1 (Self : Type) where
  ParentTrait1Inst : ParentTrait1 Self

/- Trait implementation: [traits::{traits::ParentTrait1 for usize}#9]
   Source: 'tests/src/traits.rs', lines 225:0-225:30 -/
@[reducible]
def ParentTrait1Usize : ParentTrait1 Usize := {
}

/- Trait implementation: [traits::{traits::ChildTrait1 for usize}#10]
   Source: 'tests/src/traits.rs', lines 226:0-226:29 -/
@[reducible]
def ChildTrait1Usize : ChildTrait1 Usize := {
  ParentTrait1Inst := ParentTrait1Usize
}

/- Trait declaration: [traits::Iterator]
   Source: 'tests/src/traits.rs', lines 230:0-232:1 -/
structure Iterator (Self : Type) where
  Item : Type

/- Trait declaration: [traits::IntoIterator]
   Source: 'tests/src/traits.rs', lines 234:0-240:1 -/
structure IntoIterator (Self : Type) where
  Item : Type
  IntoIter : Type
  IteratortraitsIntoIteratorIntoIterInst : Iterator IntoIter
  into_iter : Self → Result IntoIter

/- Trait declaration: [traits::FromResidual]
   Source: 'tests/src/traits.rs', lines 251:0-251:24 -/
structure FromResidual (Self T : Type) where

/- Trait declaration: [traits::Try]
   Source: 'tests/src/traits.rs', lines 247:0-249:1 -/
structure Try (Self : Type) where
  Residual : Type
  FromResidualSelftraitsTryResidualInst : FromResidual Self Residual

/- Trait declaration: [traits::WithTarget]
   Source: 'tests/src/traits.rs', lines 253:0-255:1 -/
structure WithTarget (Self : Type) where
  Target : Type

/- Trait declaration: [traits::ParentTrait2]
   Source: 'tests/src/traits.rs', lines 257:0-259:1 -/
structure ParentTrait2 (Self : Type) where
  U : Type
  WithTargettraitsParentTrait2UInst : WithTarget U

/- Trait declaration: [traits::ChildTrait2]
   Source: 'tests/src/traits.rs', lines 261:0-263:1 -/
structure ChildTrait2 (Self : Type) where
  ParentTrait2Inst : ParentTrait2 Self
  convert : ParentTrait2Inst.U → Result
    ParentTrait2Inst.WithTargettraitsParentTrait2UInst.Target

/- Trait implementation: [traits::{traits::WithTarget for u32}#11]
   Source: 'tests/src/traits.rs', lines 265:0-267:1 -/
@[reducible]
def WithTargetU32 : WithTarget U32 := {
  Target := U32
}

/- Trait implementation: [traits::{traits::ParentTrait2 for u32}#12]
   Source: 'tests/src/traits.rs', lines 269:0-271:1 -/
@[reducible]
def ParentTrait2U32 : ParentTrait2 U32 := {
  U := U32
  WithTargettraitsParentTrait2UInst := WithTargetU32
}

/- [traits::{traits::ChildTrait2 for u32}#13::convert]:
   Source: 'tests/src/traits.rs', lines 274:4-276:5 -/
def ChildTrait2U32.convert (x : U32) : Result U32 :=
  Result.ok x

/- Trait implementation: [traits::{traits::ChildTrait2 for u32}#13]
   Source: 'tests/src/traits.rs', lines 273:0-277:1 -/
@[reducible]
def ChildTrait2U32 : ChildTrait2 U32 := {
  ParentTrait2Inst := ParentTrait2U32
  convert := ChildTrait2U32.convert
}

/- Trait declaration: [traits::CFnOnce]
   Source: 'tests/src/traits.rs', lines 287:0-291:1 -/
structure CFnOnce (Self Args : Type) where
  Output : Type
  call_once : Self → Args → Result Output

/- Trait declaration: [traits::CFnMut]
   Source: 'tests/src/traits.rs', lines 293:0-295:1 -/
structure CFnMut (Self Args : Type) where
  CFnOnceInst : CFnOnce Self Args
  call_mut : Self → Args → Result (CFnOnceInst.Output × Self)

/- Trait declaration: [traits::CFn]
   Source: 'tests/src/traits.rs', lines 297:0-299:1 -/
structure CFn (Self Args : Type) where
  CFnMutInst : CFnMut Self Args
  call : Self → Args → Result CFnMutInst.CFnOnceInst.Output

/- Trait declaration: [traits::GetTrait]
   Source: 'tests/src/traits.rs', lines 301:0-304:1 -/
structure GetTrait (Self : Type) where
  W : Type
  get_w : Self → Result W

/- [traits::test_get_trait]:
   Source: 'tests/src/traits.rs', lines 306:0-308:1 -/
def test_get_trait
  (T : Type) (GetTraitInst : GetTrait T) (x : T) : Result GetTraitInst.W :=
  GetTraitInst.get_w x

/- Trait declaration: [traits::Trait]
   Source: 'tests/src/traits.rs', lines 311:0-313:1 -/
structure Trait (Self : Type) where
  LEN : Usize

/- [traits::{traits::Trait for @Array<T, N>}#14::LEN]
   Source: 'tests/src/traits.rs', lines 316:4-316:25 -/
def TraitArray.LEN_body (T : Type) (N : Usize) : Result Usize := Result.ok N
def TraitArray.LEN (T : Type) (N : Usize) : Usize :=
  eval_global (TraitArray.LEN_body T N)

/- Trait implementation: [traits::{traits::Trait for @Array<T, N>}#14]
   Source: 'tests/src/traits.rs', lines 315:0-317:1 -/
@[reducible]
def TraitArray (T : Type) (N : Usize) : Trait (Array T N) := {
  LEN := TraitArray.LEN T N
}

/- [traits::{traits::Trait for traits::Wrapper<T>}#15::LEN]
   Source: 'tests/src/traits.rs', lines 320:4-320:25 -/
def TraittraitsWrapper.LEN_body (T : Type) (TraitInst : Trait T)
  : Result Usize :=
  Result.ok 0#usize
def TraittraitsWrapper.LEN (T : Type) (TraitInst : Trait T) : Usize :=
  eval_global (TraittraitsWrapper.LEN_body T TraitInst)

/- Trait implementation: [traits::{traits::Trait for traits::Wrapper<T>}#15]
   Source: 'tests/src/traits.rs', lines 319:0-321:1 -/
@[reducible]
def TraittraitsWrapper (T : Type) (TraitInst : Trait T) : Trait (Wrapper T)
  := {
  LEN := TraittraitsWrapper.LEN T TraitInst
}

/- [traits::use_wrapper_len]:
   Source: 'tests/src/traits.rs', lines 323:0-325:1 -/
def use_wrapper_len (T : Type) (TraitInst : Trait T) : Result Usize :=
  Result.ok (TraittraitsWrapper T TraitInst).LEN

/- [traits::Foo]
   Source: 'tests/src/traits.rs', lines 327:0-330:1 -/
structure Foo (T U : Type) where
  x : T
  y : U

/- [core::result::Result]
   Source: '/rustc/library/core/src/result.rs', lines 527:0-527:21
   Name pattern: core::result::Result -/
inductive core.result.Result (T E : Type) :=
| Ok : T → core.result.Result T E
| Err : E → core.result.Result T E

/- [traits::{traits::Foo<T, U>}#16::FOO]
   Source: 'tests/src/traits.rs', lines 333:4-333:43 -/
def Foo.FOO_body (T U : Type) (TraitInst : Trait T)
  : Result (core.result.Result T I32) :=
  Result.ok (core.result.Result.Err 0#i32)
def Foo.FOO (T U : Type) (TraitInst : Trait T) : core.result.Result T I32 :=
  eval_global (Foo.FOO_body T U TraitInst)

/- [traits::use_foo1]:
   Source: 'tests/src/traits.rs', lines 336:0-338:1 -/
def use_foo1
  (T U : Type) (TraitInst : Trait T) : Result (core.result.Result T I32) :=
  Result.ok (Foo.FOO T U TraitInst)

/- [traits::use_foo2]:
   Source: 'tests/src/traits.rs', lines 340:0-342:1 -/
def use_foo2
  (T U : Type) (TraitInst : Trait U) : Result (core.result.Result U I32) :=
  Result.ok (Foo.FOO U T TraitInst)

end traits
