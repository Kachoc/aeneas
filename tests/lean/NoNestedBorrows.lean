-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [no_nested_borrows]
import Base
open Primitives

namespace no_nested_borrows

/- [no_nested_borrows::Pair] -/
structure Pair (T1 T2 : Type) where
  x : T1
  y : T2

/- [no_nested_borrows::List] -/
inductive List (T : Type) :=
| Cons : T → List T → List T
| Nil : List T

/- [no_nested_borrows::One] -/
inductive One (T1 : Type) :=
| One : T1 → One T1

/- [no_nested_borrows::EmptyEnum] -/
inductive EmptyEnum :=
| Empty : EmptyEnum

/- [no_nested_borrows::Enum] -/
inductive Enum :=
| Variant1 : Enum
| Variant2 : Enum

/- [no_nested_borrows::EmptyStruct] -/
structure EmptyStruct where

/- [no_nested_borrows::Sum] -/
inductive Sum (T1 T2 : Type) :=
| Left : T1 → Sum T1 T2
| Right : T2 → Sum T1 T2

/- [no_nested_borrows::neg_test]: forward function -/
def neg_test (x : I32) : Result I32 :=
  - x

/- [no_nested_borrows::add_test]: forward function -/
def add_test (x : U32) (y : U32) : Result U32 :=
  x + y

/- [no_nested_borrows::subs_test]: forward function -/
def subs_test (x : U32) (y : U32) : Result U32 :=
  x - y

/- [no_nested_borrows::div_test]: forward function -/
def div_test (x : U32) (y : U32) : Result U32 :=
  x / y

/- [no_nested_borrows::div_test1]: forward function -/
def div_test1 (x : U32) : Result U32 :=
  x / (U32.ofInt 2)

/- [no_nested_borrows::rem_test]: forward function -/
def rem_test (x : U32) (y : U32) : Result U32 :=
  x % y

/- [no_nested_borrows::cast_test]: forward function -/
def cast_test (x : U32) : Result I32 :=
  Scalar.cast .I32 x

/- [no_nested_borrows::test2]: forward function -/
def test2 : Result Unit :=
  do
    let _ ← (U32.ofInt 23) + (U32.ofInt 44)
    Result.ret ()

/- Unit test for [no_nested_borrows::test2] -/
#assert (test2 == .ret ())

/- [no_nested_borrows::get_max]: forward function -/
def get_max (x : U32) (y : U32) : Result U32 :=
  if x >= y
  then Result.ret x
  else Result.ret y

/- [no_nested_borrows::test3]: forward function -/
def test3 : Result Unit :=
  do
    let x ← get_max (U32.ofInt 4) (U32.ofInt 3)
    let y ← get_max (U32.ofInt 10) (U32.ofInt 11)
    let z ← x + y
    if not (z = (U32.ofInt 15))
    then Result.fail Error.panic
    else Result.ret ()

/- Unit test for [no_nested_borrows::test3] -/
#assert (test3 == .ret ())

/- [no_nested_borrows::test_neg1]: forward function -/
def test_neg1 : Result Unit :=
  do
    let y ← - (I32.ofInt 3)
    if not (y = (I32.ofInt (-(3:Int))))
    then Result.fail Error.panic
    else Result.ret ()

/- Unit test for [no_nested_borrows::test_neg1] -/
#assert (test_neg1 == .ret ())

/- [no_nested_borrows::refs_test1]: forward function -/
def refs_test1 : Result Unit :=
  if not ((I32.ofInt 1) = (I32.ofInt 1))
  then Result.fail Error.panic
  else Result.ret ()

/- Unit test for [no_nested_borrows::refs_test1] -/
#assert (refs_test1 == .ret ())

/- [no_nested_borrows::refs_test2]: forward function -/
def refs_test2 : Result Unit :=
  if not ((I32.ofInt 2) = (I32.ofInt 2))
  then Result.fail Error.panic
  else
    if not ((I32.ofInt 0) = (I32.ofInt 0))
    then Result.fail Error.panic
    else
      if not ((I32.ofInt 2) = (I32.ofInt 2))
      then Result.fail Error.panic
      else
        if not ((I32.ofInt 2) = (I32.ofInt 2))
        then Result.fail Error.panic
        else Result.ret ()

/- Unit test for [no_nested_borrows::refs_test2] -/
#assert (refs_test2 == .ret ())

/- [no_nested_borrows::test_list1]: forward function -/
def test_list1 : Result Unit :=
  Result.ret ()

/- Unit test for [no_nested_borrows::test_list1] -/
#assert (test_list1 == .ret ())

/- [no_nested_borrows::test_box1]: forward function -/
def test_box1 : Result Unit :=
  let b := (I32.ofInt 1)
  let x := b
  if not (x = (I32.ofInt 1))
  then Result.fail Error.panic
  else Result.ret ()

