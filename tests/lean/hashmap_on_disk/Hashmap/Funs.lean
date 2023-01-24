-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [hashmap_main]: function definitions
import Hashmap.Primitives
import Hashmap.Opaque
import Hashmap.Types

open result
open hashmap_list_t

/- [hashmap_main::hashmap::hash_key] -/
def hashmap_hash_key_fwd (k : USize) : result USize := ret k

/- [hashmap_main::hashmap::HashMap::{0}::allocate_slots] -/
def hashmap_hash_map_allocate_slots_loop_fwd
  (T : Type) (slots : vec (hashmap_list_t T)) (n : USize) :
  result (vec (hashmap_list_t T))
  :=
  if n > (USize.ofNatCore 0 (by intlit))
  then do
    let slots0: vec (hashmap_list_t T) <- @vec_push_back (hashmap_list_t T) slots HashmapListNil
    let n0 <- USize.checked_sub n (USize.ofNatCore 1 (by intlit))
    hashmap_hash_map_allocate_slots_loop_fwd T slots0 n0
  else ret slots
termination_by hashmap_hash_map_allocate_slots_loop_fwd _ _ n => n
decreasing_by sorry

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
  let v <- vec_new (hashmap_list_t T) in
  let slots <- hashmap_hash_map_allocate_slots_fwd T v capacity in
  let i <- USize.checked_mul capacity max_load_dividend in
  let i0 <- USize.checked_div i max_load_divisor in
  ret (mkhashmap_hash_map_t (USize.ofNatCore 0 (by simp)) (max_load_dividend,
    max_load_divisor) i0 slots)

/- [hashmap_main::hashmap::HashMap::{0}::new] -/
def hashmap_hash_map_new_fwd (T : Type) : result (hashmap_hash_map_t T) :=
  hashmap_hash_map_new_with_capacity_fwd T (USize.ofNatCore 32 (by simp))
    (USize.ofNatCore 4 (by simp)) (USize.ofNatCore 5 (by simp))

/- [hashmap_main::hashmap::HashMap::{0}::clear_slots] -/
def hashmap_hash_map_clear_slots_loop_fwd_back
  (T : Type) (slots : vec (hashmap_list_t T)) (i : USize) :
  result (vec (hashmap_list_t T))
  :=
  let i0 <- vec_len (hashmap_list_t T) slots in
  if i < i0
  then (
    let i1 <- USize.checked_add i (USize.ofNatCore 1 (by simp)) in
    let slots0 <- vec_index_mut_back (hashmap_list_t T) slots i HashmapListNil
      in
    hashmap_hash_map_clear_slots_loop_fwd_back T slots0 i1)
  else ret slots

/- [hashmap_main::hashmap::HashMap::{0}::clear_slots] -/
def hashmap_hash_map_clear_slots_fwd_back
  (T : Type) (slots : vec (hashmap_list_t T)) :
  result (vec (hashmap_list_t T))
  :=
  hashmap_hash_map_clear_slots_loop_fwd_back T slots
    (USize.ofNatCore 0 (by simp))

/- [hashmap_main::hashmap::HashMap::{0}::clear] -/
def hashmap_hash_map_clear_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) : result (hashmap_hash_map_t T) :=
  let v <- hashmap_hash_map_clear_slots_fwd_back T self.hashmap_hash_map_slots
    in
  ret (mkhashmap_hash_map_t (USize.ofNatCore 0 (by simp))
    self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v)

/- [hashmap_main::hashmap::HashMap::{0}::len] -/
def hashmap_hash_map_len_fwd
  (T : Type) (self : hashmap_hash_map_t T) : result USize :=
  ret self.hashmap_hash_map_num_entries

/- [hashmap_main::hashmap::HashMap::{0}::insert_in_list] -/
def hashmap_hash_map_insert_in_list_loop_fwd
  (T : Type) (key : USize) (value : T) (ls : hashmap_list_t T) : result Bool :=
  match ls with
  | HashmapListCons ckey cvalue tl =>
    if ckey = key
    then ret false
    else hashmap_hash_map_insert_in_list_loop_fwd T key value tl
  | HashmapListNil => ret true
  end

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
  | HashmapListCons ckey cvalue tl =>
    if ckey = key
    then ret (HashmapListCons ckey value tl)
    else (
      let l <- hashmap_hash_map_insert_in_list_loop_back T key value tl in
      ret (HashmapListCons ckey cvalue l))
  | HashmapListNil =>
    let l <- HashmapListNil in ret (HashmapListCons key value l)
  end

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
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
    in
  let inserted <- hashmap_hash_map_insert_in_list_fwd T key value l in
  if inserted
  then (
    let i0 <- USize.checked_add self.hashmap_hash_map_num_entries
      (USize.ofNatCore 1 (by simp)) in
    let l0 <- hashmap_hash_map_insert_in_list_back T key value l in
    let v <-
      vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
        hash_mod l0 in
    ret (mkhashmap_hash_map_t i0 self.hashmap_hash_map_max_load_factor
      self.hashmap_hash_map_max_load v))
  else (
    let l0 <- hashmap_hash_map_insert_in_list_back T key value l in
    let v <-
      vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
        hash_mod l0 in
    ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
      self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v))

