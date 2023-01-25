-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [hashmap_main]: function definitions
import Base.Primitives
import HashmapMain.Types
import HashmapMain.Opaque

/- [hashmap_main::hashmap::hash_key] -/
def hashmap_hash_key_fwd (k : USize) : result USize := result.ret k

/- [hashmap_main::hashmap::HashMap::{0}::allocate_slots] -/
def hashmap_hash_map_allocate_slots_loop_fwd
  (T : Type) (slots : vec (hashmap_list_t T)) (n : USize) :
  result (vec (hashmap_list_t T))
  :=
  if n > (USize.ofNatCore 0 (by intlit))
  then
    do
      let slots0 <-
        vec_push_back (hashmap_list_t T) slots hashmap_list_t.HashmapListNil 
      let n0 <- USize.checked_sub n (USize.ofNatCore 1 (by intlit)) 
      hashmap_hash_map_allocate_slots_loop_fwd T slots0 n0
  else result.ret slots

/- [hashmap_main::hashmap::HashMap::{0}::allocate_slots] -/
def hashmap_hash_map_allocate_slots_fwd
  (T : Type) (slots : vec (hashmap_list_t T)) (n : USize) :
  result (vec (hashmap_list_t T))
  :=
  hashmap_hash_map_allocate_slots_loop_fwd T slots n

/- [hashmap_main::hashmap::HashMap::{0}::new_with_capacity] -/
def hashmap_hash_map_new_with_capacity_fwd
  (T : Type) (capacity : USize) (max_load_dividend : USize)
  (max_load_divisor : USize) :
  result (hashmap_hash_map_t T)
  :=
  do
    let v := vec_new (hashmap_list_t T) 
    let slots <- hashmap_hash_map_allocate_slots_fwd T v capacity 
    let i <- USize.checked_mul capacity max_load_dividend 
    let i0 <- USize.checked_div i max_load_divisor 
    result.ret (mkhashmap_hash_map_t (USize.ofNatCore 0 (by intlit))
      (max_load_dividend, max_load_divisor) i0 slots)

/- [hashmap_main::hashmap::HashMap::{0}::new] -/
def hashmap_hash_map_new_fwd (T : Type) : result (hashmap_hash_map_t T) :=
  hashmap_hash_map_new_with_capacity_fwd T (USize.ofNatCore 32 (by intlit))
    (USize.ofNatCore 4 (by intlit)) (USize.ofNatCore 5 (by intlit))

/- [hashmap_main::hashmap::HashMap::{0}::clear_slots] -/
def hashmap_hash_map_clear_slots_loop_fwd_back
  (T : Type) (slots : vec (hashmap_list_t T)) (i : USize) :
  result (vec (hashmap_list_t T))
  :=
  let i0 := vec_len (hashmap_list_t T) slots 
  if i < i0
  then
    do
      let i1 <- USize.checked_add i (USize.ofNatCore 1 (by intlit)) 
      let slots0 <-
        vec_index_mut_back (hashmap_list_t T) slots i
          hashmap_list_t.HashmapListNil 
      hashmap_hash_map_clear_slots_loop_fwd_back T slots0 i1
  else result.ret slots

/- [hashmap_main::hashmap::HashMap::{0}::clear_slots] -/
def hashmap_hash_map_clear_slots_fwd_back
  (T : Type) (slots : vec (hashmap_list_t T)) :
  result (vec (hashmap_list_t T))
  :=
  hashmap_hash_map_clear_slots_loop_fwd_back T slots
    (USize.ofNatCore 0 (by intlit))

/- [hashmap_main::hashmap::HashMap::{0}::clear] -/
def hashmap_hash_map_clear_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) : result (hashmap_hash_map_t T) :=
  do
    let v <-
      hashmap_hash_map_clear_slots_fwd_back T self.hashmap_hash_map_slots 
    result.ret (mkhashmap_hash_map_t (USize.ofNatCore 0 (by intlit))
      self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v)

/- [hashmap_main::hashmap::HashMap::{0}::len] -/
def hashmap_hash_map_len_fwd
  (T : Type) (self : hashmap_hash_map_t T) : result USize :=
  result.ret self.hashmap_hash_map_num_entries