/- Unit test for [no_nested_borrows::test_box1] -/
#assert (test_box1 == .ret ())

/- [no_nested_borrows::copy_int]: forward function -/
def copy_int (x : I32) : Result I32 :=
  Result.ret x

/- [no_nested_borrows::test_unreachable]: forward function -/
def test_unreachable (b : Bool) : Result Unit :=
  if b
  then Result.fail Error.panic
  else Result.ret ()

/- [no_nested_borrows::test_panic]: forward function -/
def test_panic (b : Bool) : Result Unit :=
  if b
  then Result.fail Error.panic
  else Result.ret ()

/- [no_nested_borrows::test_copy_int]: forward function -/
def test_copy_int : Result Unit :=
  do
    let y ← copy_int (I32.ofInt 0)
    if not ((I32.ofInt 0) = y)
    then Result.fail Error.panic
    else Result.ret ()

/- Unit test for [no_nested_borrows::test_copy_int] -/
#assert (test_copy_int == .ret ())

/- [no_nested_borrows::is_cons]: forward function -/
def is_cons (T : Type) (l : List T) : Result Bool :=
  match l with
  | List.Cons t l0 => Result.ret true
  | List.Nil => Result.ret false

/- [no_nested_borrows::test_is_cons]: forward function -/
def test_is_cons : Result Unit :=
  do
    let l := List.Nil
    let b ← is_cons I32 (List.Cons (I32.ofInt 0) l)
    if not b
    then Result.fail Error.panic
    else Result.ret ()

/- Unit test for [no_nested_borrows::test_is_cons] -/
#assert (test_is_cons == .ret ())

/- [no_nested_borrows::split_list]: forward function -/
def split_list (T : Type) (l : List T) : Result (T × (List T)) :=
  match l with
  | List.Cons hd tl => Result.ret (hd, tl)
  | List.Nil => Result.fail Error.panic

/- [no_nested_borrows::test_split_list]: forward function -/
def test_split_list : Result Unit :=
  do
    let l := List.Nil
    let p ← split_list I32 (List.Cons (I32.ofInt 0) l)
    let (hd, _) := p
    if not (hd = (I32.ofInt 0))
    then Result.fail Error.panic
    else Result.ret ()

/- Unit test for [no_nested_borrows::test_split_list] -/
#assert (test_split_list == .ret ())

/- [no_nested_borrows::choose]: forward function -/
def choose (T : Type) (b : Bool) (x : T) (y : T) : Result T :=
  if b
  then Result.ret x
  else Result.ret y

/- [no_nested_borrows::choose]: backward function 0 -/
def choose_back
  (T : Type) (b : Bool) (x : T) (y : T) (ret0 : T) : Result (T × T) :=
  if b
  then Result.ret (ret0, y)
  else Result.ret (x, ret0)

/- [no_nested_borrows::choose_test]: forward function -/
def choose_test : Result Unit :=
  do
    let z ← choose I32 true (I32.ofInt 0) (I32.ofInt 0)
    let z0 ← z + (I32.ofInt 1)
    if not (z0 = (I32.ofInt 1))
    then Result.fail Error.panic
    else
      do
        let (x, y) ← choose_back I32 true (I32.ofInt 0) (I32.ofInt 0) z0
        if not (x = (I32.ofInt 1))
        then Result.fail Error.panic
        else
          if not (y = (I32.ofInt 0))
          then Result.fail Error.panic
          else Result.ret ()

/- Unit test for [no_nested_borrows::choose_test] -/
#assert (choose_test == .ret ())

/- [no_nested_borrows::test_char]: forward function -/
def test_char : Result Char :=
  Result.ret 'a'

mutual

/- [no_nested_borrows::Tree] -/
inductive Tree (T : Type) :=
| Leaf : T → Tree T
| Node : T → NodeElem T → Tree T → Tree T

/- [no_nested_borrows::NodeElem] -/
inductive NodeElem (T : Type) :=
| Cons : Tree T → NodeElem T → NodeElem T
| Nil : NodeElem T

end

/- [no_nested_borrows::list_length]: forward function -/
divergent def list_length (T : Type) (l : List T) : Result U32 :=
  match l with
  | List.Cons t l1 => do
                        let i ← list_length T l1
                        (U32.ofInt 1) + i
  | List.Nil => Result.ret (U32.ofInt 0)

/- [no_nested_borrows::list_nth_shared]: forward function -/
divergent def list_nth_shared (T : Type) (l : List T) (i : U32) : Result T :=
  match l with
  | List.Cons x tl =>
    if i = (U32.ofInt 0)
    then Result.ret x
    else do
           let i0 ← i - (U32.ofInt 1)
           list_nth_shared T tl i0
  | List.Nil => Result.fail Error.panic

