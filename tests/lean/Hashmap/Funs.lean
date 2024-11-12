-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [hashmap]: function definitions
import Base
import Hashmap.Types
import Hashmap.FunsExternal
open Primitives
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

namespace hashmap

/- [hashmap::hash_key]:
   Source: 'tests/src/hashmap.rs', lines 38:0-43:1 -/
def hash_key (k : Usize) : Result Usize :=
  Result.ok k

/- [hashmap::{hashmap::HashMap<T>}::allocate_slots]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 64:8-67:9 -/
divergent def HashMap.allocate_slots_loop
  {T : Type} (slots : alloc.vec.Vec (AList T)) (n : Usize) :
  Result (alloc.vec.Vec (AList T))
  :=
  if n > 0#usize
  then
    do
    let slots1 ← alloc.vec.Vec.push slots AList.Nil
    let n1 ← n - 1#usize
    HashMap.allocate_slots_loop slots1 n1
  else Result.ok slots

/- [hashmap::{hashmap::HashMap<T>}::allocate_slots]:
   Source: 'tests/src/hashmap.rs', lines 63:4-69:5 -/
@[reducible]
def HashMap.allocate_slots
  {T : Type} (slots : alloc.vec.Vec (AList T)) (n : Usize) :
  Result (alloc.vec.Vec (AList T))
  :=
  HashMap.allocate_slots_loop slots n

/- [hashmap::{hashmap::HashMap<T>}::new_with_capacity]:
   Source: 'tests/src/hashmap.rs', lines 72:4-87:5 -/
def HashMap.new_with_capacity
  (T : Type) (capacity : Usize) (max_load_dividend : Usize)
  (max_load_divisor : Usize) :
  Result (HashMap T)
  :=
  do
  let slots ← HashMap.allocate_slots (alloc.vec.Vec.new (AList T)) capacity
  let i ← capacity * max_load_dividend
  let i1 ← i / max_load_divisor
  Result.ok
    {
      num_entries := 0#usize,
      max_load_factor := (max_load_dividend, max_load_divisor),
      max_load := i1,
      saturated := false,
      slots := slots
    }

/- [hashmap::{hashmap::HashMap<T>}::new]:
   Source: 'tests/src/hashmap.rs', lines 89:4-92:5 -/
def HashMap.new (T : Type) : Result (HashMap T) :=
  HashMap.new_with_capacity T 32#usize 4#usize 5#usize

/- [hashmap::{hashmap::HashMap<T>}::clear]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 98:8-101:9 -/
divergent def HashMap.clear_loop
  {T : Type} (slots : alloc.vec.Vec (AList T)) (i : Usize) :
  Result (alloc.vec.Vec (AList T))
  :=
  let i1 := alloc.vec.Vec.len slots
  if i < i1
  then
    do
    let (_, index_mut_back) ←
      alloc.vec.Vec.index_mut (core.slice.index.SliceIndexUsizeSliceTInst
        (AList T)) slots i
    let i2 ← i + 1#usize
    let slots1 ← index_mut_back AList.Nil
    HashMap.clear_loop slots1 i2
  else Result.ok slots

/- [hashmap::{hashmap::HashMap<T>}::clear]:
   Source: 'tests/src/hashmap.rs', lines 94:4-102:5 -/