/- [hashmap_main::hashmap::HashMap::{0}::insert_in_list] -/
def hashmap_hash_map_insert_in_list_loop_fwd
  (T : Type) (key : USize) (value : T) (ls : hashmap_list_t T) : result Bool :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey cvalue tl =>
    if ckey = key
    then result.ret false
    else hashmap_hash_map_insert_in_list_loop_fwd T key value tl
  | hashmap_list_t.HashmapListNil => result.ret true
  

/- [hashmap_main::hashmap::HashMap::{0}::insert_in_list] -/
def hashmap_hash_map_insert_in_list_fwd
  (T : Type) (key : USize) (value : T) (ls : hashmap_list_t T) : result Bool :=
  hashmap_hash_map_insert_in_list_loop_fwd T key value ls

/- [hashmap_main::hashmap::HashMap::{0}::insert_in_list] -/
def hashmap_hash_map_insert_in_list_loop_back
  (T : Type) (key : USize) (value : T) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey cvalue tl =>
    if ckey = key
    then result.ret (hashmap_list_t.HashmapListCons ckey value tl)
    else
      do
        let l <- hashmap_hash_map_insert_in_list_loop_back T key value tl 
        result.ret (hashmap_list_t.HashmapListCons ckey cvalue l)
  | hashmap_list_t.HashmapListNil =>
    let l := hashmap_list_t.HashmapListNil 
    result.ret (hashmap_list_t.HashmapListCons key value l)
  

/- [hashmap_main::hashmap::HashMap::{0}::insert_in_list] -/
def hashmap_hash_map_insert_in_list_back
  (T : Type) (key : USize) (value : T) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  hashmap_hash_map_insert_in_list_loop_back T key value ls

/- [hashmap_main::hashmap::HashMap::{0}::insert_no_resize] -/
def hashmap_hash_map_insert_no_resize_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) (value : T) :
  result (hashmap_hash_map_t T)
  :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    let inserted <- hashmap_hash_map_insert_in_list_fwd T key value l 
    if inserted
    then
      do
        let i0 <- USize.checked_add self.hashmap_hash_map_num_entries
          (USize.ofNatCore 1 (by intlit)) 
        let l0 <- hashmap_hash_map_insert_in_list_back T key value l 
        let v <-
          vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
            hash_mod l0 
        result.ret (mkhashmap_hash_map_t i0
          self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load
          v)
    else
      do
        let l0 <- hashmap_hash_map_insert_in_list_back T key value l 
        let v <-
          vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
            hash_mod l0 
        result.ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
          self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load
          v)

/- [core::num::u32::{9}::MAX] -/
def core_num_u32_max_body : result UInt32 :=
  result.ret (UInt32.ofNatCore 4294967295 (by intlit))
def core_num_u32_max_c : UInt32 := eval_global core_num_u32_max_body (by simp)

/- [hashmap_main::hashmap::HashMap::{0}::move_elements_from_list] -/
def hashmap_hash_map_move_elements_from_list_loop_fwd_back
  (T : Type) (ntable : hashmap_hash_map_t T) (ls : hashmap_list_t T) :
  result (hashmap_hash_map_t T)
  :=
  match ls with
  | hashmap_list_t.HashmapListCons k v tl =>
    do
      let ntable0 <- hashmap_hash_map_insert_no_resize_fwd_back T ntable k v 
      hashmap_hash_map_move_elements_from_list_loop_fwd_back T ntable0 tl
  | hashmap_list_t.HashmapListNil => result.ret ntable
  

/- [hashmap_main::hashmap::HashMap::{0}::move_elements_from_list] -/
def hashmap_hash_map_move_elements_from_list_fwd_back
  (T : Type) (ntable : hashmap_hash_map_t T) (ls : hashmap_list_t T) :
  result (hashmap_hash_map_t T)
  :=
  hashmap_hash_map_move_elements_from_list_loop_fwd_back T ntable ls

