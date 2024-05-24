-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [constants]
import Base
open Primitives

namespace constants

/- [constants::X0]
   Source: 'tests/src/constants.rs', lines 7:0-7:17 -/
def X0_body : Result U32 := Result.ok 0#u32
def X0 : U32 := eval_global X0_body

/- [constants::X1]
   Source: 'tests/src/constants.rs', lines 9:0-9:17 -/
def X1_body : Result U32 := Result.ok core_u32_max
def X1 : U32 := eval_global X1_body

/- [constants::X2]
   Source: 'tests/src/constants.rs', lines 12:0-12:17 -/
def X2_body : Result U32 := Result.ok 3#u32
def X2 : U32 := eval_global X2_body

/- [constants::incr]:
   Source: 'tests/src/constants.rs', lines 19:0-19:32 -/
def incr (n : U32) : Result U32 :=
  n + 1#u32

/- [constants::X3]
   Source: 'tests/src/constants.rs', lines 17:0-17:17 -/
def X3_body : Result U32 := incr 32#u32
def X3 : U32 := eval_global X3_body

/- [constants::mk_pair0]:
   Source: 'tests/src/constants.rs', lines 25:0-25:51 -/
def mk_pair0 (x : U32) (y : U32) : Result (U32 × U32) :=
  Result.ok (x, y)

/- [constants::Pair]
   Source: 'tests/src/constants.rs', lines 38:0-38:23 -/
structure Pair (T1 T2 : Type) where
  x : T1
  y : T2

/- [constants::mk_pair1]:
   Source: 'tests/src/constants.rs', lines 29:0-29:55 -/
def mk_pair1 (x : U32) (y : U32) : Result (Pair U32 U32) :=
  Result.ok { x := x, y := y }

/- [constants::P0]
   Source: 'tests/src/constants.rs', lines 33:0-33:24 -/
def P0_body : Result (U32 × U32) := mk_pair0 0#u32 1#u32
def P0 : (U32 × U32) := eval_global P0_body

/- [constants::P1]
   Source: 'tests/src/constants.rs', lines 34:0-34:28 -/
def P1_body : Result (Pair U32 U32) := mk_pair1 0#u32 1#u32
def P1 : Pair U32 U32 := eval_global P1_body

/- [constants::P2]
   Source: 'tests/src/constants.rs', lines 35:0-35:24 -/
def P2_body : Result (U32 × U32) := Result.ok (0#u32, 1#u32)
def P2 : (U32 × U32) := eval_global P2_body

/- [constants::P3]
   Source: 'tests/src/constants.rs', lines 36:0-36:28 -/
def P3_body : Result (Pair U32 U32) := Result.ok { x := 0#u32, y := 1#u32 }
def P3 : Pair U32 U32 := eval_global P3_body

/- [constants::Wrap]
   Source: 'tests/src/constants.rs', lines 51:0-51:18 -/
structure Wrap (T : Type) where
  value : T

/- [constants::{constants::Wrap<T>}::new]:
   Source: 'tests/src/constants.rs', lines 56:4-56:41 -/
def Wrap.new (T : Type) (value : T) : Result (Wrap T) :=
  Result.ok { value := value }

/- [constants::Y]
   Source: 'tests/src/constants.rs', lines 43:0-43:22 -/
def Y_body : Result (Wrap I32) := Wrap.new I32 2#i32
def Y : Wrap I32 := eval_global Y_body

/- [constants::unwrap_y]:
   Source: 'tests/src/constants.rs', lines 45:0-45:30 -/
def unwrap_y : Result I32 :=
  Result.ok Y.value

/- [constants::YVAL]
   Source: 'tests/src/constants.rs', lines 49:0-49:19 -/
def YVAL_body : Result I32 := unwrap_y
def YVAL : I32 := eval_global YVAL_body

/- [constants::get_z1::Z1]
   Source: 'tests/src/constants.rs', lines 64:4-64:17 -/
def get_z1.Z1_body : Result I32 := Result.ok 3#i32
def get_z1.Z1 : I32 := eval_global get_z1.Z1_body

/- [constants::get_z1]:
   Source: 'tests/src/constants.rs', lines 63:0-63:28 -/
def get_z1 : Result I32 :=
  Result.ok get_z1.Z1

/- [constants::add]:
   Source: 'tests/src/constants.rs', lines 68:0-68:39 -/
def add (a : I32) (b : I32) : Result I32 :=
  a + b

/- [constants::Q1]
   Source: 'tests/src/constants.rs', lines 76:0-76:17 -/
def Q1_body : Result I32 := Result.ok 5#i32
def Q1 : I32 := eval_global Q1_body

/- [constants::Q2]
   Source: 'tests/src/constants.rs', lines 77:0-77:17 -/
def Q2_body : Result I32 := Result.ok Q1
def Q2 : I32 := eval_global Q2_body

/- [constants::Q3]
   Source: 'tests/src/constants.rs', lines 78:0-78:17 -/
def Q3_body : Result I32 := add Q2 3#i32
def Q3 : I32 := eval_global Q3_body

/- [constants::get_z2]:
   Source: 'tests/src/constants.rs', lines 72:0-72:28 -/
def get_z2 : Result I32 :=
  do
  let i ← get_z1
  let i1 ← add i Q3
  add Q1 i1

/- [constants::S1]
   Source: 'tests/src/constants.rs', lines 82:0-82:18 -/
def S1_body : Result U32 := Result.ok 6#u32
def S1 : U32 := eval_global S1_body

/- [constants::S2]
   Source: 'tests/src/constants.rs', lines 83:0-83:18 -/
def S2_body : Result U32 := incr S1
def S2 : U32 := eval_global S2_body

/- [constants::S3]
   Source: 'tests/src/constants.rs', lines 84:0-84:29 -/
def S3_body : Result (Pair U32 U32) := Result.ok P3
def S3 : Pair U32 U32 := eval_global S3_body

/- [constants::S4]
   Source: 'tests/src/constants.rs', lines 85:0-85:29 -/
def S4_body : Result (Pair U32 U32) := mk_pair1 7#u32 8#u32
def S4 : Pair U32 U32 := eval_global S4_body

/- [constants::V]
   Source: 'tests/src/constants.rs', lines 88:0-88:31 -/
structure V (T : Type) (N : Usize) where
  x : Array T N

/- [constants::{constants::V<T, N>#1}::LEN]
   Source: 'tests/src/constants.rs', lines 93:4-93:24 -/
def V.LEN_body (T : Type) (N : Usize) : Result Usize := Result.ok N
def V.LEN (T : Type) (N : Usize) : Usize := eval_global (V.LEN_body T N)

/- [constants::use_v]:
   Source: 'tests/src/constants.rs', lines 96:0-96:42 -/
def use_v (T : Type) (N : Usize) : Result Usize :=
  Result.ok (V.LEN T N)

end constants