def HashMap.clear {T : Type} (self : HashMap T) : Result (HashMap T) :=
  do
  let hm ← HashMap.clear_loop self.slots 0#usize
  Result.ok { self with num_entries := 0#usize, slots := hm }

/- [hashmap::{hashmap::HashMap<T>}::len]:
   Source: 'tests/src/hashmap.rs', lines 104:4-106:5 -/
def HashMap.len {T : Type} (self : HashMap T) : Result Usize :=
  Result.ok self.num_entries

/- [hashmap::{hashmap::HashMap<T>}::insert_in_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 1:0-127:9 -/
divergent def HashMap.insert_in_list_loop
  {T : Type} (key : Usize) (value : T) (ls : AList T) :
  Result (Bool × (AList T))
  :=
  match ls with
  | AList.Cons ckey cvalue tl =>
    if ckey = key
    then Result.ok (false, AList.Cons ckey value tl)
    else
      do
      let (b, tl1) ← HashMap.insert_in_list_loop key value tl
      Result.ok (b, AList.Cons ckey cvalue tl1)
  | AList.Nil => Result.ok (true, AList.Cons key value AList.Nil)

/- [hashmap::{hashmap::HashMap<T>}::insert_in_list]:
   Source: 'tests/src/hashmap.rs', lines 111:4-128:5 -/
@[reducible]
def HashMap.insert_in_list
  {T : Type} (key : Usize) (value : T) (ls : AList T) :
  Result (Bool × (AList T))
  :=
  HashMap.insert_in_list_loop key value ls

/- [hashmap::{hashmap::HashMap<T>}::insert_no_resize]:
   Source: 'tests/src/hashmap.rs', lines 131:4-139:5 -/
def HashMap.insert_no_resize
  {T : Type} (self : HashMap T) (key : Usize) (value : T) :
  Result (HashMap T)
  :=
  do
  let hash ← hash_key key
  let i := alloc.vec.Vec.len self.slots
  let hash_mod ← hash % i
  let (a, index_mut_back) ←
    alloc.vec.Vec.index_mut (core.slice.index.SliceIndexUsizeSliceTInst (AList
      T)) self.slots hash_mod
  let (inserted, a1) ← HashMap.insert_in_list key value a
  if inserted
  then
    do
    let i1 ← self.num_entries + 1#usize
    let v ← index_mut_back a1
    Result.ok { self with num_entries := i1, slots := v }
  else do
       let v ← index_mut_back a1
       Result.ok { self with slots := v }

/- [hashmap::{hashmap::HashMap<T>}::move_elements_from_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 197:12-204:17 -/
divergent def HashMap.move_elements_from_list_loop
  {T : Type} (ntable : HashMap T) (ls : AList T) : Result (HashMap T) :=
  match ls with
  | AList.Cons k v tl =>
    do
    let ntable1 ← HashMap.insert_no_resize ntable k v
    HashMap.move_elements_from_list_loop ntable1 tl
  | AList.Nil => Result.ok ntable

/- [hashmap::{hashmap::HashMap<T>}::move_elements_from_list]:
   Source: 'tests/src/hashmap.rs', lines 194:4-207:5 -/
@[reducible]
def HashMap.move_elements_from_list
  {T : Type} (ntable : HashMap T) (ls : AList T) : Result (HashMap T) :=
  HashMap.move_elements_from_list_loop ntable ls

/- [hashmap::{hashmap::HashMap<T>}::move_elements]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 183:8-190:9 -/
divergent def HashMap.move_elements_loop
  {T : Type} (ntable : HashMap T) (slots : alloc.vec.Vec (AList T)) (i : Usize)
  :
  Result ((HashMap T) × (alloc.vec.Vec (AList T)))
  :=
  let i1 := alloc.vec.Vec.len slots
  if i < i1
  then
    do
    let (a, index_mut_back) ←
      alloc.vec.Vec.index_mut (core.slice.index.SliceIndexUsizeSliceTInst
        (AList T)) slots i
    let (ls, a1) := core.mem.replace a AList.Nil
    let ntable1 ← HashMap.move_elements_from_list ntable ls
    let i2 ← i + 1#usize
    let slots1 ← index_mut_back a1
    HashMap.move_elements_loop ntable1 slots1 i2
  else Result.ok (ntable, slots)

/- [hashmap::{hashmap::HashMap<T>}::move_elements]:
   Source: 'tests/src/hashmap.rs', lines 181:4-191:5 -/
def HashMap.move_elements
  {T : Type} (ntable : HashMap T) (slots : alloc.vec.Vec (AList T)) :
  Result ((HashMap T) × (alloc.vec.Vec (AList T)))
  :=
  HashMap.move_elements_loop ntable slots 0#usize

/- [hashmap::{hashmap::HashMap<T>}::try_resize]:
   Source: 'tests/src/hashmap.rs', lines 154:4-177:5 -/
def HashMap.try_resize {T : Type} (self : HashMap T) : Result (HashMap T) :=
  do
  let capacity := alloc.vec.Vec.len self.slots
  let n1 ← core_usize_max / 2#usize
  let (i, i1) := self.max_load_factor
  let i2 ← n1 / i
  if capacity <= i2
  then
    do
    let i3 ← capacity * 2#usize
    let ntable ← HashMap.new_with_capacity T i3 i i1
    let p ← HashMap.move_elements ntable self.slots
    let (ntable1, _) := p
    Result.ok
      { self with max_load := ntable1.max_load, slots := ntable1.slots }
  else Result.ok { self with saturated := true }

/- [hashmap::{hashmap::HashMap<T>}::insert]:
   Source: 'tests/src/hashmap.rs', lines 143:4-150:5 -/
def HashMap.insert
  {T : Type} (self : HashMap T) (key : Usize) (value : T) :
  Result (HashMap T)
  :=
  do
  let self1 ← HashMap.insert_no_resize self key value
  let i ← HashMap.len self1
  if i > self1.max_load
  then if self1.saturated
       then Result.ok self1
       else HashMap.try_resize self1
  else Result.ok self1

/- [hashmap::{hashmap::HashMap<T>}::contains_key_in_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 1:0-229:9 -/
divergent def HashMap.contains_key_in_list_loop
  {T : Type} (key : Usize) (ls : AList T) : Result Bool :=
  match ls with
  | AList.Cons ckey _ tl =>
    if ckey = key
    then Result.ok true
    else HashMap.contains_key_in_list_loop key tl
  | AList.Nil => Result.ok false

/- [hashmap::{hashmap::HashMap<T>}::contains_key_in_list]:
   Source: 'tests/src/hashmap.rs', lines 217:4-230:5 -/
@[reducible]
def HashMap.contains_key_in_list
  {T : Type} (key : Usize) (ls : AList T) : Result Bool :=
  HashMap.contains_key_in_list_loop key ls

/- [hashmap::{hashmap::HashMap<T>}::contains_key]:
   Source: 'tests/src/hashmap.rs', lines 210:4-214:5 -/
def HashMap.contains_key
  {T : Type} (self : HashMap T) (key : Usize) : Result Bool :=
  do
  let hash ← hash_key key
  let i := alloc.vec.Vec.len self.slots
  let hash_mod ← hash % i
  let a ←
    alloc.vec.Vec.index (core.slice.index.SliceIndexUsizeSliceTInst (AList T))
      self.slots hash_mod
  HashMap.contains_key_in_list key a

/- [hashmap::{hashmap::HashMap<T>}::get_in_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 236:8-248:5 -/
divergent def HashMap.get_in_list_loop
  {T : Type} (key : Usize) (ls : AList T) : Result T :=
  match ls with
  | AList.Cons ckey cvalue tl =>
    if ckey = key
    then Result.ok cvalue
    else HashMap.get_in_list_loop key tl
  | AList.Nil => Result.fail .panic

/- [hashmap::{hashmap::HashMap<T>}::get_in_list]:
   Source: 'tests/src/hashmap.rs', lines 235:4-248:5 -/
@[reducible]
def HashMap.get_in_list {T : Type} (key : Usize) (ls : AList T) : Result T :=
  HashMap.get_in_list_loop key ls

/- [hashmap::{hashmap::HashMap<T>}::get]:
   Source: 'tests/src/hashmap.rs', lines 250:4-254:5 -/
def HashMap.get {T : Type} (self : HashMap T) (key : Usize) : Result T :=
  do
  let hash ← hash_key key
  let i := alloc.vec.Vec.len self.slots
  let hash_mod ← hash % i
  let a ←
    alloc.vec.Vec.index (core.slice.index.SliceIndexUsizeSliceTInst (AList T))
      self.slots hash_mod
  HashMap.get_in_list key a

/- [hashmap::{hashmap::HashMap<T>}::get_mut_in_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 257:8-265:5 -/
divergent def HashMap.get_mut_in_list_loop
  {T : Type} (ls : AList T) (key : Usize) :
  Result (T × (T → Result (AList T)))
  :=
  match ls with
  | AList.Cons ckey cvalue tl =>
    if ckey = key
    then
      let back := fun ret => Result.ok (AList.Cons ckey ret tl)
      Result.ok (cvalue, back)
    else
      do
      let (t, back) ← HashMap.get_mut_in_list_loop tl key
      let back1 :=
        fun ret =>
          do
          let tl1 ← back ret
          Result.ok (AList.Cons ckey cvalue tl1)
      Result.ok (t, back1)
  | AList.Nil => Result.fail .panic

/- [hashmap::{hashmap::HashMap<T>}::get_mut_in_list]:
   Source: 'tests/src/hashmap.rs', lines 256:4-265:5 -/
@[reducible]
def HashMap.get_mut_in_list
  {T : Type} (ls : AList T) (key : Usize) :
  Result (T × (T → Result (AList T)))
  :=
  HashMap.get_mut_in_list_loop ls key

/- [hashmap::{hashmap::HashMap<T>}::get_mut]:
   Source: 'tests/src/hashmap.rs', lines 268:4-272:5 -/
def HashMap.get_mut
  {T : Type} (self : HashMap T) (key : Usize) :
  Result (T × (T → Result (HashMap T)))
  :=
  do
  let hash ← hash_key key
  let i := alloc.vec.Vec.len self.slots
  let hash_mod ← hash % i
  let (a, index_mut_back) ←
    alloc.vec.Vec.index_mut (core.slice.index.SliceIndexUsizeSliceTInst (AList
      T)) self.slots hash_mod
  let (t, get_mut_in_list_back) ← HashMap.get_mut_in_list a key
  let back :=
    fun ret =>
      do
      let a1 ← get_mut_in_list_back ret
      let v ← index_mut_back a1
      Result.ok { self with slots := v }
  Result.ok (t, back)

/- [hashmap::{hashmap::HashMap<T>}::remove_from_list]: loop 0:
   Source: 'tests/src/hashmap.rs', lines 1:0-299:17 -/
divergent def HashMap.remove_from_list_loop
  {T : Type} (key : Usize) (ls : AList T) : Result ((Option T) × (AList T)) :=
  match ls with
  | AList.Cons ckey t tl =>
    if ckey = key
    then
      let (mv_ls, _) := core.mem.replace ls AList.Nil
      match mv_ls with
      | AList.Cons _ cvalue tl1 => Result.ok (some cvalue, tl1)
      | AList.Nil => Result.fail .panic
    else
      do
      let (o, tl1) ← HashMap.remove_from_list_loop key tl
      Result.ok (o, AList.Cons ckey t tl1)
  | AList.Nil => Result.ok (none, AList.Nil)

/- [hashmap::{hashmap::HashMap<T>}::remove_from_list]:
   Source: 'tests/src/hashmap.rs', lines 276:4-302:5 -/
@[reducible]
def HashMap.remove_from_list
  {T : Type} (key : Usize) (ls : AList T) : Result ((Option T) × (AList T)) :=
  HashMap.remove_from_list_loop key ls

/- [hashmap::{hashmap::HashMap<T>}::remove]:
   Source: 'tests/src/hashmap.rs', lines 305:4-317:5 -/
def HashMap.remove
  {T : Type} (self : HashMap T) (key : Usize) :
  Result ((Option T) × (HashMap T))
  :=
  do
  let hash ← hash_key key
  let i := alloc.vec.Vec.len self.slots
  let hash_mod ← hash % i
  let (a, index_mut_back) ←
    alloc.vec.Vec.index_mut (core.slice.index.SliceIndexUsizeSliceTInst (AList
      T)) self.slots hash_mod
  let (x, a1) ← HashMap.remove_from_list key a
  match x with
  | none =>
    do
    let v ← index_mut_back a1
    Result.ok (none, { self with slots := v })
  | some x1 =>
    do
    let i1 ← self.num_entries - 1#usize
    let v ← index_mut_back a1
    Result.ok (x, { self with num_entries := i1, slots := v })

/- [hashmap::insert_on_disk]:
   Source: 'tests/src/hashmap.rs', lines 336:0-343:1 -/
def insert_on_disk
  (key : Usize) (value : U64) (st : State) : Result (State × Unit) :=
  do
  let (st1, hm) ← utils.deserialize st
  let hm1 ← HashMap.insert hm key value
  utils.serialize hm1 st1

/- [hashmap::test1]:
   Source: 'tests/src/hashmap.rs', lines 351:0-383:1 -/
def test1 : Result Unit :=
  do
  let hm ← HashMap.new U64
  let hm1 ← HashMap.insert hm 0#usize 42#u64
  let hm2 ← HashMap.insert hm1 128#usize 18#u64
  let hm3 ← HashMap.insert hm2 1024#usize 138#u64
  let hm4 ← HashMap.insert hm3 1056#usize 256#u64
  let i ← HashMap.get hm4 128#usize
  if i = 18#u64
  then
    do
    let (_, get_mut_back) ← HashMap.get_mut hm4 1024#usize
    let hm5 ← get_mut_back 56#u64
    let i1 ← HashMap.get hm5 1024#usize
    if i1 = 56#u64
    then
      do
      let (x, hm6) ← HashMap.remove hm5 1024#usize
      match x with
      | none => Result.fail .panic
      | some x1 =>
        if x1 = 56#u64
        then
          do
          let i2 ← HashMap.get hm6 0#usize
          if i2 = 42#u64
          then
            do
            let i3 ← HashMap.get hm6 128#usize
            if i3 = 18#u64
            then
              do
              let i4 ← HashMap.get hm6 1056#usize
              if i4 = 256#u64
              then Result.ok ()
              else Result.fail .panic
            else Result.fail .panic
          else Result.fail .panic
        else Result.fail .panic
    else Result.fail .panic
  else Result.fail .panic

end hashmap