/- [hashmap_main::hashmap::HashMap::{0}::move_elements] -/
def hashmap_hash_map_move_elements_loop_fwd_back
  (T : Type) (ntable : hashmap_hash_map_t T) (slots : vec (hashmap_list_t T))
  (i : USize) :
  result ((hashmap_hash_map_t T) × (vec (hashmap_list_t T)))
  :=
  let i0 := vec_len (hashmap_list_t T) slots 
  if i < i0
  then
    do
      let l <- vec_index_mut_fwd (hashmap_list_t T) slots i 
      let ls :=
        mem_replace_fwd (hashmap_list_t T) l hashmap_list_t.HashmapListNil 
      let ntable0 <-
        hashmap_hash_map_move_elements_from_list_fwd_back T ntable ls 
      let i1 <- USize.checked_add i (USize.ofNatCore 1 (by intlit)) 
      let l0 :=
        mem_replace_back (hashmap_list_t T) l hashmap_list_t.HashmapListNil 
      let slots0 <- vec_index_mut_back (hashmap_list_t T) slots i l0 
      hashmap_hash_map_move_elements_loop_fwd_back T ntable0 slots0 i1
  else result.ret (ntable, slots)

/- [hashmap_main::hashmap::HashMap::{0}::move_elements] -/
def hashmap_hash_map_move_elements_fwd_back
  (T : Type) (ntable : hashmap_hash_map_t T) (slots : vec (hashmap_list_t T))
  (i : USize) :
  result ((hashmap_hash_map_t T) × (vec (hashmap_list_t T)))
  :=
  hashmap_hash_map_move_elements_loop_fwd_back T ntable slots i

/- [hashmap_main::hashmap::HashMap::{0}::try_resize] -/
def hashmap_hash_map_try_resize_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) : result (hashmap_hash_map_t T) :=
  do
    let max_usize <- scalar_cast U32 Usize core_num_u32_max_c 
    let capacity := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let n1 <- USize.checked_div max_usize (USize.ofNatCore 2 (by intlit)) 
    let (i, i0) := self.hashmap_hash_map_max_load_factor 
    let i1 <- USize.checked_div n1 i 
    if capacity <= i1
    then
      do
        let i2 <- USize.checked_mul capacity (USize.ofNatCore 2 (by intlit)) 
        let ntable <- hashmap_hash_map_new_with_capacity_fwd T i2 i i0 
        let (ntable0, _) <-
          hashmap_hash_map_move_elements_fwd_back T ntable
            self.hashmap_hash_map_slots (USize.ofNatCore 0 (by intlit)) 
        result.ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries (i,
          i0) ntable0.hashmap_hash_map_max_load ntable0.hashmap_hash_map_slots)
    else
      result.ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries (i,
        i0) self.hashmap_hash_map_max_load self.hashmap_hash_map_slots)

/- [hashmap_main::hashmap::HashMap::{0}::insert] -/
def hashmap_hash_map_insert_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) (value : T) :
  result (hashmap_hash_map_t T)
  :=
  do
    let self0 <- hashmap_hash_map_insert_no_resize_fwd_back T self key value 
    let i <- hashmap_hash_map_len_fwd T self0 
    if i > self0.hashmap_hash_map_max_load
    then hashmap_hash_map_try_resize_fwd_back T self0
    else result.ret self0

/- [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] -/
def hashmap_hash_map_contains_key_in_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result Bool :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey t tl =>
    if ckey = key
    then result.ret true
    else hashmap_hash_map_contains_key_in_list_loop_fwd T key tl
  | hashmap_list_t.HashmapListNil => result.ret false
  

/- [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] -/
def hashmap_hash_map_contains_key_in_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result Bool :=
  hashmap_hash_map_contains_key_in_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::contains_key] -/
def hashmap_hash_map_contains_key_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result Bool :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    hashmap_hash_map_contains_key_in_list_fwd T key l

/- [hashmap_main::hashmap::HashMap::{0}::get_in_list] -/
def hashmap_hash_map_get_in_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result T :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey cvalue tl =>
    if ckey = key
    then result.ret cvalue
    else hashmap_hash_map_get_in_list_loop_fwd T key tl
  | hashmap_list_t.HashmapListNil => result.fail error.panic
  

/- [hashmap_main::hashmap::HashMap::{0}::get_in_list] -/
def hashmap_hash_map_get_in_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result T :=
  hashmap_hash_map_get_in_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::get] -/
