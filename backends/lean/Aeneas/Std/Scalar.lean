import Aeneas.Std.ScalarCore
import Aeneas.ScalarTac
import Aeneas.Arith.Lemmas
import MathLib.Data.BitVec

namespace Aeneas

namespace Std

open Result Error
open Arith

/-!
# Misc Theorems
-/

@[simp] theorem UScalar.exists_eq_left {p : UScalar ty → Prop} {a' : UScalar ty} :
  (∃ (a : UScalar ty), a.val = a'.val ∧ p a) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, h, hp ⟩ := h
    cases a'
    simp_all only [val]
    have := @BitVec.toNat_injective ty.bitWidth
    have := this h
    simp [← this]
    apply hp
  . exists a'

@[simp] theorem IScalar.exists_eq_left {p : IScalar ty → Prop} {a' : IScalar ty} :
  (∃ (a : IScalar ty), a.val = a'.val ∧ p a) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, h, hp ⟩ := h
    cases a'
    simp_all only [val, eq_comm]
    rw [BitVec.toInt_inj] at h
    simp [h]
    apply hp
  . exists a'

@[simp] theorem UScalar.exists_eq_left' {p : UScalar ty → Prop} {a' : UScalar ty} :
  (∃ (a : UScalar ty), a'.val = a.val ∧ p a) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, h, hp ⟩ := h
    cases a'
    simp_all only [val]
    have := @BitVec.toNat_injective ty.bitWidth
    have := this h
    simp [this]
    apply hp
  . exists a'

@[simp] theorem IScalar.exists_eq_left' {p : IScalar ty → Prop} {a' : IScalar ty} :
  (∃ (a : IScalar ty), a'.val = a.val ∧ p a) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, h, hp ⟩ := h
    cases a'
    simp_all only [val]
    rw [BitVec.toInt_inj] at h
    simp [h]
    apply hp
  . exists a'

@[simp] theorem UScalar.exists_eq_right {p : UScalar ty → Prop} {a' : UScalar ty} :
  (∃ (a : UScalar ty), p a ∧ a.val = a'.val) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, hp, h ⟩ := h
    cases a'
    simp_all only [val]
    have := @BitVec.toNat_injective ty.bitWidth
    have := this h
    simp [← this]
    apply hp
  . exists a'

@[simp] theorem IScalar.exists_eq_right {p : IScalar ty → Prop} {a' : IScalar ty} :
  (∃ (a : IScalar ty), p a ∧ a.val = a'.val) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, hp, h ⟩ := h
    cases a'
    simp_all only [val, eq_comm]
    rw [BitVec.toInt_inj] at h
    simp [h]
    apply hp
  . exists a'

@[simp] theorem UScalar.exists_eq_right' {p : UScalar ty → Prop} {a' : UScalar ty} :
  (∃ (a : UScalar ty), p a ∧ a'.val = a.val) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, hp, h ⟩ := h
    cases a'
    simp_all only [val]
    have := @BitVec.toNat_injective ty.bitWidth
    have := this h
    simp [this]
    apply hp
  . exists a'

@[simp] theorem IScalar.exists_eq_right' {p : IScalar ty → Prop} {a' : IScalar ty} :
  (∃ (a : IScalar ty), p a ∧ a'.val = a.val) ↔ p a' := by
  constructor <;> intro h
  . replace ⟨ a, hp, h ⟩ := h
    cases a'
    simp_all only [val, eq_comm]
    rw [BitVec.toInt_inj] at h
    simp [h]
    apply hp
  . exists a'

@[simp] theorem UScalar.exists_eq {a' : UScalar ty} : ∃ (a : UScalar ty), a.val = a'.val := by exists a'
@[simp] theorem UScalar.exists_eq' {a' : UScalar ty} : ∃ (a : UScalar ty), a'.val = a.val := by exists a'
@[simp] theorem IScalar.exists_eq {a' : IScalar ty} : ∃ (a : IScalar ty), a.val = a'.val := by exists a'
@[simp] theorem IScalar.exists_eq' {a' : IScalar ty} : ∃ (a : IScalar ty), a'.val = a.val := by exists a'

/-!

# Primitive Operations
## Primitive Operations: Definitions

-/

/-!
The scalar division/modulo on signed machine integers 't'runcates towards 0, meaning it is
implemented by the `Int.tdiv`, `Int.tmod`, etc. definitions.
-/

namespace Tests
  -- Checking that the division over signed integers agrees with Rust
  #assert Int.tdiv 3 2 = 1
  #assert Int.tdiv (-3) 2 = -1
  #assert Int.tdiv 3 (-2) = -1
  #assert Int.tdiv (-3) (-2) = 1
  #assert Int.tdiv 7 3 = 2
  #assert Int.tdiv (-7) 3 = -2
  #assert Int.tdiv 7 (-3) = -2
  #assert Int.tdiv (-7) (-3) = 2

  -- Checking that the signed division over bit-vectors agrees with Rust
  private def bv_sdiv (x y : Int) : Int :=
    (BitVec.sdiv (BitVec.ofInt 32 x) (BitVec.ofInt 32 y)).toInt

  #assert bv_sdiv 3 2 = 1
  #assert bv_sdiv (-3) 2 = -1
  #assert bv_sdiv 3 (-2) = -1
  #assert bv_sdiv (-3) (-2) = 1
  #assert bv_sdiv 7 3 = 2
  #assert bv_sdiv (-7) 3 = -2
  #assert bv_sdiv 7 (-3) = -2
  #assert bv_sdiv (-7) (-3) = 2

  -- Checking that the remainder over signed integers agrees with Rust
  #assert Int.tmod 1 2 = 1
  #assert Int.tmod (-1) 2 = -1
  #assert Int.tmod 1 (-2) = 1
  #assert Int.tmod (-1) (-2) = -1
  #assert Int.tmod 7 3 = (1:Int)
  #assert Int.tmod (-7) 3 = -1
  #assert Int.tmod 7 (-3) = 1
  #assert Int.tmod (-7) (-3) = -1

  -- Checking that the signed operation over bit-vectors agrees with Rust
  private def bv_srem (x y : Int) : Int :=
    (BitVec.srem (BitVec.ofInt 32 x) (BitVec.ofInt 32 y)).toInt

  #assert bv_srem 1 2 = 1
  #assert bv_srem (-1) 2 = -1
  #assert bv_srem 1 (-2) = 1
  #assert bv_srem (-1) (-2) = -1
  #assert bv_srem 7 3 = (1:Int)
  #assert bv_srem (-7) 3 = -1
  #assert bv_srem 7 (-3) = 1
  #assert bv_srem (-7) (-3) = -1
end Tests

/-!
Addition
-/
def UScalar.add {ty : UScalarTy} (x y : UScalar ty) : Result (UScalar ty) :=
  UScalar.tryMk ty (x.val + y.val)

def IScalar.add {ty : IScalarTy} (x y : IScalar ty) : Result (IScalar ty) :=
  IScalar.tryMk ty (x.val + y.val)

def UScalar.try_add {ty : UScalarTy} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (add x y)

def IScalar.try_add {ty : IScalarTy} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (add x y)

instance {ty} : HAdd (UScalar ty) (UScalar ty) (Result (UScalar ty)) where
  hAdd x y := UScalar.add x y

instance {ty} : HAdd (IScalar ty) (IScalar ty) (Result (IScalar ty)) where
  hAdd x y := IScalar.add x y

/-!
Subtraction
-/
def UScalar.sub {ty : UScalarTy} (x y : UScalar ty) : Result (UScalar ty) :=
  if x.val < y.val then fail .integerOverflow
  else ok ⟨ BitVec.ofNat _ (x.val - y.val) ⟩

def IScalar.sub {ty : IScalarTy} (x y : IScalar ty) : Result (IScalar ty) :=
  IScalar.tryMk ty (x.val - y.val)

def UScalar.try_sub {ty : UScalarTy} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (sub x y)

def IScalar.try_sub {ty : IScalarTy} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (sub x y)

instance {ty} : HSub (UScalar ty) (UScalar ty) (Result (UScalar ty)) where
  hSub x y := UScalar.sub x y

instance {ty} : HSub (IScalar ty) (IScalar ty) (Result (IScalar ty)) where
  hSub x y := IScalar.sub x y

/-!
Multiplication
-/
def UScalar.mul {ty : UScalarTy} (x y : UScalar ty) : Result (UScalar ty) :=
  UScalar.tryMk ty (x.val * y.val)

def IScalar.mul {ty : IScalarTy} (x y : IScalar ty) : Result (IScalar ty) :=
  IScalar.tryMk ty (x.val * y.val)

def UScalar.try_mul {ty : UScalarTy} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (mul x y)

def IScalar.try_mul {ty : IScalarTy} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (mul x y)

instance {ty} : HMul (UScalar ty) (UScalar ty) (Result (UScalar ty)) where
  hMul x y := UScalar.mul x y

instance {ty} : HMul (IScalar ty) (IScalar ty) (Result (IScalar ty)) where
  hMul x y := IScalar.mul x y

/-!
Division
-/

def UScalar.div {ty : UScalarTy} (x y : UScalar ty) : Result (UScalar ty) :=
  if y.bv != 0 then ok ⟨ BitVec.udiv x.bv y.bv ⟩ else fail divisionByZero

def IScalar.div {ty : IScalarTy} (x y : IScalar ty): Result (IScalar ty) :=
  if y.val != 0 then
    -- There can be an overflow if `x` is equal to the lower bound and `y` to `-1`
    if ¬ (x.val = IScalar.min ty && y.val = -1) then ok ⟨ BitVec.sdiv x.bv y.bv ⟩
    else fail integerOverflow
  else fail divisionByZero

def UScalar.try_div {ty : UScalarTy} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (div x y)

def IScalar.try_div {ty : IScalarTy} (x y : IScalar ty): Option (IScalar ty) :=
  Option.ofResult (div x y)

instance {ty} : HDiv (UScalar ty) (UScalar ty) (Result (UScalar ty)) where
  hDiv x y := UScalar.div x y

instance {ty} : HDiv (IScalar ty) (IScalar ty) (Result (IScalar ty)) where
  hDiv x y := IScalar.div x y

/-!
Remainder
-/
def UScalar.rem {ty : UScalarTy} (x y : UScalar ty) : Result (UScalar ty) :=
  if y.val != 0 then ok ⟨ BitVec.umod x.bv y.bv ⟩ else fail divisionByZero

def IScalar.rem {ty : IScalarTy} (x y : IScalar ty) : Result (IScalar ty) :=
  if y.val != 0 then ok ⟨ BitVec.srem x.bv y.bv ⟩
  else fail divisionByZero

def UScalar.try_rem {ty : UScalarTy} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (rem x y)

def IScalar.try_rem {ty : IScalarTy} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (rem x y)

instance {ty} : HMod (UScalar ty) (UScalar ty) (Result (UScalar ty)) where
  hMod x y := UScalar.rem x y

instance {ty} : HMod (IScalar ty) (IScalar ty) (Result (IScalar ty)) where
  hMod x y := IScalar.rem x y

/-!
Bit shifts
-/
def UScalar.shiftLeft {ty : UScalarTy} (x : UScalar ty) (s : Nat) :
  Result (UScalar ty) :=
  if s < ty.bitWidth then
    ok ⟨ x.bv.shiftLeft s ⟩
  else fail .integerOverflow

def UScalar.shiftRight {ty : UScalarTy} (x : UScalar ty) (s : Nat) :
  Result (UScalar ty) :=
  if s < ty.bitWidth then
    ok ⟨ x.bv.ushiftRight s ⟩
  else fail .integerOverflow

def UScalar.shiftLeft_UScalar {ty tys} (x : UScalar ty) (s : UScalar tys) :
  Result (UScalar ty) :=
  x.shiftLeft s.val

def UScalar.shiftRight_UScalar {ty tys} (x : UScalar ty) (s : UScalar tys) :
  Result (UScalar ty) :=
  x.shiftRight s.val

def UScalar.shiftLeft_IScalar {ty tys} (x : UScalar ty) (s : IScalar tys) :
  Result (UScalar ty) :=
  x.shiftLeft s.toNat

def UScalar.shiftRight_IScalar {ty tys} (x : UScalar ty) (s : IScalar tys) :
  Result (UScalar ty) :=
  x.shiftRight s.toNat

def IScalar.shiftLeft {ty : IScalarTy} (x : IScalar ty) (s : Nat) :
  Result (IScalar ty) :=
  if s < ty.bitWidth then
    ok ⟨ x.bv.shiftLeft s ⟩
  else fail .integerOverflow

def IScalar.shiftRight {ty : IScalarTy} (x : IScalar ty) (s : Nat) :
  Result (IScalar ty) :=
  if s < ty.bitWidth then
    ok ⟨ x.bv.sshiftRight s ⟩
  else fail .integerOverflow

def IScalar.shiftLeft_UScalar {ty tys} (x : IScalar ty) (s : UScalar tys) :
  Result (IScalar ty) :=
  x.shiftLeft s.val

def IScalar.shiftRight_UScalar {ty tys} (x : IScalar ty) (s : UScalar tys) :
  Result (IScalar ty) :=
  x.shiftRight s.val

def IScalar.shiftLeft_IScalar {ty tys} (x : IScalar ty) (s : IScalar tys) :
  Result (IScalar ty) :=
  if s.val ≥ 0 then
    x.shiftLeft s.toNat
  else fail .integerOverflow

def IScalar.shiftRight_IScalar {ty tys} (x : IScalar ty) (s : IScalar tys) :
  Result (IScalar ty) :=
  if s.val ≥ 0 then
    x.shiftRight s.toNat
  else fail .integerOverflow

instance {ty0 ty1} : HShiftLeft (UScalar ty0) (UScalar ty1) (Result (UScalar ty0)) where
  hShiftLeft x y := UScalar.shiftLeft_UScalar x y

instance {ty0 ty1} : HShiftLeft (UScalar ty0) (IScalar ty1) (Result (UScalar ty0)) where
  hShiftLeft x y := UScalar.shiftLeft_IScalar x y

instance {ty0 ty1} : HShiftLeft (IScalar ty0) (UScalar ty1) (Result (IScalar ty0)) where
  hShiftLeft x y := IScalar.shiftLeft_UScalar x y

instance {ty0 ty1} : HShiftLeft (IScalar ty0) (IScalar ty1) (Result (IScalar ty0)) where
  hShiftLeft x y := IScalar.shiftLeft_IScalar x y

instance {ty0 ty1} : HShiftRight (UScalar ty0) (UScalar ty1) (Result (UScalar ty0)) where
  hShiftRight x y := UScalar.shiftRight_UScalar x y

instance {ty0 ty1} : HShiftRight (UScalar ty0) (IScalar ty1) (Result (UScalar ty0)) where
  hShiftRight x y := UScalar.shiftRight_IScalar x y

instance {ty0 ty1} : HShiftRight (IScalar ty0) (UScalar ty1) (Result (IScalar ty0)) where
  hShiftRight x y := IScalar.shiftRight_UScalar x y

instance {ty0 ty1} : HShiftRight (IScalar ty0) (IScalar ty1) (Result (IScalar ty0)) where
  hShiftRight x y := IScalar.shiftRight_IScalar x y

/-!
Bitwise and
-/
def UScalar.and {ty} (x y : UScalar ty) : UScalar ty := ⟨ x.bv &&& y.bv ⟩

def IScalar.and {ty} (x y : IScalar ty) : IScalar ty := ⟨ x.bv &&& y.bv ⟩

instance {ty} : HAnd (UScalar ty) (UScalar ty) (UScalar ty) where
  hAnd x y := UScalar.and x y

instance {ty} : HAnd (IScalar ty) (IScalar ty) (IScalar ty) where
  hAnd x y := IScalar.and x y

/-!
Bitwise or
-/
def UScalar.or {ty} (x y : UScalar ty) : UScalar ty := ⟨ x.bv ||| y.bv ⟩

def IScalar.or {ty} (x y : IScalar ty) : IScalar ty := ⟨ x.bv ||| y.bv ⟩

instance {ty} : HOr (UScalar ty) (UScalar ty) (UScalar ty) where
  hOr x y := UScalar.or x y

instance {ty} : HOr (IScalar ty) (IScalar ty) (IScalar ty) where
  hOr x y := IScalar.or x y

/-!
Xor
-/
def UScalar.xor {ty} (x y : UScalar ty) : UScalar ty := ⟨ x.bv ||| y.bv ⟩

def IScalar.xor {ty} (x y : IScalar ty) : IScalar ty := ⟨ x.bv ||| y.bv ⟩

instance {ty} : HXor (UScalar ty) (UScalar ty) (UScalar ty) where
  hXor x y := UScalar.xor x y

instance {ty} : HXor (IScalar ty) (IScalar ty) (IScalar ty) where
  hXor x y := IScalar.xor x y

/-!
Not
-/
def UScalar.not {ty} (x : UScalar ty) : UScalar ty := ⟨ ~~~x.bv ⟩

def IScalar.not {ty} (x : IScalar ty) : IScalar ty := ⟨ ~~~x.bv ⟩

instance {ty} : Complement (UScalar ty) where
  complement x := UScalar.not x

instance {ty} : Complement (IScalar ty) where
  complement x := IScalar.not x

/-!
Casts

The reference semantics are here: https://doc.rust-lang.org/reference/expressions/operator-expr.html#semantics
-/

/-- When casting between unsigned integers, we truncate or **zero**-extend the integer. -/
def UScalar.cast {src_ty : UScalarTy} (tgt_ty : UScalarTy) (x : UScalar src_ty) : UScalar tgt_ty :=
  -- This truncates the integer if the bitWidth is smaller
  ⟨ x.bv.zeroExtend tgt_ty.bitWidth ⟩

/- Heterogeneous cast

   When casting from an unsigned integer to a signed integer, we truncate or **zero**-extend.
-/
def UScalar.hcast {src_ty : UScalarTy} (tgt_ty : IScalarTy) (x : UScalar src_ty) : IScalar tgt_ty :=
  -- This truncates the integer if the bitWidth is smaller
  ⟨ x.bv.zeroExtend tgt_ty.bitWidth ⟩

/-- When casting between signed integers, we truncate or **sign**-extend. -/
def IScalar.cast {src_ty : IScalarTy} (tgt_ty : IScalarTy) (x : IScalar src_ty) : IScalar tgt_ty :=
  ⟨ x.bv.signExtend tgt_ty.bitWidth ⟩

/- Heterogeneous cast

   When casting from a signed integer to a unsigned integer, we truncate or **sign**-extend.
-/
def IScalar.hcast {src_ty : IScalarTy} (tgt_ty : UScalarTy) (x : IScalar src_ty) : UScalar tgt_ty :=
  ⟨ x.bv.signExtend tgt_ty.bitWidth ⟩

section
    /-! Checking that the semantics of casts are correct by using the examples given by the Rust reference. -/

  private def check_cast_i_to_u (src : Int) (src_ty : IScalarTy) (tgt : Nat) (tgt_ty : UScalarTy)
    (hSrc : IScalar.cMin src_ty ≤ src ∧ src ≤ IScalar.cMax src_ty := by decide)
    (hTgt : tgt ≤ UScalar.cMax tgt_ty := by decide): Bool :=
    IScalar.hcast tgt_ty (@IScalar.ofInt src_ty src hSrc) = @UScalar.ofNat tgt_ty tgt hTgt

  private def check_cast_u_to_i (src : Nat) (src_ty : UScalarTy) (tgt : Int) (tgt_ty : IScalarTy)
    (hSrc : src ≤ UScalar.cMax src_ty := by decide)
    (hTgt : IScalar.cMin tgt_ty ≤ tgt ∧ tgt ≤ IScalar.cMax tgt_ty := by decide) : Bool :=
    UScalar.hcast tgt_ty (@UScalar.ofNat src_ty src hSrc) = @IScalar.ofInt tgt_ty tgt hTgt

  private def check_cast_u_to_u (src : Nat) (src_ty : UScalarTy) (tgt : Nat) (tgt_ty : UScalarTy)
    (hSrc : src ≤ UScalar.cMax src_ty := by decide)
    (hTgt : tgt ≤ UScalar.cMax tgt_ty := by decide) : Bool :=
    UScalar.cast tgt_ty (@UScalar.ofNat src_ty src hSrc) = @UScalar.ofNat tgt_ty tgt hTgt

  private def check_cast_i_to_i (src : Int) (src_ty : IScalarTy) (tgt : Int) (tgt_ty : IScalarTy)
    (hSrc : IScalar.cMin src_ty ≤ src ∧ src ≤ IScalar.cMax src_ty := by decide)
    (hTgt : IScalar.cMin tgt_ty ≤ tgt ∧ tgt ≤ IScalar.cMax tgt_ty := by decide) : Bool :=
    IScalar.cast tgt_ty (@IScalar.ofInt src_ty src hSrc) = @IScalar.ofInt tgt_ty tgt hTgt

  local macro:max x:term:max noWs "i8" : term => `(I8.ofInt $x (by decide))
  local macro:max x:term:max noWs "i16" : term => `(I16.ofInt $x (by decide))
  local macro:max x:term:max noWs "i32" : term => `(I32.ofInt $x (by decide))
  local macro:max x:term:max noWs "u8" : term => `(U8.ofNat $x (by decide))
  local macro:max x:term:max noWs "u16" : term => `(U16.ofNat $x (by decide))

  /- Cast between integers of same size -/
  #assert IScalar.hcast _ 42i8    = 42u8       -- assert_eq!(42i8 as u8, 42u8);
  #assert IScalar.hcast _ (-1)i8  = 255u8      -- assert_eq!(-1i8 as u8, 255u8);
  #assert UScalar.hcast _ 255u8   = (-1)i8     -- assert_eq!(255u8 as i8, -1i8);
  #assert IScalar.hcast _ (-1)i16 = 65535u16   -- assert_eq!(-1i16 as u16, 65535u16);

  /- Cast from larger integer to smaller integer -/
  #assert UScalar.cast _ 42u16 = 42u8         -- assert_eq!(42u16 as u8, 42u8);
  #assert UScalar.cast _ 1234u16 = 210u8      -- assert_eq!(1234u16 as u8, 210u8);
  #assert UScalar.cast _ 0xabcdu16 = 0xcdu8   -- assert_eq!(0xabcdu16 as u8, 0xcdu8);

  #assert IScalar.cast _ (-42)i16 = (-42)i8   -- assert_eq!(-42i16 as i8, -42i8);
  #assert UScalar.hcast _ 1234u16 = (-46)i8   -- assert_eq!(1234u16 as i8, -46i8);
  #assert IScalar.cast _ 0xabcdi32 = (-51)i8  -- assert_eq!(0xabcdi32 as i8, -51i8);

  /- Cast from a smaller integer to a larger integer -/
  #assert IScalar.cast _ 42i8 = 42i16 -- assert_eq!(42i8 as i16, 42i16);
  #assert IScalar.cast _ (-17)i8 = (-17)i16 -- assert_eq!(-17i8 as i16, -17i16);
  #assert UScalar.cast _ 0b1000_1010u8 = 0b0000_0000_1000_1010u16 -- assert_eq!(0b1000_1010u8 as u16, 0b0000_0000_1000_1010u16, "Zero-extend");
  #assert IScalar.cast _ 0b0000_1010i8 = 0b0000_0000_0000_1010i16 -- assert_eq!(0b0000_1010i8 as i16, 0b0000_0000_0000_1010i16, "Sign-extend 0");
  #assert (IScalar.cast .I16 (UScalar.hcast .I8 0b1000_1010u8)) = UScalar.hcast .I16 0b1111_1111_1000_1010u16 -- assert_eq!(0b1000_1010u8 as i8 as i16, 0b1111_1111_1000_1010u16 as i16, "Sign-extend 1");

end

def UScalar.cast_fromBool (ty : UScalarTy) (x : Bool) : UScalar ty :=
  if x then ⟨ 1#ty.bitWidth ⟩ else ⟨ 0#ty.bitWidth ⟩

def IScalar.cast_fromBool (ty : IScalarTy) (x : Bool) : IScalar ty :=
  if x then ⟨ 1#ty.bitWidth ⟩ else ⟨ 0#ty.bitWidth ⟩

/-!
Negation
-/
def IScalar.neg {ty : IScalarTy} (x : IScalar ty) : Result (IScalar ty) := IScalar.tryMk ty (- x.val)

/--
The notation typeclass for heterogeneous negation.

There is no heterogenous negation in the Lean prelude: we thus introduce one here.
-/
class HNeg (α : Type u) (β : outParam (Type v)) where
  /-- `- a` computes the negation of `a`.
  The meaning of this notation is type-dependent. -/
  hNeg : α → β

/- Notation for heterogeneous negation.

   We initially used the notation "-" but it conflicted with the homogeneous
   negation too much. In particular, it made terms like `-10` ambiguous,
   and seemingly caused to backtracking in elaboration, leading to definitions
   like arrays of constants to take an unreasonable time to get elaborated
   and type-checked.

   TODO: PR to replace Neg with HNeg in Lean?
 -/
prefix:75  "-."   => HNeg.hNeg

/- We need this, otherwise we break pattern matching like in:

   ```
   def is_minus_one (x : Int) : Bool :=
     match x with
     | -1 => true
     | _ => false
   ```
-/
attribute [match_pattern] HNeg.hNeg

instance {ty} : HNeg (IScalar ty) (Result (IScalar ty)) where hNeg x := IScalar.neg x

/-!

## Primitive Operations: Theorems

-/

/-- Important theorem to reason with `Int.bmod` in the proofs about `IScalar` -/
private theorem bmod_pow_bitWidth_eq_of_lt (ty : IScalarTy) (x : Int)
  (h0 : - 2 ^ (ty.bitWidth-1) ≤ x) (h1 : x < 2 ^ (ty.bitWidth -1)) :
  Int.bmod x (2^ty.bitWidth) = x := by
  have := ty.bitWidth_nonzero
  have hEq : ty.bitWidth - 1 + 1 = ty.bitWidth := by omega
  have := Int.bmod_pow2_eq_of_inBounds (ty.bitWidth-1) x (by omega) (by omega)
  simp [hEq] at this
  apply this

/-!
### Add
-/

theorem UScalar.add_equiv {ty} (x y : UScalar ty) :
  match x + y with
  | ok z =>
    UScalar.inBounds ty (x.val + y.val) ∧
    z.val = x.val + y.val ∧
    z.bv = x.bv + y.bv
  | fail _ => ¬ (UScalar.inBounds ty (x.val + y.val))
  | _ => ⊥ := by
  have : x + y = add x y := by rfl
  rw [this]
  simp [add]
  have h := tryMk_eq ty (↑x + ↑y)
  simp [inBounds] at h
  split at h <;> simp_all
  zify; simp
  zify at h; simp [max_eq_smax, smax] at h
  have := @Int.emod_eq_of_lt (x.val + y.val) (2^ty.bitWidth) (by omega) (by omega)
  simp [*]

theorem IScalar.add_equiv {ty} (x y : IScalar ty) :
  match x + y with
  | ok z =>
    IScalar.inBounds ty (x.val + y.val) ∧
    z.val = x.val + y.val ∧
    z.bv = x.bv + y.bv
  | fail _ => ¬ (IScalar.inBounds ty (x.val + y.val))
  | _ => ⊥ := by
  have : x + y = add x y := by rfl
  rw [this]
  simp [add]
  have h := tryMk_eq ty (↑x + ↑y)
  simp [inBounds] at h
  split at h <;> simp_all
  apply BitVec.eq_of_toInt_eq
  simp
  simp [bound_eq_sbound, smin, smax] at h
  have := bmod_pow_bitWidth_eq_of_lt ty (x.val + y.val) (by omega) (by omega)
  simp [*]

/-!
Theorems about the addition, with a specification which uses
integers and bit-vectors.
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.add_bv_spec {ty} {x y : UScalar ty}
  (hmax : ↑x + ↑y ≤ UScalar.max ty) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv := by
  have h := @add_equiv ty x y
  split at h <;> simp_all

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.add_bv_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x + ↑y)
  (hmax : ↑x + ↑y ≤ IScalar.max ty) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv := by
  have h := @add_equiv ty x y
  split at h <;> simp_all

theorem Usize.add_bv_spec {x y : Usize} (hmax : x.val + y.val ≤ Usize.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem U8.add_bv_spec {x y : U8} (hmax : x.val + y.val ≤ U8.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem U16.add_bv_spec {x y : U16} (hmax : x.val + y.val ≤ U16.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem U32.add_bv_spec {x y : U32} (hmax : x.val + y.val ≤ U32.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem U64.add_bv_spec {x y : U64} (hmax : x.val + y.val ≤ U64.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem U128.add_bv_spec {x y : U128} (hmax : x.val + y.val ≤ U128.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  UScalar.add_bv_spec hmax

theorem Isize.add_bv_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ Isize.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

theorem I8.add_bv_spec {x y : I8}
  (hmin : I8.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I8.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

theorem I16.add_bv_spec {x y : I16}
  (hmin : I16.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I16.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

theorem I32.add_bv_spec {x y : I32}
  (hmin : I32.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I32.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

theorem I64.add_bv_spec {x y : I64}
  (hmin : I64.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I64.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

theorem I128.add_bv_spec {x y : I128}
  (hmin : I128.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I128.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y ∧ z.bv = x.bv + y.bv :=
  IScalar.add_bv_spec hmin hmax

/-!
Theorems about the addition, with a specification which uses
only integers. Those are the most common to use, so we mark them with the
`progress` attribute.
-/

/-- Generic theorem - shouldn't be used much -/
@[progress]
theorem UScalar.add_spec {ty} {x y : UScalar ty}
  (hmax : ↑x + ↑y ≤ UScalar.max ty) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y := by
  have h := @add_equiv ty x y
  split at h <;> simp_all

/-- Generic theorem - shouldn't be used much -/
@[progress]
theorem IScalar.add_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x + ↑y)
  (hmax : ↑x + ↑y ≤ IScalar.max ty) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y := by
  have h := @add_equiv ty x y
  split at h <;> simp_all

@[progress] theorem Usize.add_spec {x y : Usize} (hmax : x.val + y.val ≤ Usize.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem U8.add_spec {x y : U8} (hmax : x.val + y.val ≤ U8.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem U16.add_spec {x y : U16} (hmax : x.val + y.val ≤ U16.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem U32.add_spec {x y : U32} (hmax : x.val + y.val ≤ U32.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem U64.add_spec {x y : U64} (hmax : x.val + y.val ≤ U64.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem U128.add_spec {x y : U128} (hmax : x.val + y.val ≤ U128.max) :
  ∃ z, x + y = ok z ∧ (↑z : Nat) = ↑x + ↑y :=
  UScalar.add_spec hmax

@[progress] theorem Isize.add_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ Isize.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

@[progress] theorem I8.add_spec {x y : I8}
  (hmin : I8.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I8.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

@[progress] theorem I16.add_spec {x y : I16}
  (hmin : I16.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I16.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

@[progress] theorem I32.add_spec {x y : I32}
  (hmin : I32.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I32.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

@[progress] theorem I64.add_spec {x y : I64}
  (hmin : I64.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I64.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

@[progress] theorem I128.add_spec {x y : I128}
  (hmin : I128.min ≤ ↑x + ↑y) (hmax : ↑x + ↑y ≤ I128.max) :
  ∃ z, x + y = ok z ∧ (↑z : Int) = ↑x + ↑y :=
  IScalar.add_spec hmin hmax

/-!
### Sub
-/


theorem UScalar.sub_equiv {ty} (x y : UScalar ty) :
  match x - y with
  | ok z =>
    y.val ≤ x.val ∧
    x.val = z.val + y.val ∧
    z.bv = x.bv - y.bv
  | fail _ => x.val < y.val
  | _ => ⊥ := by
  have : x - y = sub x y := by rfl
  simp [this, sub]
  dcases h : x.val < y.val <;> simp [h]
  simp_all
  simp only [UScalar.val]
  simp
  split_conjs
  . have: (x.val - y.val) % 2^ty.bitWidth = x.val - y.val := by
      have : 0 < 2^ty.bitWidth := by simp
      have := x.hBounds; simp [max_eq_smax, smax] at this
      apply Nat.mod_eq_of_lt; omega
    simp [this]
    omega
  . zify; simp
    have : (x.val - y.val : Nat) = (x.val : Int) - y.val := by omega
    rw [this]; clear this
    ring_nf
    rw [Int.add_emod]
    have : ((2^ty.bitWidth - y.val) : Nat) % (2^ty.bitWidth : Int) =
           (- (y.val : Int)) % (2^ty.bitWidth : Int) := by
      have : (2^ty.bitWidth - y.val : Nat) = (2^ty.bitWidth : Int) - y.val := by
        have hBounds := y.hBounds
        simp [max_eq_smax, smax] at hBounds
        zify at *; simp at *
        have : (2^ty.bitWidth : Nat) = (2^ty.bitWidth : Int) := by simp
        omega
      rw [this]
      -- TODO: Int.emod_sub_emod not in this version of mathlib
      have := Int.emod_add_emod (2^ty.bitWidth) (2^ty.bitWidth) (-y.val)
      ring_nf at this
      ring_nf
      rw [← this]
      simp
    rw [this]
    rw [← Int.add_emod]
    ring_nf

theorem IScalar.sub_equiv {ty} (x y : IScalar ty) :
  match x - y with
  | ok z =>
    IScalar.inBounds ty (x.val - y.val) ∧
    z.val = x.val - y.val ∧
    z.bv = x.bv - y.bv
  | fail _ => ¬ (IScalar.inBounds ty (x.val - y.val))
  | _ => ⊥ := by
  have : x - y = sub x y := by rfl
  simp [this, sub]
  have h := tryMk_eq ty (↑x - ↑y)
  simp [inBounds] at h
  split at h <;> simp_all
  apply BitVec.eq_of_toInt_eq
  simp
  simp [bound_eq_sbound, smin, smax] at h
  have := bmod_pow_bitWidth_eq_of_lt ty (x.val - y.val) (by omega) (by omega)
  simp [*]

/-!
Theorems with a specification which uses integers and bit-vectors
-/

/- Generic theorem - shouldn't be used much -/
theorem UScalar.sub_bv_spec {ty} {x y : UScalar ty}
  (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv := by
  have h := @sub_equiv ty x y
  split at h <;> simp_all
  omega

/- Generic theorem - shouldn't be used much -/
theorem IScalar.sub_bv_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x - ↑y)
  (hmax : ↑x - ↑y ≤ IScalar.max ty) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv := by
  have h := @sub_equiv ty x y
  split at h <;> simp_all

theorem Usize.sub_bv_spec {x y : Usize} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem U8.sub_bv_spec {x y : U8} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem U16.sub_bv_spec {x y : U16} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem U32.sub_bv_spec {x y : U32} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem U64.sub_bv_spec {x y : U64} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem U128.sub_bv_spec {x y : U128} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val ∧ z.bv = x.bv - y.bv :=
  UScalar.sub_bv_spec h

theorem Isize.sub_bv_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ Isize.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

theorem I8.sub_bv_spec {x y : I8}
  (hmin : I8.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I8.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

theorem I16.sub_bv_spec {x y : I16}
  (hmin : I16.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I16.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

theorem I32.sub_bv_spec {x y : I32}
  (hmin : I32.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I32.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

theorem I64.sub_bv_spec {x y : I64}
  (hmin : I64.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I64.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

theorem I128.sub_bv_spec {x y : I128}
  (hmin : I128.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I128.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y ∧ z.bv = x.bv - y.bv :=
  IScalar.sub_bv_spec hmin hmax

/-!
Theorems with a specification which only uses integers
-/

/- Generic theorem - shouldn't be used much -/
@[progress]
theorem UScalar.sub_spec {ty} {x y : UScalar ty}
  (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val := by
  have h := @sub_equiv ty x y
  split at h <;> simp_all
  omega

/- Generic theorem - shouldn't be used much -/
@[progress]
theorem IScalar.sub_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x - ↑y)
  (hmax : ↑x - ↑y ≤ IScalar.max ty) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y := by
  have h := @sub_equiv ty x y
  split at h <;> simp_all

@[progress] theorem Usize.sub_spec {x y : Usize} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem U8.sub_spec {x y : U8} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem U16.sub_spec {x y : U16} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem U32.sub_spec {x y : U32} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem U64.sub_spec {x y : U64} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem U128.sub_spec {x y : U128} (h : y.val ≤ x.val) :
  ∃ z, x - y = ok z ∧ x.val = z.val + y.val :=
  UScalar.sub_spec h

@[progress] theorem Isize.sub_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ Isize.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

@[progress] theorem I8.sub_spec {x y : I8}
  (hmin : I8.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I8.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

@[progress] theorem I16.sub_spec {x y : I16}
  (hmin : I16.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I16.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

@[progress] theorem I32.sub_spec {x y : I32}
  (hmin : I32.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I32.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

@[progress] theorem I64.sub_spec {x y : I64}
  (hmin : I64.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I64.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

@[progress] theorem I128.sub_spec {x y : I128}
  (hmin : I128.min ≤ ↑x - ↑y) (hmax : ↑x - ↑y ≤ I128.max) :
  ∃ z, x - y = ok z ∧ (↑z : Int) = ↑x - ↑y :=
  IScalar.sub_spec hmin hmax

/-!
### Mul
-/

/-!
Theorems with a specification which use integers and bit-vectors
-/

theorem UScalar.mul_equiv {ty} (x y : UScalar ty) :
  match mul x y with
  | ok z => x.val * y.val ≤ UScalar.max ty ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv
  | fail _ => UScalar.max ty < x.val * y.val
  | .div => False := by
  simp [mul]
  have := tryMk_eq ty (x.val * y.val)
  split <;> simp_all
  simp_all [tryMk, tryMkOpt]
  rename_i hEq; simp only [← hEq, ofNatCore, val]
  zify; simp

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.mul_bv_spec {ty} {x y : UScalar ty}
  (hmax : ↑x * ↑y ≤ UScalar.max ty) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv := by
  have : x * y = mul x y := by rfl
  have := mul_equiv x y
  split at this <;> simp_all
  omega

theorem IScalar.mul_equiv {ty} (x y : IScalar ty) :
  match mul x y with
  | ok z => IScalar.min ty ≤ x.val * y.val ∧ x.val * y.val ≤ IScalar.max ty ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | fail _ => ¬(IScalar.min ty ≤ x.val * y.val ∧ x.val * y.val ≤ IScalar.max ty)
  | .div => False := by
  simp [mul]
  have := tryMk_eq ty (x.val * y.val)
  split <;> simp_all
  simp_all [tryMk, tryMkOpt]
  rename_i hEq; simp only [← hEq, ofIntCore, val]
  simp [← BitVec.toInt_inj]

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.mul_bv_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ IScalar.max ty) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv := by
  have : x * y = mul x y := by rfl
  have := mul_equiv x y
  split at this <;> simp_all

theorem Usize.mul_bv_spec {x y : Usize} (hmax : x.val * y.val ≤ Usize.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem U8.mul_bv_spec {x y : U8} (hmax : x.val * y.val ≤ U8.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem U16.mul_bv_spec {x y : U16} (hmax : x.val * y.val ≤ U16.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem U32.mul_bv_spec {x y : U32} (hmax : x.val * y.val ≤ U32.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem U64.mul_bv_spec {x y : U64} (hmax : x.val * y.val ≤ U64.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem U128.mul_bv_spec {x y : U128} (hmax : x.val * y.val ≤ U128.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  UScalar.mul_bv_spec hmax

theorem Isize.mul_bv_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ Isize.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax

theorem I8.mul_bv_spec {x y : I8}
  (hmin : I8.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I8.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax

theorem I16.mul_bv_spec {x y : I16}
  (hmin : I16.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I16.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax

theorem I32.mul_bv_spec {x y : I32}
  (hmin : I32.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I32.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax

theorem I64.mul_bv_spec {x y : I64} (hmin : I64.min ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ I64.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax

theorem I128.mul_bv_spec {x y : I128} (hmin : I128.min ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ I128.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y ∧ z.bv = x.bv * y.bv :=
  IScalar.mul_bv_spec hmin hmax


/-!
Theorems with a specification which only use integers
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.mul_spec {ty} {x y : UScalar ty}
  (hmax : ↑x * ↑y ≤ UScalar.max ty) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y := by
  have ⟨ z, h⟩ := mul_bv_spec hmax
  simp [h]

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.mul_spec {ty} {x y : IScalar ty}
  (hmin : IScalar.min ty ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ IScalar.max ty) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y := by
  have ⟨ z, h⟩ := mul_bv_spec hmin hmax
  simp [h]

@[progress] theorem Usize.mul_spec {x y : Usize} (hmax : x.val * y.val ≤ Usize.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem U8.mul_spec {x y : U8} (hmax : x.val * y.val ≤ U8.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem U16.mul_spec {x y : U16} (hmax : x.val * y.val ≤ U16.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem U32.mul_spec {x y : U32} (hmax : x.val * y.val ≤ U32.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem U64.mul_spec {x y : U64} (hmax : x.val * y.val ≤ U64.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem U128.mul_spec {x y : U128} (hmax : x.val * y.val ≤ U128.max) :
  ∃ z, x * y = ok z ∧ (↑z : Nat) = ↑x * ↑y :=
  UScalar.mul_spec hmax

@[progress] theorem Isize.mul_spec {x y : Isize}
  (hmin : Isize.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ Isize.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

@[progress] theorem I8.mul_spec {x y : I8}
  (hmin : I8.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I8.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

@[progress] theorem I16.mul_spec {x y : I16}
  (hmin : I16.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I16.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

@[progress] theorem I32.mul_spec {x y : I32}
  (hmin : I32.min ≤ ↑x * ↑y) (hmax : ↑x * ↑y ≤ I32.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

@[progress] theorem I64.mul_spec {x y : I64} (hmin : I64.min ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ I64.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

@[progress] theorem I128.mul_spec {x y : I128} (hmin : I128.min ≤ ↑x * ↑y)
  (hmax : ↑x * ↑y ≤ I128.max) :
  ∃ z, x * y = ok z ∧ (↑z : Int) = ↑x * ↑y :=
  IScalar.mul_spec hmin hmax

/-!
### Div
-/

/-!
Theorems with a specification which use integers and bit-vectors
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.div_bv_spec {ty} (x : UScalar ty) {y : UScalar ty}
  (hzero : y.val ≠ 0) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv := by
  have hzero' : y.bv ≠ 0#ty.bitWidth := by
    intro h
    zify at h
    simp_all
  conv => congr; ext; lhs; simp [HDiv.hDiv]
  simp [hzero', div, tryMk, tryMkOpt, ofOption, hmax, ofNatCore]
  simp only [val]
  simp

theorem Int.bmod_pow2_IScalarTy_bitWidth_minus_one (ty : IScalarTy) :
  Int.bmod (2 ^ (ty.bitWidth - 1)) (2 ^ ty.bitWidth) = - 2 ^ (ty.bitWidth - 1) := by
  rw [Int.bmod]
  /- Just doing a case disjunction on the number of bits because
     those proofs are annoying -/
  dcases ty <;> simp
  have := System.Platform.numBits_eq
  cases this <;> simp [*]

theorem IScalar.neg_imp_neg_val_toNat_mod_pow_eq_neg_val {ty} (x : IScalar ty)
  (hNeg : x.bv.toInt < 0) :
  ((-x.val).toNat : Int) % 2^ty.bitWidth = -(x.val : Int) := by
  have hmsb : x.bv.msb = true := by
    have := @BitVec.msb_eq_toInt _ x.bv
    simp only [hNeg] at this
    apply this
  have hx := @BitVec.toInt_eq_msb_cond _ x.bv
  simp [hmsb] at hx
  have hBounds := x.hBounds; simp [bound_eq_sbound, smin, smax] at hBounds
  have pow2Ineq : (2^(ty.bitWidth - 1) : Int) < 2^ty.bitWidth := by
    have := ty.bitWidth_nonzero
    have : (0 : Int) < 2^(ty.bitWidth - 1) := by simp
    have : ty.bitWidth = ty.bitWidth - 1 + 1 := by omega
    conv => rhs; rw [this]
    rw [Int.pow_succ']
    omega
  have hyToNat : 2 ^ ty.bitWidth - x.bv.toNat = (-x.val).toNat := by
    rw [hx]
    simp
    norm_cast
  have hyValToNatMod : ((-x.val).toNat : Nat) % 2^ty.bitWidth = (-x.val).toNat := by
    have : ↑(-x.val).toNat < 2 ^ ty.bitWidth := by
      zify
      apply Int.lt_of_neg_lt_neg
      have : - (-x.val).toNat = x.val := by omega
      rw [this]; clear this
      have := x.hmin
      simp [min_eq_smin, smin] at this
      omega
    have := @Nat.mod_eq_of_lt (-x.val).toNat (2^ty.bitWidth) (by omega)
    apply this
  zify at hyValToNatMod
  rw [hyValToNatMod]
  omega

theorem IScalar.neg_imp_toNat_neg_eq_neg_toInt {ty} (x : IScalar ty) (hNeg : x.val < 0):
  (-x.bv).toNat = -x.bv.toInt := by
  have hmsb : x.bv.msb = true := by
    have := @BitVec.msb_eq_toInt _ x.bv
    simp only [val] at hNeg
    simp only [hNeg] at this
    apply this
  have hx := @BitVec.toInt_eq_msb_cond _ x.bv
  simp [hmsb] at hx

  have hxNeg : x.val < 0 := by
    have := @BitVec.msb_eq_toInt _ x.bv
    simp_all

  conv => lhs; simp only [Neg.neg, BitVec.neg]
  simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod]

  have hxToNatMod : (x.bv.toNat : Int) % 2^ty.bitWidth = x.bv.toNat := by
    apply Int.emod_eq_of_lt <;> omega

  have hPow : (2 ^ ty.bitWidth + 1 : Int) / 2  = 2^(ty.bitWidth - 1) := by
    have : ty.bitWidth = ty.bitWidth - 1 + 1 := by
      have := ty.bitWidth_nonzero
      omega
    conv => lhs; rw [this]
    rw [Int.pow_succ']
    rw [Int.add_ediv_of_dvd_left] <;> simp

  have : ¬ ((x.bv.toNat : Int) % ↑(2 ^ ty.bitWidth : Nat) < (↑(2 ^ ty.bitWidth : Nat) + 1) / 2) := by
    have hIneq := @BitVec.msb_eq_toNat _ x.bv
    rw [hmsb] at hIneq
    simp at hIneq
    simp
    rw [hPow]

    rw [hxToNatMod]
    zify at hIneq
    omega
  rw [Int.bmod_def]
  simp only [this]
  simp
  have : (2 ^ ty.bitWidth - x.bv.toNat : Nat) % (2 ^ ty.bitWidth : Int) =
         (2^ty.bitWidth - x.bv.toNat : Nat) := by
    apply Int.emod_eq_of_lt
    . omega
    . have := x.hBounds; simp [bound_eq_sbound, smin, smax] at this
      simp only [val] at *
      have : (2 ^ ty.bitWidth - x.bv.toNat : Nat) = (2 ^ ty.bitWidth - x.bv.toNat : Int) := by
        have : (2 ^ ty.bitWidth : Nat) = (2 ^ ty.bitWidth : Int) := by simp
        omega
      rw [this]
      have : x.bv.toNat > 0 := by
        by_contra
        have hxz : x.bv.toNat = 0 := by omega
        have : x.bv.toInt = 0 := by
          simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod, Int.bmod_def, hxz]
          simp [hPow]
        omega
      omega
  rw [this]; clear this
  rw [hxToNatMod]

  have : (2 ^ ty.bitWidth : Nat) = (2 ^ ty.bitWidth : Int) := by simp
  omega

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.div_bv_spec {ty} {x y : IScalar ty}
  (hzero : y.val ≠ 0) (hNoOverflow : ¬ (x.val = IScalar.min ty ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv := by
  conv => congr; ext; lhs; simp [HDiv.hDiv]
  simp [div, tryMk, tryMkOpt, ofOption, ofIntCore, hzero, hNoOverflow]
  simp only [val]
  simp [BitVec.sdiv_eq, BitVec.udiv_def]
  have pow2Ineq : (2^(ty.bitWidth - 1) : Int) < 2^ty.bitWidth := by
    have := ty.bitWidth_nonzero
    have : (0 : Int) < 2^(ty.bitWidth - 1) := by simp
    have : ty.bitWidth = ty.bitWidth - 1 + 1 := by omega
    conv => rhs; rw [this]
    rw [Int.pow_succ']
    omega
  have hxBounds := x.hBounds; simp [bound_eq_sbound, smin, smax] at hxBounds
  have hyBounds := y.hBounds; simp [bound_eq_sbound, smin, smax] at hyBounds
  --have hxyBounds := tdiv_in_bounds x y hnoOverflow
  split

  . -- 0 ≤ x.bv.toInt
    -- 0 ≤ y.bv.toInt
    rw [BitVec.toInt_ofNat]
    simp
    have hx : x.bv.toNat = x.bv.toInt := by
      have := @BitVec.toInt_eq_msb_cond _ x.bv
      simp_all
    have hy : y.bv.toNat = y.bv.toInt := by
      have := @BitVec.toInt_eq_msb_cond _ y.bv
      simp_all
    simp [hx, hy]
    simp at hx hy
    have := @Int.tdiv_nonneg x.val y.val (by omega) (by omega)
    have : -2 ^ (ty.bitWidth - 1) ≤ 0 := by simp
    have : (x.val).tdiv y.val < 2 ^ (ty.bitWidth - 1) := by
      rw [Int.tdiv_eq_ediv] <;> try omega
      have := @Int.ediv_le_self x.val y.val (by omega)
      omega

    have := bmod_pow_bitWidth_eq_of_lt ty (Int.tdiv x.val y.val) (by omega) (by omega)
    rw [← Int.tdiv_eq_ediv] <;> omega

  . -- 0 ≤ x.bv.toInt
    -- y.bv.toInt < 0
    rename_i hxIneq hyIneq
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxIneq] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyIneq] at hy
    have hyNeg : y.val < 0 := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all
    have : -2 ^ (ty.bitWidth - 1) ≤ Int.tdiv x.val y.val := by
      have : Int.tdiv x.val (-y.val) ≤ 2^(ty.bitWidth - 1) := by
        rw [Int.tdiv_eq_ediv] <;> try omega
        have := @Int.ediv_le_self x.val (-y.val) (by omega)
        simp at *
        have := x.hmax
        simp [max_eq_smax, smax] at this
        omega
      replace this := Int.neg_le_neg this
      simp at this
      apply this
    have hyToNat : 2 ^ ty.bitWidth - y.bv.toNat = (-y.val).toNat := by
      rw [hy]
      simp
      norm_cast
    rw [BitVec.toInt_neg, BitVec.toInt_ofNat]
    simp
    rw [hyToNat]
    have : ((-y.val).toNat : Int) % 2^ty.bitWidth = -(y.val : Int) := by
      apply IScalar.neg_imp_neg_val_toNat_mod_pow_eq_neg_val
      simp; omega
    rw [this]; clear this
    simp
    rw [← hx]
    have : (- (x.val / y.val)).bmod (2^ty.bitWidth) = - (x.val / y.val) := by
      have : -(x.val / ↑y) < 2 ^ (ty.bitWidth - 1) := by
        have : x.val / (-y.val) < 2 ^ (ty.bitWidth - 1) := by
          have := @Int.ediv_le_self x.val (-y.val) (by omega)
          have := x.hmax; simp [max_eq_smax, smax] at this
          omega
        simp at this
        apply this
      have : 0 ≤ -(x.val / ↑y) := by
        have : - (x.val / y.val) = x.val / (-y.val) := by simp
        rw [this]; clear this
        apply Int.ediv_nonneg <;> omega
      have := bmod_pow_bitWidth_eq_of_lt ty (- (x.val / y.val)) (by omega) (by omega)
      rw [this]
    rw [this]; clear this
    simp
    have : (x.val / y.val).bmod (2^ty.bitWidth) = x.val / y.val := by
      have : -2 ^ (ty.bitWidth - 1) ≤ x.val / ↑y := by
        apply Int.le_of_neg_le_neg
        have : - (x.val / y.val) = x.val / -y.val := by simp
        rw [this]; clear this
        conv => rhs; simp
        have := @Int.ediv_le_self x.val (-y.val) (by omega)
        omega
      have : x.val / ↑y < 2 ^ (ty.bitWidth - 1) := by
        have : 0 < 2 ^ (ty.bitWidth - 1) := by simp
        have : x.val / y.val ≤ 0 := by apply Int.ediv_nonpos <;> omega
        omega
      have := bmod_pow_bitWidth_eq_of_lt ty (x.val / y.val) (by omega) (by omega)
      rw [this]

    rw [this]; clear this

    have : x.val.tdiv y.val = - (x.val.tdiv (-y.val)) := by simp
    rw [this]
    rw [Int.tdiv_eq_ediv] <;> try omega
    simp

  . -- x.bv.toInt < 0
    -- 0 ≤ y.bv.toInt
    rename_i hxIneq hyIneq
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxIneq] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyIneq] at hy
    have hxNeg : x.val < 0 := by
      have := @BitVec.msb_eq_toInt _ x.bv
      simp_all
    have hyPos : 0 ≤ y.val := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all
    have : -2 ^ (ty.bitWidth - 1) ≤ x.val / y.val := by
      have := @Int.ediv_le_ediv (-2 ^ (ty.bitWidth - 1)) x.val y.val (by omega) (by omega)
      have := @Int.self_le_ediv x.val y.val (by omega) (by omega)
      omega
    have hxToNat : 2 ^ ty.bitWidth - x.bv.toNat = (-x.val).toNat := by
      rw [hx]
      simp
      norm_cast
    rw [BitVec.toInt_neg, BitVec.toInt_ofNat]
    simp

    rw [hxToNat]
    have : ((-x.val).toNat : Int) % 2^ty.bitWidth = -(x.val : Int) := by
      apply IScalar.neg_imp_neg_val_toNat_mod_pow_eq_neg_val
      simp; omega
    rw [this]; clear this

    /- We have to treat separately the degenerate case where `x` touches the upper bound
       and `y = 1` -/
    dcases hxDivY : -x.val / y.val = 2^(ty.bitWidth - 1)
    . rw [← hy]
      rw [hxDivY]
      have ⟨ hx, hy ⟩ : x.val = - 2^(ty.bitWidth - 1) ∧ y.val = 1 := by
        have := @Int.le_div_eq_bound_imp_eq (-x.val) y.val (2^(ty.bitWidth - 1))
          (by omega) (by omega) (by omega) (by omega)
        omega
      simp [hx, hy]

      have : Int.bmod (2 ^ (ty.bitWidth - 1)) (2 ^ ty.bitWidth) =
             - 2 ^ (ty.bitWidth - 1) :=
        Int.bmod_pow2_IScalarTy_bitWidth_minus_one ty
      rw [this]
      simp
      rw [this]
    . have : 0 ≤ (-x.val) / y.val := by
        apply Int.ediv_nonneg <;> omega
      have : -x.val / y.val < 2^(ty.bitWidth - 1) := by
        have : -x.val ≤ 2^(ty.bitWidth - 1) := by omega
        have := @Int.ediv_le_self (-x.val) y.val (by omega)
        omega
      rw [← hy]
      have : (-x.val / y.val).bmod (2 ^ ty.bitWidth) =
             (-x.val / y.val) := by
        apply bmod_pow_bitWidth_eq_of_lt ty _ (by omega) (by omega)
      rw [this]; clear this
      have : (-(-x.val / ↑y)).bmod (2 ^ ty.bitWidth) =
             (-(-x.val / ↑y)) := by
        apply bmod_pow_bitWidth_eq_of_lt ty _ (by omega) (by omega)
      rw [this]; clear this
      rw [← Int.tdiv_eq_ediv] <;> try omega
      simp

  . -- x.bv.toInt < 0
    -- y.bv.toInt < 0
    rename_i hxIneq hyIneq
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxIneq] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyIneq] at hy
    have hxNeg : x.val < 0 := by
      have := @BitVec.msb_eq_toInt _ x.bv
      simp_all
    have hyNeg : y.val < 0 := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all
    have hxToNat : 2 ^ ty.bitWidth - x.bv.toNat = (-x.val).toNat := by
      rw [hx]
      simp
      norm_cast
    have hyToNat : 2 ^ ty.bitWidth - y.bv.toNat = (-y.val).toNat := by
      rw [hy]
      simp
      norm_cast
    rw [hxToNat, hyToNat]

    have : (-x.val).toNat % 2^ty.bitWidth = (-x.val).toNat := by
      apply Nat.mod_eq_of_lt
      omega
    rw [this]
    have : (-y.val).toNat % 2^ty.bitWidth = (-y.val).toNat := by
      apply Nat.mod_eq_of_lt
      omega
    rw [this]

    rw [BitVec.toInt_ofNat]

    /- We have to treat separately the degenerate case where `x` touches the lower bound
       and `y = -1`, because then `x / y` actually overflows -/
    have hxyInBouds : (-x.val) / (-y.val) ≠ 2^(ty.bitWidth - 1) := by
      -- We do the proof by contradiction
      intro hEq
      have hContra : x.val = - 2^(ty.bitWidth - 1) ∧ y.val = -1 := by
        have := @Int.le_div_eq_bound_imp_eq (-x.val) (-y.val) (2^(ty.bitWidth - 1))
          (by omega) (by omega) (by omega) (by omega)
        omega
      simp [hContra, min_eq_smin, smin] at hNoOverflow

    have : -(2 ^ (ty.bitWidth - 1) : Int) ≤ ↑((-x.val).toNat / (-y.val).toNat) := by
      have := @Int.ediv_nonneg (-x.val).toNat (-y.val).toNat (by omega) (by omega)
      have : -(2 ^ (ty.bitWidth - 1) : Int) ≤ 0 := by simp
      omega

    have : ((-x.val).toNat / (-y.val).toNat) < (2 ^ (ty.bitWidth - 1) : Int) := by
      -- First prove a ≤ bound
      have hIneq : ((-x.val).toNat / (-y.val).toNat) ≤ (2 ^ (ty.bitWidth - 1) : Int) := by
        have := @Int.ediv_le_self (-x.val).toNat (-y.val).toNat (by omega)
        omega
      -- Then use the hypothesis about the fact that we're not equal to the bound
      zify at hIneq
      have : (-x.val).toNat = -x.val := by omega
      rw [this] at hIneq; rw [this]
      have : (-y.val).toNat = -y.val := by omega
      rw [this] at hIneq; rw [this]
      omega
    have := bmod_pow_bitWidth_eq_of_lt ty ((-x.val).toNat / (-y.val).toNat : Nat) (by omega) (by omega)
    rw [this]

    zify; simp

    have : (-x.val) ⊔ 0 = -x.val := by omega
    simp only [this]; clear this
    have : -↑y ⊔ 0 = -y.val := by omega
    simp only [this]; clear this

    rw [← Int.tdiv_eq_ediv] <;> try omega
    simp

theorem U8.div_bv_spec (x : U8) {y : U8} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem U16.div_bv_spec (x : U16) {y : U16} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem U32.div_bv_spec (x : U32) {y : U32} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem U64.div_bv_spec (x : U64) {y : U64} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem U128.div_bv_spec (x : U128) {y : U128} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem Usize.div_bv_spec (x : Usize) {y : Usize} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y ∧ z.bv = x.bv / y.bv :=
  UScalar.div_bv_spec x hnz

theorem I8.div_bv_spec {x y : I8} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I8.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

theorem I16.div_bv_spec {x y : I16} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I16.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

theorem I32.div_bv_spec {x y : I32} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I32.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

theorem I64.div_bv_spec {x y : I64} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I64.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

theorem I128.div_bv_spec {x y : I128} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I128.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

theorem Isize.div_bv_spec {x y : Isize} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = Isize.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y ∧ z.bv = BitVec.sdiv x.bv y.bv :=
  IScalar.div_bv_spec hnz hNoOverflow

/-!
Theorems with a specification which only use integers
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.div_spec {ty} (x : UScalar ty) {y : UScalar ty}
  (hzero : y.val ≠ 0) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y := by
  have ⟨ z, hz ⟩ := UScalar.div_bv_spec x hzero
  simp [hz]

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.div_spec {ty} {x y : IScalar ty}
  (hzero : y.val ≠ 0)
  (hNoOverflow : ¬ (x.val = IScalar.min ty ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y := by
  have ⟨ z, hz ⟩ := IScalar.div_bv_spec hzero hNoOverflow
  simp [hz]

theorem U8.div_spec (x : U8) {y : U8} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem U16.div_spec (x : U16) {y : U16} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem U32.div_spec (x : U32) {y : U32} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem U64.div_spec (x : U64) {y : U64} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem U128.div_spec (x : U128) {y : U128} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem Usize.div_spec (x : Usize) {y : Usize} (hnz : ↑y ≠ (0 : Nat)) :
  ∃ z, x / y = ok z ∧ (↑z : Nat) = ↑x / ↑y :=
  UScalar.div_spec x hnz

theorem I8.div_spec {x y : I8} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I8.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

theorem I16.div_spec {x y : I16} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I16.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

theorem I32.div_spec {x y : I32} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I32.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

theorem I64.div_spec {x y : I64} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I64.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

theorem I128.div_spec {x y : I128} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = I128.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

theorem Isize.div_spec {x y : Isize} (hnz : ↑y ≠ (0 : Int))
  (hNoOverflow : ¬ (x.val = Isize.min ∧ y.val = -1)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = Int.tdiv ↑x ↑y :=
  IScalar.div_spec hnz hNoOverflow

/-!
### Remainder
-/

/-!
Theorems with a specification which uses integers and bit-vectors
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.rem_bv_spec {ty} (x : UScalar ty) {y : UScalar ty} (hzero : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv := by
  conv => congr; ext; lhs; simp [HMod.hMod]
  simp [hzero, rem, tryMk, tryMkOpt, ofOption, hmax, ofNatCore]
  simp only [val]
  simp

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.rem_bv_spec {ty} (x : IScalar ty) {y : IScalar ty} (hzero : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv := by
  conv => congr; ext; lhs; simp [HMod.hMod]
  simp [hzero, rem, tryMk, tryMkOpt, ofOption, hmax, ofIntCore]
  simp only [val]
  simp

  simp [BitVec.srem_eq]
  have pow2Ineq : (2^(ty.bitWidth - 1) : Int) < 2^ty.bitWidth := by
    have := ty.bitWidth_nonzero
    have : (0 : Int) < 2^(ty.bitWidth - 1) := by simp
    have : ty.bitWidth = ty.bitWidth - 1 + 1 := by omega
    conv => rhs; rw [this]
    rw [Int.pow_succ']
    omega
  have hxBounds := x.hBounds; simp [bound_eq_sbound, smin, smax] at hxBounds
  have hyBounds := y.hBounds; simp [bound_eq_sbound, smin, smax] at hyBounds
  have := ty.bitWidth_nonzero
  split

  . -- 0 ≤ x
    -- 0 ≤ y
    rename_i hxMsb hyMsb
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxMsb] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyMsb] at hy
    rw [Int.tmod_eq_emod] <;> try omega
    simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod]
    have : ((x.bv.toNat % y.bv.toNat : Nat) : Int) < 2 ^ (ty.bitWidth - 1) := by
      have := @Nat.mod_lt x.bv.toNat y.bv.toNat (by omega)
      zify at this
      omega
    have : ((x.bv.toNat % y.bv.toNat : Nat) : Int).bmod (2 ^ ty.bitWidth) = x.bv.toNat % y.bv.toNat := by
      apply bmod_pow_bitWidth_eq_of_lt ty _ (by omega) (by omega)
    rw [this]; clear this
    simp only [hx, hy]

  . -- 0 ≤ x
    -- y < 0
    rename_i hxMsb hyMsb
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxMsb] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyMsb] at hy

    have hxNeg : 0 ≤ x.val := by
      have := @BitVec.msb_eq_toInt _ x.bv
      simp_all
    have hyNeg : y.val < 0 := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all

    have : x.val.tmod y.val = x.val.tmod (-y.val) := by simp
    rw [this]; clear this

    rw [Int.tmod_eq_emod] <;> try omega
    simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod]

    have : ((x.bv.toNat % (-y.bv).toNat : Nat) : Int) < 2 ^ (ty.bitWidth - 1) := by
      have := @Nat.mod_le x.bv.toNat (-y.bv).toNat
      omega
    have : ((x.bv.toNat % (-y.bv).toNat : Nat) : Int).bmod (2 ^ ty.bitWidth) = x.bv.toNat % (-y.bv).toNat := by
      apply bmod_pow_bitWidth_eq_of_lt ty _ (by omega) (by omega)
    rw [this]; clear this
    simp only [hx]

    have := IScalar.neg_imp_toNat_neg_eq_neg_toInt y (by omega)
    simp only [this, val]

  . -- x < 0
    -- 0 ≤ y
    rename_i hxMsb hyMsb
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxMsb] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyMsb] at hy

    have hxNeg : x.val < 0 := by
      have := @BitVec.msb_eq_toInt _ x.bv
      simp_all
    have hyNeg : 0 ≤ y.val := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all

    have hModEq : ((-x.bv) % y.bv).toInt = ((-x.bv).toNat % y.bv.toNat : Nat) := by
      simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod]

      have : ((-x.bv).toNat % y.bv.toNat : Nat) < (2 ^ (ty.bitWidth - 1) : Int) := by
        have := @Nat.mod_lt (-x.bv).toNat y.bv.toNat (by omega)
        simp only [val] at *
        -- TODO: this is annoying
        have : (2 ^ (ty.bitWidth - 1) : Nat) = (2 ^ (ty.bitWidth - 1) : Int) := by simp
        omega

      have := @bmod_pow_bitWidth_eq_of_lt ty ((-x.bv).toNat % y.bv.toNat : Nat)
        (by omega) (by omega)
      rw [this]

    have : 0 ≤ (-x.bv % y.bv).toInt := by omega

    have := BitVec.toInt_neg_of_pos_eq_neg (-x.bv % y.bv) (by omega) (by omega)
    rw [this]; clear this

    have : (-x.bv % y.bv).toInt = (-x.bv).toNat % y.bv.toNat := by
      rw [hModEq]; simp
    rw [this]; clear this

    have : x.val.tmod y.val = - (-x.val).tmod y.val := by simp
    rw [this]; clear this

    have hx := IScalar.neg_imp_toNat_neg_eq_neg_toInt x (by omega)
    simp only [hx, ← hy]

    rw [Int.tmod_eq_emod] <;> try omega

    simp only [val]

  . -- x < 0
    -- y < 0

    rename_i hxMsb hyMsb
    have hx := @BitVec.toInt_eq_msb_cond _ x.bv
    simp [hxMsb] at hx
    have hy := @BitVec.toInt_eq_msb_cond _ y.bv
    simp [hyMsb] at hy

    have hxNeg : x.val < 0 := by
      have := @BitVec.msb_eq_toInt _ x.bv
      simp_all
    have hyNeg : y.val < 0 := by
      have := @BitVec.msb_eq_toInt _ y.bv
      simp_all

    have : (x.val).tmod (y.val) = -(-x.val).tmod (-y.val) := by simp
    rw [this]; clear this

    rw [Int.tmod_eq_emod] <;> try omega

    have hx := IScalar.neg_imp_toNat_neg_eq_neg_toInt x (by omega)
    have hy := IScalar.neg_imp_toNat_neg_eq_neg_toInt y (by omega)

    have : 0 ≤ -x.bv.toInt % -y.bv.toInt := by
      have h := Int.emod_of_pos_disj (-x.bv.toInt) (-y.bv.toInt)
      have : ¬ -y.bv.toInt ≤ 0 := by
        simp only [val] at *
        omega
      simp only [this, false_or] at h
      omega

    have : -2 ^ (ty.bitWidth - 1) ≤ -x.bv.toInt % -y.bv.toInt := by omega

    have hxmyToInt : (-x.bv % -y.bv).toInt = (-x.bv.toInt) % (-y.bv.toInt) := by
      conv => lhs; simp only [BitVec.toInt_eq_toNat_bmod, BitVec.toNat_umod]
      push_cast
      simp only [hx, hy]
      apply bmod_pow_bitWidth_eq_of_lt
      . omega
      . simp only [val] at *
        have := @Int.emod_lt_of_pos (-x.bv.toInt) (-y.bv.toInt) (by omega)
        omega

    have : 0 ≤ (-x.bv % -y.bv).toInt := by
      simp only [hxmyToInt]
      omega

    have := BitVec.toInt_neg_of_pos_eq_neg (-x.bv % -y.bv) (by omega) (by omega)
    rw [this]; clear this

    simp only [hxmyToInt]
    simp

theorem U8.rem_bv_spec (x : U8) {y : U8} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem U16.rem_bv_spec (x : U16) {y : U16} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem U32.rem_bv_spec (x : U32) {y : U32} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem U64.rem_bv_spec (x : U64) {y : U64} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem U128.rem_bv_spec (x : U128) {y : U128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem Usize.rem_bv_spec (x : Usize) {y : Usize} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y ∧ z.bv = x.bv % y.bv :=
  UScalar.rem_bv_spec x hnz

theorem I8.rem_bv_spec (x : I8) {y : I8} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

theorem I16.rem_bv_spec (x : I16) {y : I16} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

theorem I32.rem_bv_spec (x : I32) {y : I32} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

theorem I64.rem_bv_spec (x : I64) {y : I64} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

theorem I128.rem_bv_spec (x : I128) {y : I128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

theorem Isize.rem_bv_spec (x : I128) {y : I128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y ∧ z.bv = BitVec.srem x.bv y.bv :=
  IScalar.rem_bv_spec x hnz

/-!
Theorems with a specification which only uses integers
-/

/-- Generic theorem - shouldn't be used much -/
theorem UScalar.rem_spec {ty} (x : UScalar ty) {y : UScalar ty} (hzero : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y := by
  have ⟨ z, hz ⟩ := rem_bv_spec x hzero
  simp [hz]

/-- Generic theorem - shouldn't be used much -/
theorem IScalar.rem_spec {ty} (x : IScalar ty) {y : IScalar ty} (hzero : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y := by
  have ⟨ z, hz ⟩ := rem_bv_spec x hzero
  simp [hz]

@[progress] theorem U8.rem_spec (x : U8) {y : U8} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem U16.rem_spec (x : U16) {y : U16} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem U32.rem_spec (x : U32) {y : U32} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem U64.rem_spec (x : U64) {y : U64} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem U128.rem_spec (x : U128) {y : U128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem Usize.rem_spec (x : Usize) {y : Usize} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Nat) = ↑x % ↑y :=
  UScalar.rem_spec x hnz

@[progress] theorem I8.rem_spec (x : I8) {y : I8} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

@[progress] theorem I16.rem_spec (x : I16) {y : I16} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

@[progress] theorem I32.rem_spec (x : I32) {y : I32} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

@[progress] theorem I64.rem_spec (x : I64) {y : I64} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

@[progress] theorem I128.rem_spec (x : I128) {y : I128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

@[progress] theorem Isize.rem_spec (x : I128) {y : I128} (hnz : y.val ≠ 0) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = Int.tmod ↑x ↑y :=
  IScalar.rem_spec x hnz

/-!
## Casts
-/

@[simp]
theorem UScalar.cast_fromBool_val_eq ty (b : Bool) : (UScalar.cast_fromBool ty b).val = b.toNat := by
  simp [cast_fromBool]
  split <;> simp only [val, *] <;> simp
  have := ty.bitWidth_nonzero
  omega

@[simp]
theorem IScalar.cast_fromBool_val_eq ty (b : Bool) :(IScalar.cast_fromBool ty b).val = b.toInt := by
  simp [cast_fromBool]
  split <;> simp only [val, *] <;> simp
  dcases ty <;> simp
  have := System.Platform.numBits_eq
  cases this <;>
  rename_i h <;>
  rw [h] <;> simp

@[simp]
theorem UScalar.cast_fromBool_bv_eq ty (b : Bool) : (UScalar.cast_fromBool ty b).bv = (BitVec.ofBool b).zeroExtend _ := by
  simp [cast_fromBool, BitVec.setWidth_eq]
  dcases b <;> simp
  apply @BitVec.toNat_injective ty.bitWidth
  simp

@[simp]
theorem IScalar.cast_fromBool_bv_eq ty (b : Bool) :(IScalar.cast_fromBool ty b).bv = (BitVec.ofBool b).zeroExtend _ := by
  simp [cast_fromBool, BitVec.setWidth_eq]
  dcases b <;> simp
  apply @BitVec.toNat_injective ty.bitWidth
  simp

theorem UScalar.cast_val_eq {src_ty : UScalarTy} (tgt_ty : UScalarTy) (x : UScalar src_ty) :
  (cast tgt_ty x).val = x.val % 2^(tgt_ty.bitWidth) := by
  simp only [cast, val]
  simp

@[simp]
theorem UScalar.cast_val_mod_pow_greater_bitWidth_eq {src_ty : UScalarTy} (tgt_ty : UScalarTy) (x : UScalar src_ty) (h : src_ty.bitWidth ≤ tgt_ty.bitWidth) :
  (cast tgt_ty x).val = x.val := by
  simp [UScalar.cast_val_eq]
  have hBounds := x.hBounds
  simp [max_eq_smax, smax] at hBounds
  apply Nat.mod_eq_of_lt
  have : 0 < 2^src_ty.bitWidth := by simp
  have := @Nat.pow_le_pow_of_le_right 2 (by simp) src_ty.bitWidth tgt_ty.bitWidth (by omega)
  omega

@[simp]
theorem UScalar.cast_val_mod_pow_of_inBounds_eq {src_ty : UScalarTy} (tgt_ty : UScalarTy) (x : UScalar src_ty) (h : x.val < 2^tgt_ty.bitWidth) :
  (cast tgt_ty x).val = x.val := by
  simp [UScalar.cast_val_eq]
  apply Nat.mod_eq_of_lt
  assumption

@[simp]
theorem UScalar.cast_bv_eq {src_ty : UScalarTy} (tgt_ty : UScalarTy) (x : UScalar src_ty) :
  (cast tgt_ty x).bv = x.bv.setWidth tgt_ty.bitWidth := by
  simp [UScalar.cast]

example (x : U16) : (x.cast .U32).val = x.val := by simp
example : ((U32.ofNat 42).cast .U16).val = 42 := by simp

theorem IScalar.cast_val_eq {src_ty : IScalarTy} (tgt_ty : IScalarTy) (x : IScalar src_ty) :
  (cast tgt_ty x).val = Int.bmod x.val (2^(Min.min tgt_ty.bitWidth src_ty.bitWidth)) := by
  simp only [cast, val]
  simp only [BitVec.toInt_signExtend, val]
  rw [BitVec.toInt_eq_toNat_bmod]
  rw [Int.bmod_bmod_of_dvd]
  apply Nat.pow_dvd_pow
  simp

@[simp]
theorem IScalar.val_mod_pow_greater_bitWidth {src_ty : IScalarTy} (tgt_ty : IScalarTy) (x : IScalar src_ty) (h : src_ty.bitWidth ≤ tgt_ty.bitWidth) :
  (cast tgt_ty x).val = x.val := by
  simp [IScalar.cast_val_eq]
  have hBounds := x.hBounds
  simp [bound_eq_sbound, smin, smax] at hBounds
  simp [h]
  have := src_ty.bitWidth_nonzero
  have : src_ty.bitWidth = src_ty.bitWidth - 1 + 1 := by omega
  rw [this]
  apply Int.bmod_pow2_eq_of_inBounds <;> omega

@[simp]
theorem IScalar.val_mod_pow_inBounds {src_ty : IScalarTy} (tgt_ty : IScalarTy) (x : IScalar src_ty)
  (hMin : -2^(tgt_ty.bitWidth - 1) ≤ x.val) (hMax : x.val < 2^(tgt_ty.bitWidth - 1)) :
  (cast tgt_ty x).val = x.val := by
  simp [IScalar.cast_val_eq]
  have hBounds := x.hBounds
  simp [bound_eq_sbound, smin, smax] at hBounds
  have := src_ty.bitWidth_nonzero
  have := tgt_ty.bitWidth_nonzero
  have : tgt_ty.bitWidth ⊓ src_ty.bitWidth = tgt_ty.bitWidth ⊓ src_ty.bitWidth - 1 + 1 := by omega
  rw [this]
  have : -2 ^ (tgt_ty.bitWidth ⊓ src_ty.bitWidth - 1) ≤ x.val ∧
         x.val < 2 ^ (tgt_ty.bitWidth ⊓ src_ty.bitWidth - 1) := by
    have : tgt_ty.bitWidth ⊓ src_ty.bitWidth = tgt_ty.bitWidth ∨ tgt_ty.bitWidth ⊓ src_ty.bitWidth = src_ty.bitWidth := by
      rw [Nat.min_def]
      split <;> simp
    cases this <;> rename_i hEq <;> simp [hEq] <;> omega
  apply Int.bmod_pow2_eq_of_inBounds <;> omega


/-!
# Checked Operations
## Checked Operations: Definitions
-/

/-!
### Checked Addition
-/

/- [core::num::{T}::checked_add] -/
def core.num.checked_add_UScalar {ty} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (x + y)

def U8.checked_add (x y : U8) : Option U8 := core.num.checked_add_UScalar x y
def U16.checked_add (x y : U16) : Option U16 := core.num.checked_add_UScalar x y
def U32.checked_add (x y : U32) : Option U32 := core.num.checked_add_UScalar x y
def U64.checked_add (x y : U64) : Option U64 := core.num.checked_add_UScalar x y
def U128.checked_add (x y : U128) : Option U128 := core.num.checked_add_UScalar x y
def Usize.checked_add (x y : Usize) : Option Usize := core.num.checked_add_UScalar x y

/- [core::num::{T}::checked_add] -/
def core.num.checked_add_IScalar {ty} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (x + y)

def I8.checked_add (x y : I8) : Option I8 := core.num.checked_add_IScalar x y
def I16.checked_add (x y : I16) : Option I16 := core.num.checked_add_IScalar x y
def I32.checked_add (x y : I32) : Option I32 := core.num.checked_add_IScalar x y
def I64.checked_add (x y : I64) : Option I64 := core.num.checked_add_IScalar x y
def I128.checked_add (x y : I128) : Option I128 := core.num.checked_add_IScalar x y
def Isize.checked_add (x y : Isize) : Option Isize := core.num.checked_add_IScalar x y

/-!
### Checked Subtraction
-/

/- [core::num::{T}::checked_sub] -/
def core.num.checked_sub_UScalar {ty} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (x - y)

def U8.checked_sub (x y : U8) : Option U8 := core.num.checked_sub_UScalar x y
def U16.checked_sub (x y : U16) : Option U16 := core.num.checked_sub_UScalar x y
def U32.checked_sub (x y : U32) : Option U32 := core.num.checked_sub_UScalar x y
def U64.checked_sub (x y : U64) : Option U64 := core.num.checked_sub_UScalar x y
def U128.checked_sub (x y : U128) : Option U128 := core.num.checked_sub_UScalar x y
def Usize.checked_sub (x y : Usize) : Option Usize := core.num.checked_sub_UScalar x y

/- [core::num::{T}::checked_sub] -/
def core.num.checked_sub_IScalar {ty} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (x - y)

def I8.checked_sub (x y : I8) : Option I8 := core.num.checked_sub_IScalar x y
def I16.checked_sub (x y : I16) : Option I16 := core.num.checked_sub_IScalar x y
def I32.checked_sub (x y : I32) : Option I32 := core.num.checked_sub_IScalar x y
def I64.checked_sub (x y : I64) : Option I64 := core.num.checked_sub_IScalar x y
def I128.checked_sub (x y : I128) : Option I128 := core.num.checked_sub_IScalar x y
def Isize.checked_sub (x y : Isize) : Option Isize := core.num.checked_sub_IScalar x y

/-!
### Checked Multiplication
-/

/- [core::num::{T}::checked_mul] -/
def core.num.checked_mul_UScalar {ty} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (UScalar.mul x y)

def U8.checked_mul (x y : U8) : Option U8 := core.num.checked_mul_UScalar x y
def U16.checked_mul (x y : U16) : Option U16 := core.num.checked_mul_UScalar x y
def U32.checked_mul (x y : U32) : Option U32 := core.num.checked_mul_UScalar x y
def U64.checked_mul (x y : U64) : Option U64 := core.num.checked_mul_UScalar x y
def U128.checked_mul (x y : U128) : Option U128 := core.num.checked_mul_UScalar x y
def Usize.checked_mul (x y : Usize) : Option Usize := core.num.checked_mul_UScalar x y

/- [core::num::{T}::checked_mul] -/
def core.num.checked_mul_IScalar {ty} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (IScalar.mul x y)

def I8.checked_mul (x y : I8) : Option I8 := core.num.checked_mul_IScalar x y
def I16.checked_mul (x y : I16) : Option I16 := core.num.checked_mul_IScalar x y
def I32.checked_mul (x y : I32) : Option I32 := core.num.checked_mul_IScalar x y
def I64.checked_mul (x y : I64) : Option I64 := core.num.checked_mul_IScalar x y
def I128.checked_mul (x y : I128) : Option I128 := core.num.checked_mul_IScalar x y
def Isize.checked_mul (x y : Isize) : Option Isize := core.num.checked_mul_IScalar x y

/-!
### Checked Division
-/

/- [core::num::{T}::checked_div] -/
def core.num.checked_div_UScalar {ty} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (UScalar.div x y)

def U8.checked_div (x y : U8) : Option U8 := core.num.checked_div_UScalar x y
def U16.checked_div (x y : U16) : Option U16 := core.num.checked_div_UScalar x y
def U32.checked_div (x y : U32) : Option U32 := core.num.checked_div_UScalar x y
def U64.checked_div (x y : U64) : Option U64 := core.num.checked_div_UScalar x y
def U128.checked_div (x y : U128) : Option U128 := core.num.checked_div_UScalar x y
def Usize.checked_div (x y : Usize) : Option Usize := core.num.checked_div_UScalar x y

/- [core::num::{T}::checked_div] -/
def core.num.checked_div_IScalar {ty} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (IScalar.div x y)

def I8.checked_div (x y : I8) : Option I8 := core.num.checked_div_IScalar x y
def I16.checked_div (x y : I16) : Option I16 := core.num.checked_div_IScalar x y
def I32.checked_div (x y : I32) : Option I32 := core.num.checked_div_IScalar x y
def I64.checked_div (x y : I64) : Option I64 := core.num.checked_div_IScalar x y
def I128.checked_div (x y : I128) : Option I128 := core.num.checked_div_IScalar x y
def Isize.checked_div (x y : Isize) : Option Isize := core.num.checked_div_IScalar x y

/-!
### Checked Remainder
-/

/- [core::num::{T}::checked_rem] -/
def core.num.checked_rem_UScalar {ty} (x y : UScalar ty) : Option (UScalar ty) :=
  Option.ofResult (UScalar.rem x y)

def U8.checked_rem (x y : U8) : Option U8 := core.num.checked_rem_UScalar x y
def U16.checked_rem (x y : U16) : Option U16 := core.num.checked_rem_UScalar x y
def U32.checked_rem (x y : U32) : Option U32 := core.num.checked_rem_UScalar x y
def U64.checked_rem (x y : U64) : Option U64 := core.num.checked_rem_UScalar x y
def U128.checked_rem (x y : U128) : Option U128 := core.num.checked_rem_UScalar x y
def Usize.checked_rem (x y : Usize) : Option Usize := core.num.checked_rem_UScalar x y

/- [core::num::{T}::checked_rem] -/
def core.num.checked_rem_IScalar {ty} (x y : IScalar ty) : Option (IScalar ty) :=
  Option.ofResult (IScalar.rem x y)

def I8.checked_rem (x y : I8) : Option I8 := core.num.checked_rem_IScalar x y
def I16.checked_rem (x y : I16) : Option I16 := core.num.checked_rem_IScalar x y
def I32.checked_rem (x y : I32) : Option I32 := core.num.checked_rem_IScalar x y
def I64.checked_rem (x y : I64) : Option I64 := core.num.checked_rem_IScalar x y
def I128.checked_rem (x y : I128) : Option I128 := core.num.checked_rem_IScalar x y
def Isize.checked_rem (x y : Isize) : Option Isize := core.num.checked_rem_IScalar x y

/-!
## Checked Operations: Theorems
-/

/-!
### Checked Add
-/

/-!
Unsigned checked add
-/
theorem core.num.checked_add_UScalar_bv_spec {ty} (x y : UScalar ty) :
  match core.num.checked_add_UScalar x y with
  | some z => x.val + y.val ≤ UScalar.max ty ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => UScalar.max ty < x.val + y.val := by
  have h := UScalar.add_equiv x y
  have hAdd : x + y = UScalar.add x y := by rfl
  rw [hAdd] at h
  dcases hEq : UScalar.add x y <;> simp_all [Option.ofResult, checked_add_UScalar]

theorem U8.checked_add_bv_spec (x y : U8) :
  match U8.checked_add x y with
  | some z => x.val + y.val ≤ U8.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => U8.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [U8.checked_add, UScalar.max, U8.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

theorem U16.checked_add_bv_spec (x y : U16) :
  match U16.checked_add x y with
  | some z => x.val + y.val ≤ U16.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => U16.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [U16.checked_add, UScalar.max, U16.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

theorem U32.checked_add_bv_spec (x y : U32) :
  match U32.checked_add x y with
  | some z => x.val + y.val ≤ U32.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => U32.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [U32.checked_add, UScalar.max, U32.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

theorem U64.checked_add_bv_spec (x y : U64) :
  match U64.checked_add x y with
  | some z => x.val + y.val ≤ U64.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => U64.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [U64.checked_add, UScalar.max, U64.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

theorem U128.checked_add_bv_spec (x y : U128) :
  match U128.checked_add x y with
  | some z => x.val + y.val ≤ U128.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => U128.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [U128.checked_add, UScalar.max, U128.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

theorem Usize.checked_add_bv_spec (x y : Usize) :
  match Usize.checked_add x y with
  | some z => x.val + y.val ≤ Usize.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => Usize.max < x.val + y.val := by
  have := core.num.checked_add_UScalar_bv_spec x y
  simp_all [Usize.checked_add, UScalar.max, Usize.bv]
  cases h: core.num.checked_add_UScalar x y <;> simp_all

/-!
Signed checked add
-/
theorem core.num.checked_add_IScalar_bv_spec {ty} (x y : IScalar ty) :
  match core.num.checked_add_IScalar x y with
  | some z => IScalar.min ty ≤ x.val + y.val ∧ x.val + y.val ≤ IScalar.max ty ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (IScalar.min ty ≤ x.val + y.val ∧ x.val + y.val ≤ IScalar.max ty) := by
  have h := IScalar.add_equiv x y
  have hAdd : x + y = IScalar.add x y := by rfl
  rw [hAdd] at h
  dcases hEq : IScalar.add x y <;> simp_all [Option.ofResult, checked_add_IScalar]

theorem I8.checked_add_bv_spec (x y : I8) :
  match core.num.checked_add_IScalar x y with
  | some z => I8.min ≤ x.val + y.val ∧ x.val + y.val ≤ I8.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (I8.min ≤ x.val + y.val ∧ x.val + y.val ≤ I8.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [I8.checked_add, IScalar.min, IScalar.max, I8.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

theorem I16.checked_add_bv_spec (x y : I16) :
  match core.num.checked_add_IScalar x y with
  | some z => I16.min ≤ x.val + y.val ∧ x.val + y.val ≤ I16.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (I16.min ≤ x.val + y.val ∧ x.val + y.val ≤ I16.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [I16.checked_add, IScalar.min, IScalar.max, I16.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

theorem I32.checked_add_bv_spec (x y : I32) :
  match core.num.checked_add_IScalar x y with
  | some z => I32.min ≤ x.val + y.val ∧ x.val + y.val ≤ I32.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (I32.min ≤ x.val + y.val ∧ x.val + y.val ≤ I32.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [I32.checked_add, IScalar.min, IScalar.max, I32.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

theorem I64.checked_add_bv_spec (x y : I64) :
  match core.num.checked_add_IScalar x y with
  | some z => I64.min ≤ x.val + y.val ∧ x.val + y.val ≤ I64.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (I64.min ≤ x.val + y.val ∧ x.val + y.val ≤ I64.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [I64.checked_add, IScalar.min, IScalar.max, I64.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

theorem I128.checked_add_bv_spec (x y : I128) :
  match core.num.checked_add_IScalar x y with
  | some z => I128.min ≤ x.val + y.val ∧ x.val + y.val ≤ I128.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (I128.min ≤ x.val + y.val ∧ x.val + y.val ≤ I128.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [I128.checked_add, IScalar.min, IScalar.max, I128.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

theorem Isize.checked_add_bv_spec (x y : Isize) :
  match core.num.checked_add_IScalar x y with
  | some z => Isize.min ≤ x.val + y.val ∧ x.val + y.val ≤ Isize.max ∧ z.val = x.val + y.val ∧ z.bv = x.bv + y.bv
  | none => ¬ (Isize.min ≤ x.val + y.val ∧ x.val + y.val ≤ Isize.max) := by
  have := core.num.checked_add_IScalar_bv_spec x y
  simp_all [Isize.checked_add, IScalar.min, IScalar.max, Isize.bv]
  cases h: core.num.checked_add_IScalar x y <;> simp_all

/-!
### Checked Sub
-/

/-!
Unsigned checked sub
-/
theorem core.num.checked_sub_UScalar_bv_spec {ty} (x y : UScalar ty) :
  match core.num.checked_sub_UScalar x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have h := UScalar.sub_equiv x y
  have hsub : x - y = UScalar.sub x y := by rfl
  rw [hsub] at h
  dcases hEq : UScalar.sub x y <;> simp_all [Option.ofResult, checked_sub_UScalar]

theorem U8.checked_sub_bv_spec (x y : U8) :
  match U8.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [U8.checked_sub, UScalar.max, U8.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

theorem U16.checked_sub_bv_spec (x y : U16) :
  match U16.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [U16.checked_sub, UScalar.max, U16.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

theorem U32.checked_sub_bv_spec (x y : U32) :
  match U32.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [U32.checked_sub, UScalar.max, U32.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

theorem U64.checked_sub_bv_spec (x y : U64) :
  match U64.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [U64.checked_sub, UScalar.max, U64.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

theorem U128.checked_sub_bv_spec (x y : U128) :
  match U128.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [U128.checked_sub, UScalar.max, U128.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

theorem Usize.checked_sub_bv_spec (x y : Usize) :
  match Usize.checked_sub x y with
  | some z => y.val ≤ x.val ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => x.val < y.val := by
  have := core.num.checked_sub_UScalar_bv_spec x y
  simp_all [Usize.checked_sub, UScalar.max, Usize.bv]
  cases h: core.num.checked_sub_UScalar x y <;> simp_all

/-!
Signed checked sub
-/
theorem core.num.checked_sub_IScalar_bv_spec {ty} (x y : IScalar ty) :
  match core.num.checked_sub_IScalar x y with
  | some z => IScalar.min ty ≤ x.val - y.val ∧ x.val - y.val ≤ IScalar.max ty ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (IScalar.min ty ≤ x.val - y.val ∧ x.val - y.val ≤ IScalar.max ty) := by
  have h := IScalar.sub_equiv x y
  have hsub : x - y = IScalar.sub x y := by rfl
  rw [hsub] at h
  dcases hEq : IScalar.sub x y <;> simp_all [Option.ofResult, checked_sub_IScalar]

theorem I8.checked_sub_bv_spec (x y : I8) :
  match core.num.checked_sub_IScalar x y with
  | some z => I8.min ≤ x.val - y.val ∧ x.val - y.val ≤ I8.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (I8.min ≤ x.val - y.val ∧ x.val - y.val ≤ I8.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [I8.checked_sub, IScalar.min, IScalar.max, I8.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

theorem I16.checked_sub_bv_spec (x y : I16) :
  match core.num.checked_sub_IScalar x y with
  | some z => I16.min ≤ x.val - y.val ∧ x.val - y.val ≤ I16.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (I16.min ≤ x.val - y.val ∧ x.val - y.val ≤ I16.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [I16.checked_sub, IScalar.min, IScalar.max, I16.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

theorem I32.checked_sub_bv_spec (x y : I32) :
  match core.num.checked_sub_IScalar x y with
  | some z => I32.min ≤ x.val - y.val ∧ x.val - y.val ≤ I32.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (I32.min ≤ x.val - y.val ∧ x.val - y.val ≤ I32.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [I32.checked_sub, IScalar.min, IScalar.max, I32.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

theorem I64.checked_sub_bv_spec (x y : I64) :
  match core.num.checked_sub_IScalar x y with
  | some z => I64.min ≤ x.val - y.val ∧ x.val - y.val ≤ I64.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (I64.min ≤ x.val - y.val ∧ x.val - y.val ≤ I64.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [I64.checked_sub, IScalar.min, IScalar.max, I64.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

theorem I128.checked_sub_bv_spec (x y : I128) :
  match core.num.checked_sub_IScalar x y with
  | some z => I128.min ≤ x.val - y.val ∧ x.val - y.val ≤ I128.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (I128.min ≤ x.val - y.val ∧ x.val - y.val ≤ I128.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [I128.checked_sub, IScalar.min, IScalar.max, I128.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

theorem Isize.checked_sub_bv_spec (x y : Isize) :
  match core.num.checked_sub_IScalar x y with
  | some z => Isize.min ≤ x.val - y.val ∧ x.val - y.val ≤ Isize.max ∧ z.val = x.val - y.val ∧ z.bv = x.bv - y.bv
  | none => ¬ (Isize.min ≤ x.val - y.val ∧ x.val - y.val ≤ Isize.max) := by
  have := core.num.checked_sub_IScalar_bv_spec x y
  simp_all [Isize.checked_sub, IScalar.min, IScalar.max, Isize.bv]
  cases h: core.num.checked_sub_IScalar x y <;> simp_all

/-!
### Checked Mul
-/

/-!
Unsigned checked mul
-/
theorem core.num.checked_mul_UScalar_bv_spec {ty} (x y : UScalar ty) :
  match core.num.checked_mul_UScalar x y with
  | some z => x.val * y.val ≤ UScalar.max ty ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => UScalar.max ty < x.val * y.val := by
  have h := UScalar.mul_equiv x y
  simp [checked_mul_UScalar]
  dcases hEq : UScalar.mul x y <;> simp_all [Option.ofResult]

theorem U8.checked_mul_bv_spec (x y : U8) :
  match U8.checked_mul x y with
  | some z => x.val * y.val ≤ U8.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => U8.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [U8.checked_mul, UScalar.max, U8.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

theorem U16.checked_mul_bv_spec (x y : U16) :
  match U16.checked_mul x y with
  | some z => x.val * y.val ≤ U16.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => U16.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [U16.checked_mul, UScalar.max, U16.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

theorem U32.checked_mul_bv_spec (x y : U32) :
  match U32.checked_mul x y with
  | some z => x.val * y.val ≤ U32.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => U32.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [U32.checked_mul, UScalar.max, U32.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

theorem U64.checked_mul_bv_spec (x y : U64) :
  match U64.checked_mul x y with
  | some z => x.val * y.val ≤ U64.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => U64.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [U64.checked_mul, UScalar.max, U64.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

theorem U128.checked_mul_bv_spec (x y : U128) :
  match U128.checked_mul x y with
  | some z => x.val * y.val ≤ U128.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => U128.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [U128.checked_mul, UScalar.max, U128.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

theorem Usize.checked_mul_bv_spec (x y : Usize) :
  match Usize.checked_mul x y with
  | some z => x.val * y.val ≤ Usize.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => Usize.max < x.val * y.val := by
  have := core.num.checked_mul_UScalar_bv_spec x y
  simp_all [Usize.checked_mul, UScalar.max, Usize.bv]
  cases h: core.num.checked_mul_UScalar x y <;> simp_all

/-!
Signed checked mul
-/
theorem core.num.checked_mul_IScalar_bv_spec {ty} (x y : IScalar ty) :
  match core.num.checked_mul_IScalar x y with
  | some z => IScalar.min ty ≤ x.val * y.val ∧ x.val * y.val ≤ IScalar.max ty ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (IScalar.min ty ≤ x.val * y.val ∧ x.val * y.val ≤ IScalar.max ty) := by
  have h := IScalar.mul_equiv x y
  simp [checked_mul_IScalar]
  dcases hEq : IScalar.mul x y <;> simp_all [Option.ofResult]

theorem I8.checked_mul_bv_spec (x y : I8) :
  match core.num.checked_mul_IScalar x y with
  | some z => I8.min ≤ x.val * y.val ∧ x.val * y.val ≤ I8.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (I8.min ≤ x.val * y.val ∧ x.val * y.val ≤ I8.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [I8.checked_mul, IScalar.min, IScalar.max, I8.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

theorem I16.checked_mul_bv_spec (x y : I16) :
  match core.num.checked_mul_IScalar x y with
  | some z => I16.min ≤ x.val * y.val ∧ x.val * y.val ≤ I16.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (I16.min ≤ x.val * y.val ∧ x.val * y.val ≤ I16.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [I16.checked_mul, IScalar.min, IScalar.max, I16.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

theorem I32.checked_mul_bv_spec (x y : I32) :
  match core.num.checked_mul_IScalar x y with
  | some z => I32.min ≤ x.val * y.val ∧ x.val * y.val ≤ I32.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (I32.min ≤ x.val * y.val ∧ x.val * y.val ≤ I32.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [I32.checked_mul, IScalar.min, IScalar.max, I32.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

theorem I64.checked_mul_bv_spec (x y : I64) :
  match core.num.checked_mul_IScalar x y with
  | some z => I64.min ≤ x.val * y.val ∧ x.val * y.val ≤ I64.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (I64.min ≤ x.val * y.val ∧ x.val * y.val ≤ I64.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [I64.checked_mul, IScalar.min, IScalar.max, I64.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

theorem I128.checked_mul_bv_spec (x y : I128) :
  match core.num.checked_mul_IScalar x y with
  | some z => I128.min ≤ x.val * y.val ∧ x.val * y.val ≤ I128.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (I128.min ≤ x.val * y.val ∧ x.val * y.val ≤ I128.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [I128.checked_mul, IScalar.min, IScalar.max, I128.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

theorem Isize.checked_mul_bv_spec (x y : Isize) :
  match core.num.checked_mul_IScalar x y with
  | some z => Isize.min ≤ x.val * y.val ∧ x.val * y.val ≤ Isize.max ∧ z.val = x.val * y.val ∧ z.bv = x.bv * y.bv
  | none => ¬ (Isize.min ≤ x.val * y.val ∧ x.val * y.val ≤ Isize.max) := by
  have := core.num.checked_mul_IScalar_bv_spec x y
  simp_all [Isize.checked_mul, IScalar.min, IScalar.max, Isize.bv]
  cases h: core.num.checked_mul_IScalar x y <;> simp_all

/-!
### Checked Division
-/

/-!
Unsigned checked div
-/
theorem core.num.checked_div_UScalar_bv_spec {ty} (x y : UScalar ty) :
  match core.num.checked_div_UScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  simp [checked_div_UScalar, Option.ofResult, UScalar.div]
  split_ifs
  . zify at *
    simp_all
  . rename_i hnz
    simp
    have hnz' : y.val ≠ 0 := by zify at *; simp_all
    have ⟨ z, hz ⟩ := UScalar.div_bv_spec x hnz'
    have : x / y = x.div y := by rfl
    simp [this, UScalar.div, hnz] at hz
    simp [hz, hnz']

theorem U8.checked_div_bv_spec (x y : U8) :
  match U8.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [U8.checked_div, UScalar.max, U8.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

theorem U16.checked_div_bv_spec (x y : U16) :
  match U16.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [U16.checked_div, UScalar.max, U16.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

theorem U32.checked_div_bv_spec (x y : U32) :
  match U32.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [U32.checked_div, UScalar.max, U32.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

theorem U64.checked_div_bv_spec (x y : U64) :
  match U64.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [U64.checked_div, UScalar.max, U64.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

theorem U128.checked_div_bv_spec (x y : U128) :
  match U128.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [U128.checked_div, UScalar.max, U128.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

theorem Usize.checked_div_bv_spec (x y : Usize) :
  match Usize.checked_div x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val / y.val ∧ z.bv = x.bv / y.bv
  | none => y.val = 0 := by
  have := core.num.checked_div_UScalar_bv_spec x y
  simp_all [Usize.checked_div, UScalar.max, Usize.bv]
  cases h: core.num.checked_div_UScalar x y <;> simp_all

/-!
Signed checked div
-/
theorem core.num.checked_div_IScalar_bv_spec {ty} (x y : IScalar ty) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = IScalar.min ty ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = IScalar.min ty ∧ y.val = -1) := by
  simp [checked_div_IScalar, Option.ofResult, IScalar.div]
  split_ifs
  . zify at *
    simp_all
  . rename_i hnz hNoOverflow
    simp
    have hnz' : y.val ≠ 0 := by zify at *; simp_all
    have ⟨ z, hz ⟩ := @IScalar.div_bv_spec _ x y hnz' (by simp; tauto)
    have : x / y = x.div y := by rfl
    simp [this, IScalar.div, hnz, hNoOverflow] at hz
    split_ifs at hz
    simp at hz
    simp [hz, hnz']
    tauto
  . simp_all

theorem I8.checked_div_bv_spec (x y : I8) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = I8.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = I8.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [I8.checked_div, I8.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

theorem I16.checked_div_bv_spec (x y : I16) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = I16.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = I16.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [I16.checked_div, I16.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

theorem I32.checked_div_bv_spec (x y : I32) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = I32.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = I32.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [I32.checked_div, I32.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

theorem I64.checked_div_bv_spec (x y : I64) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = I64.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = I64.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [I64.checked_div, I64.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

theorem I128.checked_div_bv_spec (x y : I128) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = I128.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = I128.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [I128.checked_div, I128.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

theorem Isize.checked_div_bv_spec (x y : Isize) :
  match core.num.checked_div_IScalar x y with
  | some z => y.val ≠ 0 ∧ ¬ (x.val = Isize.min ∧ y.val = -1) ∧ z.val = Int.tdiv x.val y.val ∧ z.bv = BitVec.sdiv x.bv y.bv
  | none => y.val = 0 ∨ (x.val = Isize.min ∧ y.val = -1) := by
  have := core.num.checked_div_IScalar_bv_spec x y
  simp_all only [Isize.checked_div, Isize.bv, IScalar.min]
  cases h: core.num.checked_div_IScalar x y <;> simp_all

/-!
### Checked Division
-/

/-!
Unsigned checked div
-/
theorem core.num.checked_rem_UScalar_bv_spec {ty} (x y : UScalar ty) :
  match core.num.checked_rem_UScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  simp [checked_rem_UScalar, Option.ofResult, UScalar.rem]
  split_ifs
  . zify at *
    simp_all
  . rename_i hnz
    simp
    have hnz' : y.val ≠ 0 := by zify at *; simp_all
    have ⟨ z, hz ⟩ := UScalar.rem_bv_spec x hnz'
    have : x % y = x.rem y := by rfl
    simp [this, UScalar.rem, hnz] at hz
    simp [hz, hnz']

theorem U8.checked_rem_bv_spec (x y : U8) :
  match U8.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [U8.checked_rem, UScalar.max, U8.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

theorem U16.checked_rem_bv_spec (x y : U16) :
  match U16.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [U16.checked_rem, UScalar.max, U16.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

theorem U32.checked_rem_bv_spec (x y : U32) :
  match U32.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [U32.checked_rem, UScalar.max, U32.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

theorem U64.checked_rem_bv_spec (x y : U64) :
  match U64.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [U64.checked_rem, UScalar.max, U64.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

theorem U128.checked_rem_bv_spec (x y : U128) :
  match U128.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [U128.checked_rem, UScalar.max, U128.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

theorem Usize.checked_rem_bv_spec (x y : Usize) :
  match Usize.checked_rem x y with
  | some z => y.val ≠ 0 ∧ z.val = x.val % y.val ∧ z.bv = x.bv % y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_UScalar_bv_spec x y
  simp_all [Usize.checked_rem, UScalar.max, Usize.bv]
  cases h: core.num.checked_rem_UScalar x y <;> simp_all

/-!
Signed checked rem
-/
theorem core.num.checked_rem_IScalar_bv_spec {ty} (x y : IScalar ty) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  simp [checked_rem_IScalar, Option.ofResult, IScalar.rem]
  split_ifs
  . zify at *
    simp_all
  . rename_i hnz
    simp
    have hnz' : y.val ≠ 0 := by zify at *; simp_all
    have ⟨ z, hz ⟩ := @IScalar.rem_bv_spec _ x y hnz'
    have : x % y = x.rem y := by rfl
    simp [this, IScalar.rem, hnz] at hz
    simp [*]

theorem I8.checked_rem_bv_spec (x y : I8) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [I8.checked_rem, I8.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all

theorem I16.checked_rem_bv_spec (x y : I16) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [I16.checked_rem, I16.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all

theorem I32.checked_rem_bv_spec (x y : I32) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [I32.checked_rem, I32.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all

theorem I64.checked_rem_bv_spec (x y : I64) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [I64.checked_rem, I64.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all

theorem I128.checked_rem_bv_spec (x y : I128) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [I128.checked_rem, I128.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all

theorem Isize.checked_rem_bv_spec (x y : Isize) :
  match core.num.checked_rem_IScalar x y with
  | some z => y.val ≠ 0 ∧ z.val = Int.tmod x.val y.val ∧ z.bv = BitVec.srem x.bv y.bv
  | none => y.val = 0 := by
  have := core.num.checked_rem_IScalar_bv_spec x y
  simp_all only [Isize.checked_rem, Isize.bv, IScalar.min]
  cases h: core.num.checked_rem_IScalar x y <;> simp_all












-- core checked arithmetic operations


theorem core.num.checked_sub_spec {ty} {x y : Scalar ty} :
  match core.num.checked_sub x y with
  | some z => Scalar.in_bounds ty (↑x - ↑y) ∧ ↑z = (↑x - ↑y : Int)
  | none => ¬ (Scalar.in_bounds ty (↑x - ↑y)) := by
  have h := Scalar.tryMk_eq ty (↑x - ↑y)
  simp only [checked_sub, Option.ofResult]
  have add_neg_eq : x.val + (-y.val) = x.val - y.val := by omega -- TODO: why do we need this??
  cases heq: x - y <;> simp_all <;> simp only [HSub.hSub, Scalar.sub, Sub.sub, Int.sub] at heq
  <;> simp_all


theorem core.num.checked_mul_spec {ty} {x y : Scalar ty} :
  match core.num.checked_mul x y with
  | some z => Scalar.in_bounds ty (↑x * ↑y) ∧ ↑z = (↑x * ↑y : Int)
  | none => ¬ (Scalar.in_bounds ty (↑x * ↑y)) := by
  have h := Scalar.tryMk_eq ty (↑x * ↑y)
  simp only [checked_mul, Option.ofResult]
  have : Int.mul ↑x ↑y = ↑x * ↑y := by simp -- TODO: why do we need this??
  cases heq: x * y <;> simp_all <;> simp only [HMul.hMul, Scalar.mul, Mul.mul] at heq
  <;> simp_all

theorem Scalar.div_equiv {ty} {x y : Scalar ty} :
  match x / y with
  | ok z => y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_div ↑x ↑y) ∧ (↑z : Int) = scalar_div ↑x ↑y
  | fail _ => ¬ (y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_div ↑x ↑y))
  | _ => ⊥ := by
  -- Applying the unfoldings only inside the match
  conv in _ / _ => unfold HDiv.hDiv instHDivScalarResult; simp [div]
  have h := tryMk_eq ty (scalar_div ↑x ↑y)
  simp [in_bounds] at h
  split_ifs <;> simp <;>
  split at h <;> simp_all [check_bounds_eq_in_bounds]

-- Generic theorem - shouldn't be used much
@[progress]
theorem Scalar.div_spec {ty} {x y : Scalar ty}
  (hnz : ↑y ≠ (0 : Int))
  (hmin : Scalar.min ty ≤ scalar_div ↑x ↑y)
  (hmax : scalar_div ↑x ↑y ≤ Scalar.max ty) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = scalar_div ↑x ↑y := by
  simp [HDiv.hDiv, div, Div.div]
  simp [tryMk, tryMkOpt, ofOption, *]

theorem Scalar.div_unsigned_spec {ty} (s: ¬ ty.isSigned) (x : Scalar ty) {y : Scalar ty}
  (hnz : ↑y ≠ (0 : Int)) :
  ∃ z, x / y = ok z ∧ (↑z : Int) = ↑x / ↑y := by
  have h : Scalar.min ty = 0 := by cases ty <;> simp [ScalarTy.isSigned, min] at *
  have hx := x.hmin
  have hy := y.hmin
  simp [h] at hx hy
  have hmin : 0 ≤ x.val / y.val := Int.ediv_nonneg hx hy
  have hmax : ↑x / ↑y ≤ Scalar.max ty := by
    have := Int.ediv_le_self ↑y hx
    have := x.hmax
    omega
  have hs := @div_spec ty x y hnz
  simp [*] at hs
  apply hs

/- Fine-grained theorems -/


theorem core.num.checked_div_spec {ty} {x y : Scalar ty} :
  match core.num.checked_div x y with
  | some z => y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_div ↑x ↑y) ∧ ↑z = (scalar_div ↑x ↑y : Int)
  | none => ¬ (y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_div ↑x ↑y)) := by
  have h := Scalar.tryMk_eq ty (scalar_div ↑x ↑y)
  simp only [checked_div, Option.ofResult]
  cases heq0: (y.val = 0 : Bool) <;>
  cases heq1: x / y <;> simp_all <;> simp only [HDiv.hDiv, Scalar.div, Div.div] at heq1
  <;> simp_all

theorem Scalar.rem_equiv {ty} {x y : Scalar ty} :
  match x % y with
  | ok z => y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_rem ↑x ↑y) ∧ (↑z : Int) = scalar_rem ↑x ↑y
  | fail _ => ¬ (y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_rem ↑x ↑y))
  | _ => ⊥ := by
  -- Applying the unfoldings only inside the match
  conv in _ % _ => unfold HMod.hMod instHModScalarResult; simp [rem]
  have h := tryMk_eq ty (scalar_rem ↑x ↑y)
  simp [in_bounds] at h
  split_ifs <;> simp <;>
  split at h <;> simp_all [check_bounds_eq_in_bounds]

-- Generic theorem - shouldn't be used much
@[progress]
theorem Scalar.rem_spec {ty} {x y : Scalar ty}
  (hnz : ↑y ≠ (0 : Int))
  (hmin : Scalar.min ty ≤ scalar_rem ↑x ↑y)
  (hmax : scalar_rem ↑x ↑y ≤ Scalar.max ty) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = scalar_rem ↑x ↑y := by
  simp [HMod.hMod, rem]
  simp [tryMk, tryMkOpt, ofOption, *]

theorem Scalar.rem_unsigned_spec {ty} (s: ¬ ty.isSigned) (x : Scalar ty) {y : Scalar ty}
  (hnz : ↑y ≠ (0 : Int)) :
  ∃ z, x % y = ok z ∧ (↑z : Int) = ↑x % ↑y := by
  have h : Scalar.min ty = 0 := by cases ty <;> simp [ScalarTy.isSigned, min] at *
  have hx := x.hmin
  have hy := y.hmin
  simp [h] at hx hy
  have hmin : (0 : Int) ≤ x % y := Int.emod_nonneg ↑x hnz
  have hmax : ↑x % ↑y ≤ Scalar.max ty := by
    have h : (0 : Int) < y := by int_tac
    have h := Int.emod_lt_of_pos ↑x h
    have := y.hmax
    omega
  have hs := @rem_spec ty x y hnz
  simp [*] at hs
  simp [*]



theorem core.num.checked_rem_spec {ty} {x y : Scalar ty} :
  match core.num.checked_rem x y with
  | some z => y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_rem ↑x ↑y) ∧ ↑z = (scalar_rem ↑x ↑y : Int)
  | none => ¬ (y.val ≠ 0 ∧ Scalar.in_bounds ty (scalar_rem ↑x ↑y)) := by
  have h := Scalar.tryMk_eq ty (scalar_rem ↑x ↑y)
  simp only [checked_rem, Option.ofResult]
  cases heq0: (y.val = 0 : Bool) <;>
  cases heq1: x % y <;> simp_all <;> simp only [HMod.hMod, Scalar.rem, Mod.mod] at heq1
  <;> simp_all

-- Leading zeros
def core.num.Usize.leading_zeros (x : Usize) : U32 := sorry
def core.num.U8.leading_zeros (x : U8) : U32 := sorry
def core.num.U16.leading_zeros (x : U16) : U32 := sorry
def core.num.U32.leading_zeros (x : U32) : U32 := sorry
def core.num.U64.leading_zeros (x : U64) : U32 := sorry
def core.num.U128.leading_zeros (x : U128) : U32 := sorry

def core.num.Isize.leading_zeros (x : Isize) : U32 := sorry
def core.num.I8.leading_zeros (x : I8) : U32 := sorry
def core.num.I16.leading_zeros (x : I16) : U32 := sorry
def core.num.I32.leading_zeros (x : I32) : U32 := sorry
def core.num.I64.leading_zeros (x : I64) : U32 := sorry
def core.num.I128.leading_zeros (x : I128) : U32 := sorry

-- Clone
@[reducible, simp] def core.clone.impls.CloneUsize.clone (x : Usize) : Usize := x
@[reducible, simp] def core.clone.impls.CloneU8.clone (x : U8) : U8 := x
@[reducible, simp] def core.clone.impls.CloneU16.clone (x : U16) : U16 := x
@[reducible, simp] def core.clone.impls.CloneU32.clone (x : U32) : U32 := x
@[reducible, simp] def core.clone.impls.CloneU64.clone (x : U64) : U64 := x
@[reducible, simp] def core.clone.impls.CloneU128.clone (x : U128) : U128 := x

@[reducible, simp] def core.clone.impls.CloneIsize.clone (x : Isize) : Isize := x
@[reducible, simp] def core.clone.impls.CloneI8.clone (x : I8) : I8 := x
@[reducible, simp] def core.clone.impls.CloneI16.clone (x : I16) : I16 := x
@[reducible, simp] def core.clone.impls.CloneI32.clone (x : I32) : I32 := x
@[reducible, simp] def core.clone.impls.CloneI64.clone (x : I64) : I64 := x
@[reducible, simp] def core.clone.impls.CloneI128.clone (x : I128) : I128 := x

@[reducible]
def core.clone.CloneUsize : core.clone.Clone Usize := {
  clone := fun x => ok (core.clone.impls.CloneUsize.clone x)
}

@[reducible]
def core.clone.CloneU8 : core.clone.Clone U8 := {
  clone := fun x => ok (core.clone.impls.CloneU8.clone x)
}

@[reducible]
def core.clone.CloneU16 : core.clone.Clone U16 := {
  clone := fun x => ok (core.clone.impls.CloneU16.clone x)
}

@[reducible]
def core.clone.CloneU32 : core.clone.Clone U32 := {
  clone := fun x => ok (core.clone.impls.CloneU32.clone x)
}

@[reducible]
def core.clone.CloneU64 : core.clone.Clone U64 := {
  clone := fun x => ok (core.clone.impls.CloneU64.clone x)
}

@[reducible]
def core.clone.CloneU128 : core.clone.Clone U128 := {
  clone := fun x => ok (core.clone.impls.CloneU128.clone x)
}

@[reducible]
def core.clone.CloneIsize : core.clone.Clone Isize := {
  clone := fun x => ok (core.clone.impls.CloneIsize.clone x)
}

@[reducible]
def core.clone.CloneI8 : core.clone.Clone I8 := {
  clone := fun x => ok (core.clone.impls.CloneI8.clone x)
}

@[reducible]
def core.clone.CloneI16 : core.clone.Clone I16 := {
  clone := fun x => ok (core.clone.impls.CloneI16.clone x)
}

@[reducible]
def core.clone.CloneI32 : core.clone.Clone I32 := {
  clone := fun x => ok (core.clone.impls.CloneI32.clone x)
}

@[reducible]
def core.clone.CloneI64 : core.clone.Clone I64 := {
  clone := fun x => ok (core.clone.impls.CloneI64.clone x)
}

@[reducible]
def core.clone.CloneI128 : core.clone.Clone I128 := {
  clone := fun x => ok (core.clone.impls.CloneI128.clone x)
}

@[reducible]
def core.marker.CopyU8 : core.marker.Copy U8 := {
  cloneInst := core.clone.CloneU8
}

@[reducible]
def core.marker.CopyU16 : core.marker.Copy U16 := {
  cloneInst := core.clone.CloneU16
}

@[reducible]
def core.marker.CopyU32 : core.marker.Copy U32 := {
  cloneInst := core.clone.CloneU32
}

@[reducible]
def core.marker.CopyU64 : core.marker.Copy U64 := {
  cloneInst := core.clone.CloneU64
}

@[reducible]
def core.marker.CopyU128 : core.marker.Copy U128 := {
  cloneInst := core.clone.CloneU128
}

@[reducible]
def core.marker.CopyUsize : core.marker.Copy Usize := {
  cloneInst := core.clone.CloneUsize
}

@[reducible]
def core.marker.CopyI8 : core.marker.Copy I8 := {
  cloneInst := core.clone.CloneI8
}

@[reducible]
def core.marker.CopyI16 : core.marker.Copy I16 := {
  cloneInst := core.clone.CloneI16
}

@[reducible]
def core.marker.CopyI32 : core.marker.Copy I32 := {
  cloneInst := core.clone.CloneI32
}

@[reducible]
def core.marker.CopyI64 : core.marker.Copy I64 := {
  cloneInst := core.clone.CloneI64
}

@[reducible]
def core.marker.CopyI128 : core.marker.Copy I128 := {
  cloneInst := core.clone.CloneI128
}

@[reducible]
def core.marker.CopyIsize : core.marker.Copy Isize := {
  cloneInst := core.clone.CloneIsize
}

-- This is easier defined this way than with the modulo operation (because of the
-- unsigned cases).
def int_overflowing_add (ty : ScalarTy) (x y : Int) : Int × Bool :=
  let z := x + y
  let b := false
  let range := Scalar.max ty - Scalar.min ty + 1
  let r := (z, b)
  let r := if r.1 > Scalar.max ty then (r.1 - range, true) else r
  let r := if r.1 < Scalar.min ty then (r.1 + range, true) else r
  r

def int_overflowing_add_in_bounds {ty} (x y : Scalar ty) :
  let r := int_overflowing_add ty x.val y.val
  Scalar.min ty ≤ r.1 ∧ r.1 ≤ Scalar.max ty := by
  simp [int_overflowing_add]
  split <;> split <;> cases ty <;> simp at * <;>
  scalar_tac

def int_overflowing_add_unsigned_overflow {ty} (h: ¬ ty.isSigned) (x y : Scalar ty) :
  let r := int_overflowing_add ty x.val y.val
  x.val + y.val = if r.2 then r.1 + Scalar.max ty + 1 else r.1 := by
  simp [int_overflowing_add]
  split <;> split <;> cases ty <;> simp [ScalarTy.isSigned] at * <;>
  scalar_tac

def Scalar.overflowing_add {ty} (x y : Scalar ty) : Result (Scalar ty × Bool) :=
  let r := int_overflowing_add ty x.val y.val
  have h := int_overflowing_add_in_bounds x y
  let z : Scalar ty := ⟨ r.1, h.left, h.right ⟩
  ok (z, r.2)

/- [core::num::{u8}::overflowing_add] -/
def core.num.U8.overflowing_add := @Scalar.overflowing_add ScalarTy.U8

/- [core::num::{u16}::overflowing_add] -/
def core.num.U16.overflowing_add := @Scalar.overflowing_add ScalarTy.U16

/- [core::num::{u32}::overflowing_add] -/
def core.num.U32.overflowing_add := @Scalar.overflowing_add ScalarTy.U32

/- [core::num::{u64}::overflowing_add] -/
def core.num.U64.overflowing_add := @Scalar.overflowing_add ScalarTy.U64

/- [core::num::{u128}::overflowing_add] -/
def core.num.U128.overflowing_add := @Scalar.overflowing_add ScalarTy.U128

/- [core::num::{usize}::overflowing_add] -/
def core.num.Usize.overflowing_add := @Scalar.overflowing_add ScalarTy.Usize

/- [core::num::{i8}::overflowing_add] -/
def core.num.I8.overflowing_add := @Scalar.overflowing_add ScalarTy.I8

/- [core::num::{i16}::overflowing_add] -/
def core.num.I16.overflowing_add := @Scalar.overflowing_add ScalarTy.I16

/- [core::num::{i32}::overflowing_add] -/
def core.num.I32.overflowing_add := @Scalar.overflowing_add ScalarTy.I32

/- [core::num::{i64}::overflowing_add] -/
def core.num.I64.overflowing_add := @Scalar.overflowing_add ScalarTy.I64

/- [core::num::{i128}::overflowing_add] -/
def core.num.I128.overflowing_add := @Scalar.overflowing_add ScalarTy.I128

/- [core::num::{isize}::overflowing_add] -/
def core.num.Isize.overflowing_add := @Scalar.overflowing_add ScalarTy.Isize

@[progress]
theorem core.num.U8.overflowing_add_spec (x y : U8) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > U8.max then z.val = x.val + y.val - U8.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

@[progress]
theorem core.num.U16.overflowing_add_spec (x y : U16) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > U16.max then z.val = x.val + y.val - U16.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

@[progress]
theorem core.num.U32.overflowing_add_spec (x y : U32) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > U32.max then z.val = x.val + y.val - U32.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

@[progress]
theorem core.num.U64.overflowing_add_spec (x y : U64) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > U64.max then z.val = x.val + y.val - U64.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

@[progress]
theorem core.num.U128.overflowing_add_spec (x y : U128) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > U128.max then z.val = x.val + y.val - U128.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

@[progress]
theorem core.num.Usize.overflowing_add_spec (x y : Usize) :
  ∃ z b, overflowing_add x y = ok (z, b) ∧
  if x.val + y.val > Usize.max then z.val = x.val + y.val - Usize.max - 1 ∧ b = true
  else z.val = x.val + y.val ∧ b = false
  := by
  simp [overflowing_add, Scalar.overflowing_add, int_overflowing_add]
  split <;> split <;> simp_all <;> scalar_tac

-- Saturating add
def int_saturating_add (ty : ScalarTy) (x y : Int) : Int :=
  let r := x + y
  let r := if r > Scalar.max ty then Scalar.max ty else r
  let r := if r < Scalar.min ty then Scalar.min ty else r
  r

def int_saturating_add_in_bounds {ty} (x y : Scalar ty) :
  let r := int_saturating_add ty x.val y.val
  Scalar.min ty ≤ r ∧ r ≤ Scalar.max ty := by
  simp [int_saturating_add]
  split <;> constructor <;> cases ty <;> scalar_tac

def Scalar.saturating_add {ty} (x y : Scalar ty) : Scalar ty :=
  let r := int_saturating_add ty x.val y.val
  have h := int_saturating_add_in_bounds x y
  ⟨ r, h.1, h.2 ⟩

/- [core::num::{u8}::saturating_add] -/
def core.num.U8.saturating_add := @Scalar.saturating_add ScalarTy.U8

/- [core::num::{u16}::saturating_add] -/
def core.num.U16.saturating_add := @Scalar.saturating_add ScalarTy.U16

/- [core::num::{u32}::saturating_add] -/
def core.num.U32.saturating_add := @Scalar.saturating_add ScalarTy.U32

/- [core::num::{u64}::saturating_add] -/
def core.num.U64.saturating_add := @Scalar.saturating_add ScalarTy.U64

/- [core::num::{u128}::saturating_add] -/
def core.num.U128.saturating_add := @Scalar.saturating_add ScalarTy.U128

/- [core::num::{usize}::saturating_add] -/
def core.num.Usize.saturating_add := @Scalar.saturating_add ScalarTy.Usize

/- [core::num::{i8}::saturating_add] -/
def core.num.I8.saturating_add := @Scalar.saturating_add ScalarTy.I8

/- [core::num::{i16}::saturating_add] -/
def core.num.I16.saturating_add := @Scalar.saturating_add ScalarTy.I16

/- [core::num::{i32}::saturating_add] -/
def core.num.I32.saturating_add := @Scalar.saturating_add ScalarTy.I32

/- [core::num::{i64}::saturating_add] -/
def core.num.I64.saturating_add := @Scalar.saturating_add ScalarTy.I64

/- [core::num::{i128}::saturating_add] -/
def core.num.I128.saturating_add := @Scalar.saturating_add ScalarTy.I128

/- [core::num::{isize}::saturating_add] -/
def core.num.Isize.saturating_add := @Scalar.saturating_add ScalarTy.Isize

theorem core.num.U8.saturating_add_spec (x y : U8) :
  let z := saturating_add x y
  if x.val + y.val > U8.max then z.val = U8.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U16.saturating_add_spec (x y : U16) :
  let z := saturating_add x y
  if x.val + y.val > U16.max then z.val = U16.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U32.saturating_add_spec (x y : U32) :
  let z := saturating_add x y
  if x.val + y.val > U32.max then z.val = U32.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U64.saturating_add_spec (x y : U64) :
  let z := saturating_add x y
  if x.val + y.val > U64.max then z.val = U64.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U128.saturating_add_spec (x y : U128) :
  let z := saturating_add x y
  if x.val + y.val > U128.max then z.val = U128.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

theorem core.num.Usize.saturating_add_spec (x y : Usize) :
  let z := saturating_add x y
  if x.val + y.val > Usize.max then z.val = Usize.max
  else z.val = x.val + y.val
  := by
  simp [saturating_add, Scalar.saturating_add, int_saturating_add]
  split <;> split <;> split <;> scalar_tac

-- Saturating sub
def int_saturating_sub (ty : ScalarTy) (x y : Int) : Int :=
  let r := x - y
  let r := if r > Scalar.max ty then Scalar.max ty else r
  let r := if r < Scalar.min ty then Scalar.min ty else r
  r

def int_saturating_sub_in_bounds {ty} (x y : Scalar ty) :
  let r := int_saturating_sub ty x.val y.val
  Scalar.min ty ≤ r ∧ r ≤ Scalar.max ty := by
  simp [int_saturating_sub]
  split <;> constructor <;> cases ty <;> scalar_tac

def Scalar.saturating_sub {ty} (x y : Scalar ty) : Scalar ty :=
  let r := int_saturating_sub ty x.val y.val
  have h := int_saturating_sub_in_bounds x y
  ⟨ r, h.1, h.2 ⟩

/- [core::num::{u8}::saturating_sub] -/
def core.num.U8.saturating_sub := @Scalar.saturating_sub ScalarTy.U8

/- [core::num::{u16}::saturating_sub] -/
def core.num.U16.saturating_sub := @Scalar.saturating_sub ScalarTy.U16

/- [core::num::{u32}::saturating_sub] -/
def core.num.U32.saturating_sub := @Scalar.saturating_sub ScalarTy.U32

/- [core::num::{u64}::saturating_sub] -/
def core.num.U64.saturating_sub := @Scalar.saturating_sub ScalarTy.U64

/- [core::num::{u128}::saturating_sub] -/
def core.num.U128.saturating_sub := @Scalar.saturating_sub ScalarTy.U128

/- [core::num::{usize}::saturating_sub] -/
def core.num.Usize.saturating_sub := @Scalar.saturating_sub ScalarTy.Usize

/- [core::num::{i8}::saturating_sub] -/
def core.num.I8.saturating_sub := @Scalar.saturating_sub ScalarTy.I8

/- [core::num::{i16}::saturating_sub] -/
def core.num.I16.saturating_sub := @Scalar.saturating_sub ScalarTy.I16

/- [core::num::{i32}::saturating_sub] -/
def core.num.I32.saturating_sub := @Scalar.saturating_sub ScalarTy.I32

/- [core::num::{i64}::saturating_sub] -/
def core.num.I64.saturating_sub := @Scalar.saturating_sub ScalarTy.I64

/- [core::num::{i128}::saturating_sub] -/
def core.num.I128.saturating_sub := @Scalar.saturating_sub ScalarTy.I128

/- [core::num::{isize}::saturating_sub] -/
def core.num.Isize.saturating_sub := @Scalar.saturating_sub ScalarTy.Isize

theorem core.num.U8.saturating_sub_spec (x y : U8) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U16.saturating_sub_spec (x y : U16) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U32.saturating_sub_spec (x y : U32) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U64.saturating_sub_spec (x y : U64) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

theorem core.num.U128.saturating_sub_spec (x y : U128) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

theorem core.num.Usize.saturating_sub_spec (x y : Usize) :
  let z := saturating_sub x y
  if x.val - y.val < 0 then z.val = 0
  else z.val = x.val - y.val
  := by
  simp [saturating_sub, Scalar.saturating_sub, int_saturating_sub]
  split <;> split <;> split <;> scalar_tac

-- Wrapping add
def Scalar.wrapping_add {ty} (x y : Scalar ty) : Scalar ty := sorry

/- [core::num::{u8}::wrapping_add] -/
def core.num.U8.wrapping_add : U8 → U8 → U8 := @Scalar.wrapping_add ScalarTy.U8

/- [core::num::{u16}::wrapping_add] -/
def core.num.U16.wrapping_add : U16 → U16 → U16  := @Scalar.wrapping_add ScalarTy.U16

/- [core::num::{u32}::wrapping_add] -/
def core.num.U32.wrapping_add : U32 → U32 → U32  := @Scalar.wrapping_add ScalarTy.U32

/- [core::num::{u64}::wrapping_add] -/
def core.num.U64.wrapping_add : U64 → U64 → U64  := @Scalar.wrapping_add ScalarTy.U64

/- [core::num::{u128}::wrapping_add] -/
def core.num.U128.wrapping_add : U128 → U128 → U128 := @Scalar.wrapping_add ScalarTy.U128

/- [core::num::{usize}::wrapping_add] -/
def core.num.Usize.wrapping_add : Usize → Usize → Usize  := @Scalar.wrapping_add ScalarTy.Usize

/- [core::num::{i8}::wrapping_add] -/
def core.num.I8.wrapping_add : I8 → I8 → I8  := @Scalar.wrapping_add ScalarTy.I8

/- [core::num::{i16}::wrapping_add] -/
def core.num.I16.wrapping_add : I16 → I16 → I16  := @Scalar.wrapping_add ScalarTy.I16

/- [core::num::{i32}::wrapping_add] -/
def core.num.I32.wrapping_add : I32 → I32 → I32  := @Scalar.wrapping_add ScalarTy.I32

/- [core::num::{i64}::wrapping_add] -/
def core.num.I64.wrapping_add : I64 → I64 → I64 := @Scalar.wrapping_add ScalarTy.I64

/- [core::num::{i128}::wrapping_add] -/
def core.num.I128.wrapping_add : I128 → I128 → I128  := @Scalar.wrapping_add ScalarTy.I128

/- [core::num::{isize}::wrapping_add] -/
def core.num.Isize.wrapping_add : Isize → Isize → Isize  := @Scalar.wrapping_add ScalarTy.Isize

-- TODO: reasoning lemmas for wrapping add

-- Wrapping sub
def Scalar.wrapping_sub {ty} (x y : Scalar ty) : Scalar ty := sorry

/- [core::num::{u8}::wrapping_sub] -/
def core.num.U8.wrapping_sub : U8 → U8 → U8 := @Scalar.wrapping_sub ScalarTy.U8

/- [core::num::{u16}::wrapping_sub] -/
def core.num.U16.wrapping_sub : U16 → U16 → U16 := @Scalar.wrapping_sub ScalarTy.U16

/- [core::num::{u32}::wrapping_sub] -/
def core.num.U32.wrapping_sub : U32 → U32 → U32 := @Scalar.wrapping_sub ScalarTy.U32

/- [core::num::{u64}::wrapping_sub] -/
def core.num.U64.wrapping_sub : U64 → U64 → U64 := @Scalar.wrapping_sub ScalarTy.U64

/- [core::num::{u128}::wrapping_sub] -/
def core.num.U128.wrapping_sub : U128 → U128 → U128 := @Scalar.wrapping_sub ScalarTy.U128

/- [core::num::{usize}::wrapping_sub] -/
def core.num.Usize.wrapping_sub : Usize → Usize → Usize := @Scalar.wrapping_sub ScalarTy.Usize

/- [core::num::{i8}::wrapping_sub] -/
def core.num.I8.wrapping_sub : I8 → I8 → I8 := @Scalar.wrapping_sub ScalarTy.I8

/- [core::num::{i16}::wrapping_sub] -/
def core.num.I16.wrapping_sub : I16 → I16 → I16 := @Scalar.wrapping_sub ScalarTy.I16

/- [core::num::{i32}::wrapping_sub] -/
def core.num.I32.wrapping_sub : I32 → I32 → I32 := @Scalar.wrapping_sub ScalarTy.I32

/- [core::num::{i64}::wrapping_sub] -/
def core.num.I64.wrapping_sub : I64 → I64 → I64 := @Scalar.wrapping_sub ScalarTy.I64

/- [core::num::{i128}::wrapping_sub] -/
def core.num.I128.wrapping_sub : I128 → I128 → I128 := @Scalar.wrapping_sub ScalarTy.I128

/- [core::num::{isize}::wrapping_sub] -/
def core.num.Isize.wrapping_sub : Isize → Isize → Isize := @Scalar.wrapping_sub ScalarTy.Isize

-- TODO: reasoning lemmas for wrapping sub

-- Rotate left
def Scalar.rotate_left {ty} (x  : Scalar ty) (shift : U32) : Scalar ty := sorry

/- [core::num::{u8}::rotate_left] -/
def core.num.U8.rotate_left := @Scalar.rotate_left ScalarTy.U8

/- [core::num::{u16}::rotate_left] -/
def core.num.U16.rotate_left := @Scalar.rotate_left ScalarTy.U16

/- [core::num::{u32}::rotate_left] -/
def core.num.U32.rotate_left := @Scalar.rotate_left ScalarTy.U32

/- [core::num::{u64}::rotate_left] -/
def core.num.U64.rotate_left := @Scalar.rotate_left ScalarTy.U64

/- [core::num::{u128}::rotate_left] -/
def core.num.U128.rotate_left := @Scalar.rotate_left ScalarTy.U128

/- [core::num::{usize}::rotate_left] -/
def core.num.Usize.rotate_left := @Scalar.rotate_left ScalarTy.Usize

/- [core::num::{i8}::rotate_left] -/
def core.num.I8.rotate_left := @Scalar.rotate_left ScalarTy.I8

/- [core::num::{i16}::rotate_left] -/
def core.num.I16.rotate_left := @Scalar.rotate_left ScalarTy.I16

/- [core::num::{i32}::rotate_left] -/
def core.num.I32.rotate_left := @Scalar.rotate_left ScalarTy.I32

/- [core::num::{i64}::rotate_left] -/
def core.num.I64.rotate_left := @Scalar.rotate_left ScalarTy.I64

/- [core::num::{i128}::rotate_left] -/
def core.num.I128.rotate_left := @Scalar.rotate_left ScalarTy.I128

/- [core::num::{isize}::rotate_left] -/
def core.num.Isize.rotate_left := @Scalar.rotate_left ScalarTy.Isize

-- TODO: reasoning lemmas for rotate left

-- Rotate right
def Scalar.rotate_right {ty} (x : Scalar ty) (shift : U32) : Scalar ty := sorry

/- [core::num::{u8}::rotate_right] -/
def core.num.U8.rotate_right := @Scalar.rotate_right ScalarTy.U8

/- [core::num::{u16}::rotate_right] -/
def core.num.U16.rotate_right := @Scalar.rotate_right ScalarTy.U16

/- [core::num::{u32}::rotate_right] -/
def core.num.U32.rotate_right := @Scalar.rotate_right ScalarTy.U32

/- [core::num::{u64}::rotate_right] -/
def core.num.U64.rotate_right := @Scalar.rotate_right ScalarTy.U64

/- [core::num::{u128}::rotate_right] -/
def core.num.U128.rotate_right := @Scalar.rotate_right ScalarTy.U128

/- [core::num::{usize}::rotate_right] -/
def core.num.Usize.rotate_right := @Scalar.rotate_right ScalarTy.Usize

/- [core::num::{i8}::rotate_right] -/
def core.num.I8.rotate_right := @Scalar.rotate_right ScalarTy.I8

/- [core::num::{i16}::rotate_right] -/
def core.num.I16.rotate_right := @Scalar.rotate_right ScalarTy.I16

/- [core::num::{i32}::rotate_right] -/
def core.num.I32.rotate_right := @Scalar.rotate_right ScalarTy.I32

/- [core::num::{i64}::rotate_right] -/
def core.num.I64.rotate_right := @Scalar.rotate_right ScalarTy.I64

/- [core::num::{i128}::rotate_right] -/
def core.num.I128.rotate_right := @Scalar.rotate_right ScalarTy.I128

/- [core::num::{isize}::rotate_right] -/
def core.num.Isize.rotate_right := @Scalar.rotate_right ScalarTy.Isize

-- TODO: reasoning lemmas for rotate right

end Std

end Aeneas