/- [core::num::u32::{9}::MAX] -/
def core_num_u32_max_body : result UInt32 :=
  ret (UInt32.ofNatCore 4294967295 (by simp))
def core_num_u32_max_c : UInt32 := eval_global core_num_u32_max_body

/- [hashmap_main::hashmap::HashMap::{0}::move_elements_from_list] -/
def hashmap_hash_map_move_elements_from_list_loop_fwd_back
  (T : Type) (ntable : hashmap_hash_map_t T) (ls : hashmap_list_t T) :
  result (hashmap_hash_map_t T)
  :=
  match ls with
  | HashmapListCons k v tl =>
    let ntable0 <- hashmap_hash_map_insert_no_resize_fwd_back T ntable k v in
    hashmap_hash_map_move_elements_from_list_loop_fwd_back T ntable0 tl
  | HashmapListNil => ret ntable
  end

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
  let i0 <- vec_len (hashmap_list_t T) slots in
  if i < i0
  then (
    let l <- vec_index_mut_fwd (hashmap_list_t T) slots i in
    let ls <- mem_replace_fwd (hashmap_list_t T) l HashmapListNil in
    let ntable0 <-
      hashmap_hash_map_move_elements_from_list_fwd_back T ntable ls in
    let i1 <- USize.checked_add i (USize.ofNatCore 1 (by simp)) in
    let l0 <- mem_replace_back (hashmap_list_t T) l HashmapListNil in
    let slots0 <- vec_index_mut_back (hashmap_list_t T) slots i l0 in
    hashmap_hash_map_move_elements_loop_fwd_back T ntable0 slots0 i1)
  else ret (ntable, slots)

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
  let max_usize <- scalar_cast U32 Usize core_num_u32_max_c in
  let capacity <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let n1 <- USize.checked_div max_usize (USize.ofNatCore 2 (by simp)) in
  let (i, i0) <- self.hashmap_hash_map_max_load_factor in
  let i1 <- USize.checked_div n1 i in
  if capacity <= i1
  then (
    let i2 <- USize.checked_mul capacity (USize.ofNatCore 2 (by simp)) in
    let ntable <- hashmap_hash_map_new_with_capacity_fwd T i2 i i0 in
    let (ntable0, _) <-
      hashmap_hash_map_move_elements_fwd_back T ntable
        self.hashmap_hash_map_slots (USize.ofNatCore 0 (by simp)) in
    ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries (i, i0)
      ntable0.hashmap_hash_map_max_load ntable0.hashmap_hash_map_slots))
  else
    ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries (i, i0)
      self.hashmap_hash_map_max_load self.hashmap_hash_map_slots)

/- [hashmap_main::hashmap::HashMap::{0}::insert] -/
def hashmap_hash_map_insert_fwd_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) (value : T) :
  result (hashmap_hash_map_t T)
  :=
  let self0 <- hashmap_hash_map_insert_no_resize_fwd_back T self key value in
  let i <- hashmap_hash_map_len_fwd T self0 in
  if i > self0.hashmap_hash_map_max_load
  then hashmap_hash_map_try_resize_fwd_back T self0
  else ret self0

/- [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] -/
def hashmap_hash_map_contains_key_in_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result Bool :=
  match ls with
  | HashmapListCons ckey t tl =>
    if ckey = key
    then ret true
    else hashmap_hash_map_contains_key_in_list_loop_fwd T key tl
  | HashmapListNil => ret false
  end

/- [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] -/
def hashmap_hash_map_contains_key_in_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result Bool :=
  hashmap_hash_map_contains_key_in_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::contains_key] -/
def hashmap_hash_map_contains_key_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result Bool :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod in
  hashmap_hash_map_contains_key_in_list_fwd T key l