def hashmap_hash_map_get_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result T :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    hashmap_hash_map_get_in_list_fwd T key l

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_loop_fwd
  (T : Type) (ls : hashmap_list_t T) (key : USize) : result T :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey cvalue tl =>
    if ckey = key
    then result.ret cvalue
    else hashmap_hash_map_get_mut_in_list_loop_fwd T tl key
  | hashmap_list_t.HashmapListNil => result.fail error.panic
  

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_fwd
  (T : Type) (ls : hashmap_list_t T) (key : USize) : result T :=
  hashmap_hash_map_get_mut_in_list_loop_fwd T ls key

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_loop_back
  (T : Type) (ls : hashmap_list_t T) (key : USize) (ret0 : T) :
  result (hashmap_list_t T)
  :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey cvalue tl =>
    if ckey = key
    then result.ret (hashmap_list_t.HashmapListCons ckey ret0 tl)
    else
      do
        let l <- hashmap_hash_map_get_mut_in_list_loop_back T tl key ret0 
        result.ret (hashmap_list_t.HashmapListCons ckey cvalue l)
  | hashmap_list_t.HashmapListNil => result.fail error.panic
  

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_back
  (T : Type) (ls : hashmap_list_t T) (key : USize) (ret0 : T) :
  result (hashmap_list_t T)
  :=
  hashmap_hash_map_get_mut_in_list_loop_back T ls key ret0

/- [hashmap_main::hashmap::HashMap::{0}::get_mut] -/
def hashmap_hash_map_get_mut_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result T :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    hashmap_hash_map_get_mut_in_list_fwd T l key

/- [hashmap_main::hashmap::HashMap::{0}::get_mut] -/
def hashmap_hash_map_get_mut_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) (ret0 : T) :
  result (hashmap_hash_map_t T)
  :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    let l0 <- hashmap_hash_map_get_mut_in_list_back T l key ret0 
    let v <-
      vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
        hash_mod l0 
    result.ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
      self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v)

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result (Option T) :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls :=
        mem_replace_fwd (hashmap_list_t T) (hashmap_list_t.HashmapListCons ckey
          t tl) hashmap_list_t.HashmapListNil 
      match mv_ls with
      | hashmap_list_t.HashmapListCons i cvalue tl0 =>
        result.ret (Option.some cvalue)
      | hashmap_list_t.HashmapListNil => result.fail error.panic
      
    else hashmap_hash_map_remove_from_list_loop_fwd T key tl
  | hashmap_list_t.HashmapListNil => result.ret Option.none
  

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result (Option T) :=
  hashmap_hash_map_remove_from_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_loop_back
  (T : Type) (key : USize) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  match ls with
  | hashmap_list_t.HashmapListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls :=
        mem_replace_fwd (hashmap_list_t T) (hashmap_list_t.HashmapListCons ckey
          t tl) hashmap_list_t.HashmapListNil 
      match mv_ls with
      | hashmap_list_t.HashmapListCons i cvalue tl0 => result.ret tl0
      | hashmap_list_t.HashmapListNil => result.fail error.panic
      
    else
      do
        let l <- hashmap_hash_map_remove_from_list_loop_back T key tl 
        result.ret (hashmap_list_t.HashmapListCons ckey t l)
  | hashmap_list_t.HashmapListNil => result.ret hashmap_list_t.HashmapListNil
  

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_back
  (T : Type) (key : USize) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  hashmap_hash_map_remove_from_list_loop_back T key ls

/- [hashmap_main::hashmap::HashMap::{0}::remove] -/
def hashmap_hash_map_remove_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result (Option T) :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    let x <- hashmap_hash_map_remove_from_list_fwd T key l 
    match x with
    | Option.none => result.ret Option.none
    | Option.some x0 =>
      do
        let _ <- USize.checked_sub self.hashmap_hash_map_num_entries
          (USize.ofNatCore 1 (by intlit)) 
        result.ret (Option.some x0)
    

/- [hashmap_main::hashmap::HashMap::{0}::remove] -/
def hashmap_hash_map_remove_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) :
  result (hashmap_hash_map_t T)
  :=
  do
    let hash <- hashmap_hash_key_fwd key 
    let i := vec_len (hashmap_list_t T) self.hashmap_hash_map_slots 
    let hash_mod <- USize.checked_rem hash i 
    let l <-
      vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod 
    let x <- hashmap_hash_map_remove_from_list_fwd T key l 
    match x with
    | Option.none =>
      do
        let l0 <- hashmap_hash_map_remove_from_list_back T key l 
        let v <-
          vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
            hash_mod l0 
        result.ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
          self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load
          v)
    | Option.some x0 =>
      do
        let i0 <- USize.checked_sub self.hashmap_hash_map_num_entries
          (USize.ofNatCore 1 (by intlit)) 
        let l0 <- hashmap_hash_map_remove_from_list_back T key l 
        let v <-
          vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
            hash_mod l0 
        result.ret (mkhashmap_hash_map_t i0
          self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load
          v)
    