/- [no_nested_borrows::list_nth_mut]: forward function -/
divergent def list_nth_mut (T : Type) (l : List T) (i : U32) : Result T :=
  match l with
  | List.Cons x tl =>
    if i = (U32.ofInt 0)
    then Result.ret x
    else do
           let i0 ← i - (U32.ofInt 1)
           list_nth_mut T tl i0
  | List.Nil => Result.fail Error.panic

/- [no_nested_borrows::list_nth_mut]: backward function 0 -/
divergent def list_nth_mut_back
  (T : Type) (l : List T) (i : U32) (ret0 : T) : Result (List T) :=
  match l with
  | List.Cons x tl =>
    if i = (U32.ofInt 0)
    then Result.ret (List.Cons ret0 tl)
    else
      do
        let i0 ← i - (U32.ofInt 1)
        let tl0 ← list_nth_mut_back T tl i0 ret0
        Result.ret (List.Cons x tl0)
  | List.Nil => Result.fail Error.panic

/- [no_nested_borrows::list_rev_aux]: forward function -/
divergent def list_rev_aux
  (T : Type) (li : List T) (lo : List T) : Result (List T) :=
  match li with
  | List.Cons hd tl => list_rev_aux T tl (List.Cons hd lo)
  | List.Nil => Result.ret lo

/- [no_nested_borrows::list_rev]: merged forward/backward function
   (there is a single backward function, and the forward function returns ()) -/
def list_rev (T : Type) (l : List T) : Result (List T) :=
  let li := mem.replace (List T) l List.Nil
  list_rev_aux T li List.Nil

/- [no_nested_borrows::test_list_functions]: forward function -/
def test_list_functions : Result Unit :=
  do
    let l := List.Nil
    let l0 := List.Cons (I32.ofInt 2) l
    let l1 := List.Cons (I32.ofInt 1) l0
    let i ← list_length I32 (List.Cons (I32.ofInt 0) l1)
    if not (i = (U32.ofInt 3))
    then Result.fail Error.panic
    else
      do
        let i0 ←
          list_nth_shared I32 (List.Cons (I32.ofInt 0) l1) (U32.ofInt 0)
        if not (i0 = (I32.ofInt 0))
        then Result.fail Error.panic
        else
          do
            let i1 ←
              list_nth_shared I32 (List.Cons (I32.ofInt 0) l1) (U32.ofInt 1)
            if not (i1 = (I32.ofInt 1))
            then Result.fail Error.panic
            else
              do
                let i2 ←
                  list_nth_shared I32 (List.Cons (I32.ofInt 0) l1)
                    (U32.ofInt 2)
                if not (i2 = (I32.ofInt 2))
                then Result.fail Error.panic
                else
                  do
                    let ls ←
                      list_nth_mut_back I32 (List.Cons (I32.ofInt 0) l1)
                        (U32.ofInt 1) (I32.ofInt 3)
                    let i3 ← list_nth_shared I32 ls (U32.ofInt 0)
                    if not (i3 = (I32.ofInt 0))
                    then Result.fail Error.panic
                    else
                      do
                        let i4 ← list_nth_shared I32 ls (U32.ofInt 1)
                        if not (i4 = (I32.ofInt 3))
                        then Result.fail Error.panic
                        else
                          do
                            let i5 ← list_nth_shared I32 ls (U32.ofInt 2)
                            if not (i5 = (I32.ofInt 2))
                            then Result.fail Error.panic
                            else Result.ret ()

/- Unit test for [no_nested_borrows::test_list_functions] -/
#assert (test_list_functions == .ret ())

/- [no_nested_borrows::id_mut_pair1]: forward function -/
def id_mut_pair1 (T1 T2 : Type) (x : T1) (y : T2) : Result (T1 × T2) :=
  Result.ret (x, y)

/- [no_nested_borrows::id_mut_pair1]: backward function 0 -/
def id_mut_pair1_back
  (T1 T2 : Type) (x : T1) (y : T2) (ret0 : (T1 × T2)) : Result (T1 × T2) :=
  let (t, t0) := ret0
  Result.ret (t, t0)

/- [no_nested_borrows::id_mut_pair2]: forward function -/
def id_mut_pair2 (T1 T2 : Type) (p : (T1 × T2)) : Result (T1 × T2) :=
  let (t, t0) := p
  Result.ret (t, t0)

/- [no_nested_borrows::id_mut_pair2]: backward function 0 -/
def id_mut_pair2_back
  (T1 T2 : Type) (p : (T1 × T2)) (ret0 : (T1 × T2)) : Result (T1 × T2) :=
  let (t, t0) := ret0
  Result.ret (t, t0)

/- [no_nested_borrows::id_mut_pair3]: forward function -/
def id_mut_pair3 (T1 T2 : Type) (x : T1) (y : T2) : Result (T1 × T2) :=
  Result.ret (x, y)