/- [hashmap_main::hashmap::HashMap::{0}::get_in_list] -/
def hashmap_hash_map_get_in_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result T :=
  match ls with
  | HashmapListCons ckey cvalue tl =>
    if ckey = key
    then ret cvalue
    else hashmap_hash_map_get_in_list_loop_fwd T key tl
  | HashmapListNil => fail_ panic
  end

/- [hashmap_main::hashmap::HashMap::{0}::get_in_list] -/
def hashmap_hash_map_get_in_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result T :=
  hashmap_hash_map_get_in_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::get] -/
def hashmap_hash_map_get_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result T :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod in
  hashmap_hash_map_get_in_list_fwd T key l

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_loop_fwd
  (T : Type) (ls : hashmap_list_t T) (key : USize) : result T :=
  match ls with
  | HashmapListCons ckey cvalue tl =>
    if ckey = key
    then ret cvalue
    else hashmap_hash_map_get_mut_in_list_loop_fwd T tl key
  | HashmapListNil => fail_ panic
  end

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
  | HashmapListCons ckey cvalue tl =>
    if ckey = key
    then ret (HashmapListCons ckey ret0 tl)
    else (
      let l <- hashmap_hash_map_get_mut_in_list_loop_back T tl key ret0 in
      ret (HashmapListCons ckey cvalue l))
  | HashmapListNil => fail_ panic
  end

/- [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] -/
def hashmap_hash_map_get_mut_in_list_back
  (T : Type) (ls : hashmap_list_t T) (key : USize) (ret0 : T) :
  result (hashmap_list_t T)
  :=
  hashmap_hash_map_get_mut_in_list_loop_back T ls key ret0

/- [hashmap_main::hashmap::HashMap::{0}::get_mut] -/
def hashmap_hash_map_get_mut_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result T :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
    in
  hashmap_hash_map_get_mut_in_list_fwd T l key

/- [hashmap_main::hashmap::HashMap::{0}::get_mut] -/
def hashmap_hash_map_get_mut_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) (ret0 : T) :
  result (hashmap_hash_map_t T)
  :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
    in
  let l0 <- hashmap_hash_map_get_mut_in_list_back T l key ret0 in
  let v <-
    vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
      l0 in
  ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
    self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v)

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_loop_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result (option T) :=
  match ls with
  | HashmapListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls <-
        mem_replace_fwd (hashmap_list_t T) (HashmapListCons ckey t tl)
          HashmapListNil in
      match mv_ls with
      | HashmapListCons i cvalue tl0 => ret (@some cvalue)
      | HashmapListNil => fail_ panic
      end
    else hashmap_hash_map_remove_from_list_loop_fwd T key tl
  | HashmapListNil => ret @none
  end

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_fwd
  (T : Type) (key : USize) (ls : hashmap_list_t T) : result (option T) :=
  hashmap_hash_map_remove_from_list_loop_fwd T key ls

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_loop_back
  (T : Type) (key : USize) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  match ls with
  | HashmapListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls <-
        mem_replace_fwd (hashmap_list_t T) (HashmapListCons ckey t tl)
          HashmapListNil in
      match mv_ls with
      | HashmapListCons i cvalue tl0 => ret tl0
      | HashmapListNil => fail_ panic
      end
    else (
      let l <- hashmap_hash_map_remove_from_list_loop_back T key tl in
      ret (HashmapListCons ckey t l))
  | HashmapListNil => ret HashmapListNil
  end

/- [hashmap_main::hashmap::HashMap::{0}::remove_from_list] -/
def hashmap_hash_map_remove_from_list_back
  (T : Type) (key : USize) (ls : hashmap_list_t T) :
  result (hashmap_list_t T)
  :=
  hashmap_hash_map_remove_from_list_loop_back T key ls

/- [hashmap_main::hashmap::HashMap::{0}::remove] -/
def hashmap_hash_map_remove_fwd
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) : result (option T) :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
    in
  let x <- hashmap_hash_map_remove_from_list_fwd T key l in
  match x with
  | @none => ret @none
  | @some x0 =>
    let _ <- USize.checked_sub self.hashmap_hash_map_num_entries
      (USize.ofNatCore 1 (by simp)) in
    ret (@some x0)
  end