/- [hashmap_main::hashmap::test1] -/
def hashmap_test1_fwd : result Unit :=
  do
    let hm <- hashmap_hash_map_new_fwd UInt64 
    let hm0 <-
      hashmap_hash_map_insert_fwd_back UInt64 hm
        (USize.ofNatCore 0 (by intlit)) (UInt64.ofNatCore 42 (by intlit)) 
    let hm1 <-
      hashmap_hash_map_insert_fwd_back UInt64 hm0
        (USize.ofNatCore 128 (by intlit)) (UInt64.ofNatCore 18 (by intlit)) 
    let hm2 <-
      hashmap_hash_map_insert_fwd_back UInt64 hm1
        (USize.ofNatCore 1024 (by intlit)) (UInt64.ofNatCore 138 (by intlit)) 
    let hm3 <-
      hashmap_hash_map_insert_fwd_back UInt64 hm2
        (USize.ofNatCore 1056 (by intlit)) (UInt64.ofNatCore 256 (by intlit)) 
    let i <-
      hashmap_hash_map_get_fwd UInt64 hm3 (USize.ofNatCore 128 (by intlit)) 
    if not (i = (UInt64.ofNatCore 18 (by intlit)))
    then result.fail error.panic
    else
      do
        let hm4 <-
          hashmap_hash_map_get_mut_back UInt64 hm3
            (USize.ofNatCore 1024 (by intlit))
            (UInt64.ofNatCore 56 (by intlit)) 
        let i0 <-
          hashmap_hash_map_get_fwd UInt64 hm4
            (USize.ofNatCore 1024 (by intlit)) 
        if not (i0 = (UInt64.ofNatCore 56 (by intlit)))
        then result.fail error.panic
        else
          do
            let x <-
              hashmap_hash_map_remove_fwd UInt64 hm4
                (USize.ofNatCore 1024 (by intlit)) 
            match x with
            | Option.none => result.fail error.panic
            | Option.some x0 =>
              if not (x0 = (UInt64.ofNatCore 56 (by intlit)))
              then result.fail error.panic
              else
                do
                  let hm5 <-
                    hashmap_hash_map_remove_back UInt64 hm4
                      (USize.ofNatCore 1024 (by intlit)) 
                  let i1 <-
                    hashmap_hash_map_get_fwd UInt64 hm5
                      (USize.ofNatCore 0 (by intlit)) 
                  if not (i1 = (UInt64.ofNatCore 42 (by intlit)))
                  then result.fail error.panic
                  else
                    do
                      let i2 <-
                        hashmap_hash_map_get_fwd UInt64 hm5
                          (USize.ofNatCore 128 (by intlit)) 
                      if not (i2 = (UInt64.ofNatCore 18 (by intlit)))
                      then result.fail error.panic
                      else
                        do
                          let i3 <-
                            hashmap_hash_map_get_fwd UInt64 hm5
                              (USize.ofNatCore 1056 (by intlit)) 
                          if not (i3 = (UInt64.ofNatCore 256 (by intlit)))
                          then result.fail error.panic
                          else result.ret ()
            

/- Unit test for [hashmap_main::hashmap::test1] -/
#assert (hashmap_test1_fwd = ret ())

/- [hashmap_main::insert_on_disk] -/
def insert_on_disk_fwd
  (key : USize) (value : UInt64) (st : state) : result (state × Unit) :=
  do
    let (st0, hm) <- hashmap_utils_deserialize_fwd st 
    let hm0 <- hashmap_hash_map_insert_fwd_back UInt64 hm key value 
    let (st1, _) <- hashmap_utils_serialize_fwd hm0 st0 
    result.ret (st1, ())

/- [hashmap_main::main] -/
def main_fwd : result Unit := result.ret ()

/- Unit test for [hashmap_main::main] -/
#assert (main_fwd = ret ())