/- [no_nested_borrows::id_mut_pair3]: backward function 0 -/
def id_mut_pair3_back'a
  (T1 T2 : Type) (x : T1) (y : T2) (ret0 : T1) : Result T1 :=
  Result.ret ret0

/- [no_nested_borrows::id_mut_pair3]: backward function 1 -/
def id_mut_pair3_back'b
  (T1 T2 : Type) (x : T1) (y : T2) (ret0 : T2) : Result T2 :=
  Result.ret ret0

/- [no_nested_borrows::id_mut_pair4]: forward function -/
def id_mut_pair4 (T1 T2 : Type) (p : (T1 × T2)) : Result (T1 × T2) :=
  let (t, t0) := p
  Result.ret (t, t0)

/- [no_nested_borrows::id_mut_pair4]: backward function 0 -/
def id_mut_pair4_back'a
  (T1 T2 : Type) (p : (T1 × T2)) (ret0 : T1) : Result T1 :=
  Result.ret ret0

/- [no_nested_borrows::id_mut_pair4]: backward function 1 -/
def id_mut_pair4_back'b
  (T1 T2 : Type) (p : (T1 × T2)) (ret0 : T2) : Result T2 :=
  Result.ret ret0

/- [no_nested_borrows::StructWithTuple] -/
structure StructWithTuple (T1 T2 : Type) where
  p : (T1 × T2)

/- [no_nested_borrows::new_tuple1]: forward function -/
def new_tuple1 : Result (StructWithTuple U32 U32) :=
  Result.ret { p := ((U32.ofInt 1), (U32.ofInt 2)) }

/- [no_nested_borrows::new_tuple2]: forward function -/
def new_tuple2 : Result (StructWithTuple I16 I16) :=
  Result.ret { p := ((I16.ofInt 1), (I16.ofInt 2)) }

/- [no_nested_borrows::new_tuple3]: forward function -/
def new_tuple3 : Result (StructWithTuple U64 I64) :=
  Result.ret { p := ((U64.ofInt 1), (I64.ofInt 2)) }

/- [no_nested_borrows::StructWithPair] -/
structure StructWithPair (T1 T2 : Type) where
  p : Pair T1 T2

/- [no_nested_borrows::new_pair1]: forward function -/
def new_pair1 : Result (StructWithPair U32 U32) :=
  Result.ret { p := { x := (U32.ofInt 1), y := (U32.ofInt 2) } }

/- [no_nested_borrows::test_constants]: forward function -/
def test_constants : Result Unit :=
  do
    let swt ← new_tuple1
    let (i, _) := swt.p
    if not (i = (U32.ofInt 1))
    then Result.fail Error.panic
    else
      do
        let swt0 ← new_tuple2
        let (i0, _) := swt0.p
        if not (i0 = (I16.ofInt 1))
        then Result.fail Error.panic
        else
          do
            let swt1 ← new_tuple3
            let (i1, _) := swt1.p
            if not (i1 = (U64.ofInt 1))
            then Result.fail Error.panic
            else
              do
                let swp ← new_pair1
                if not (swp.p.x = (U32.ofInt 1))
                then Result.fail Error.panic
                else Result.ret ()

/- Unit test for [no_nested_borrows::test_constants] -/
#assert (test_constants == .ret ())

/- [no_nested_borrows::test_weird_borrows1]: forward function -/
def test_weird_borrows1 : Result Unit :=
  Result.ret ()

/- Unit test for [no_nested_borrows::test_weird_borrows1] -/
#assert (test_weird_borrows1 == .ret ())

/- [no_nested_borrows::test_mem_replace]: merged forward/backward function
   (there is a single backward function, and the forward function returns ()) -/
def test_mem_replace (px : U32) : Result U32 :=
  let y := mem.replace U32 px (U32.ofInt 1)
  if not (y = (U32.ofInt 0))
  then Result.fail Error.panic
  else Result.ret (U32.ofInt 2)

/- [no_nested_borrows::test_shared_borrow_bool1]: forward function -/
def test_shared_borrow_bool1 (b : Bool) : Result U32 :=
  if b
  then Result.ret (U32.ofInt 0)
  else Result.ret (U32.ofInt 1)

/- [no_nested_borrows::test_shared_borrow_bool2]: forward function -/
def test_shared_borrow_bool2 : Result U32 :=
  Result.ret (U32.ofInt 0)

/- [no_nested_borrows::test_shared_borrow_enum1]: forward function -/
def test_shared_borrow_enum1 (l : List U32) : Result U32 :=
  match l with
  | List.Cons i l0 => Result.ret (U32.ofInt 1)
  | List.Nil => Result.ret (U32.ofInt 0)

/- [no_nested_borrows::test_shared_borrow_enum2]: forward function -/
def test_shared_borrow_enum2 : Result U32 :=
  Result.ret (U32.ofInt 0)

end no_nested_borrows