/- [hashmap_main::hashmap::HashMap::{0}::remove] -/
def hashmap_hash_map_remove_back
  (T : Type) (self : hashmap_hash_map_t T) (key : USize) :
  result (hashmap_hash_map_t T)
  :=
  let hash <- hashmap_hash_key_fwd key in
  let i <- vec_len (hashmap_list_t T) self.hashmap_hash_map_slots in
  let hash_mod <- USize.checked_rem hash i in
  let l <-
    vec_index_mut_fwd (hashmap_list_t T) self.hashmap_hash_map_slots hash_mod
    in
  let x <- hashmap_hash_map_remove_from_list_fwd T key l in
  match x with
  | @none =>
    let l0 <- hashmap_hash_map_remove_from_list_back T key l in
    let v <-
      vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
        hash_mod l0 in
    ret (mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
      self.hashmap_hash_map_max_load_factor self.hashmap_hash_map_max_load v)
  | @some x0 =>
    let i0 <- USize.checked_sub self.hashmap_hash_map_num_entries
      (USize.ofNatCore 1 (by simp)) in
    let l0 <- hashmap_hash_map_remove_from_list_back T key l in
    let v <-
      vec_index_mut_back (hashmap_list_t T) self.hashmap_hash_map_slots
        hash_mod l0 in
    ret (mkhashmap_hash_map_t i0 self.hashmap_hash_map_max_load_factor
      self.hashmap_hash_map_max_load v)
  end

/- [hashmap_main::hashmap::test1] -/
def hashmap_test1_fwd : result unit :=
  let hm <- hashmap_hash_map_new_fwd UInt64 in
  let hm0 <-
    hashmap_hash_map_insert_fwd_back UInt64 hm (USize.ofNatCore 0 (by simp))
      (UInt64.ofNatCore 42 (by simp)) in
  let hm1 <-
    hashmap_hash_map_insert_fwd_back UInt64 hm0 (USize.ofNatCore 128 (by simp))
      (UInt64.ofNatCore 18 (by simp)) in
  let hm2 <-
    hashmap_hash_map_insert_fwd_back UInt64 hm1
      (USize.ofNatCore 1024 (by simp)) (UInt64.ofNatCore 138 (by simp)) in
  let hm3 <-
    hashmap_hash_map_insert_fwd_back UInt64 hm2
      (USize.ofNatCore 1056 (by simp)) (UInt64.ofNatCore 256 (by simp)) in
  let i <- hashmap_hash_map_get_fwd UInt64 hm3 (USize.ofNatCore 128 (by simp))
    in
  if not (i = (UInt64.ofNatCore 18 (by simp)))
  then fail_ panic
  else (
    let hm4 <-
      hashmap_hash_map_get_mut_back UInt64 hm3 (USize.ofNatCore 1024 (by simp))
        (UInt64.ofNatCore 56 (by simp)) in
    let i0 <-
      hashmap_hash_map_get_fwd UInt64 hm4 (USize.ofNatCore 1024 (by simp)) in
    if not (i0 = (UInt64.ofNatCore 56 (by simp)))
    then fail_ panic
    else (
      let x <-
        hashmap_hash_map_remove_fwd UInt64 hm4 (USize.ofNatCore 1024 (by simp))
        in
      match x with
      | @none => fail_ panic
      | @some x0 =>
        if not (x0 = (UInt64.ofNatCore 56 (by simp)))
        then fail_ panic
        else (
          let hm5 <-
            hashmap_hash_map_remove_back UInt64 hm4
              (USize.ofNatCore 1024 (by simp)) in
          let i1 <-
            hashmap_hash_map_get_fwd UInt64 hm5 (USize.ofNatCore 0 (by simp))
            in
          if not (i1 = (UInt64.ofNatCore 42 (by simp)))
          then fail_ panic
          else (
            let i2 <-
              hashmap_hash_map_get_fwd UInt64 hm5
                (USize.ofNatCore 128 (by simp)) in
            if not (i2 = (UInt64.ofNatCore 18 (by simp)))
            then fail_ panic
            else (
              let i3 <-
                hashmap_hash_map_get_fwd UInt64 hm5
                  (USize.ofNatCore 1056 (by simp)) in
              if not (i3 = (UInt64.ofNatCore 256 (by simp)))
              then fail_ panic
              else ret ())))
      end))

/- Unit test for [hashmap_main::hashmap::test1] -/
#assert (hashmap_test1_fwd = ret ())

/- [hashmap_main::insert_on_disk] -/
def insert_on_disk_fwd
  (key : USize) (value : UInt64) (st : state) : result (state × unit) :=
  let (st0, hm) <- hashmap_utils_deserialize_fwd st in
  let hm0 <- hashmap_hash_map_insert_fwd_back UInt64 hm key value in
  let (st1, _) <- hashmap_utils_serialize_fwd hm0 st0 in
  ret (st1, ())

/- [hashmap_main::main] -/
def main_fwd : result unit := ret ()

/- Unit test for [hashmap_main::main] -/
#assert (main_fwd = ret ())

