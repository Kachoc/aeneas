-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [betree_main]: function definitions
import Base
import BetreeMain.Types
import BetreeMain.FunsExternal
open Primitives

namespace betree_main

/- [betree_main::betree::load_internal_node]:
   Source: 'src/betree.rs', lines 36:0-36:52 -/
def betree.load_internal_node
  (id : U64) (st : State) :
  Result (State × (betree.List (U64 × betree.Message)))
  :=
  betree_utils.load_internal_node id st

/- [betree_main::betree::store_internal_node]:
   Source: 'src/betree.rs', lines 41:0-41:60 -/
def betree.store_internal_node
  (id : U64) (content : betree.List (U64 × betree.Message)) (st : State) :
  Result (State × Unit)
  :=
  betree_utils.store_internal_node id content st

/- [betree_main::betree::load_leaf_node]:
   Source: 'src/betree.rs', lines 46:0-46:44 -/
def betree.load_leaf_node
  (id : U64) (st : State) : Result (State × (betree.List (U64 × U64))) :=
  betree_utils.load_leaf_node id st

/- [betree_main::betree::store_leaf_node]:
   Source: 'src/betree.rs', lines 51:0-51:52 -/
def betree.store_leaf_node
  (id : U64) (content : betree.List (U64 × U64)) (st : State) :
  Result (State × Unit)
  :=
  betree_utils.store_leaf_node id content st

/- [betree_main::betree::fresh_node_id]:
   Source: 'src/betree.rs', lines 55:0-55:48 -/
def betree.fresh_node_id (counter : U64) : Result (U64 × U64) :=
  do
  let counter1 ← counter + 1#u64
  Result.ok (counter, counter1)

/- [betree_main::betree::{betree_main::betree::NodeIdCounter}::new]:
   Source: 'src/betree.rs', lines 206:4-206:20 -/
def betree.NodeIdCounter.new : Result betree.NodeIdCounter :=
  Result.ok { next_node_id := 0#u64 }

/- [betree_main::betree::{betree_main::betree::NodeIdCounter}::fresh_id]:
   Source: 'src/betree.rs', lines 210:4-210:36 -/
def betree.NodeIdCounter.fresh_id
  (self : betree.NodeIdCounter) : Result (U64 × betree.NodeIdCounter) :=
  do
  let i ← self.next_node_id + 1#u64
  Result.ok (self.next_node_id, { next_node_id := i })

/- [betree_main::betree::upsert_update]:
   Source: 'src/betree.rs', lines 234:0-234:70 -/
def betree.upsert_update
  (prev : Option U64) (st : betree.UpsertFunState) : Result U64 :=
  match prev with
  | none =>
    match st with
    | betree.UpsertFunState.Add v => Result.ok v
    | betree.UpsertFunState.Sub _ => Result.ok 0#u64
  | some prev1 =>
    match st with
    | betree.UpsertFunState.Add v =>
      do
      let margin ← core_u64_max - prev1
      if margin >= v
      then prev1 + v
      else Result.ok core_u64_max
    | betree.UpsertFunState.Sub v =>
      if prev1 >= v
      then prev1 - v
      else Result.ok 0#u64

/- [betree_main::betree::{betree_main::betree::List<T>#1}::len]:
   Source: 'src/betree.rs', lines 276:4-276:24 -/
divergent def betree.List.len (T : Type) (self : betree.List T) : Result U64 :=
  match self with
  | betree.List.Cons _ tl => do
                             let i ← betree.List.len T tl
                             1#u64 + i
  | betree.List.Nil => Result.ok 0#u64

/- [betree_main::betree::{betree_main::betree::List<T>#1}::split_at]:
   Source: 'src/betree.rs', lines 284:4-284:51 -/
divergent def betree.List.split_at
  (T : Type) (self : betree.List T) (n : U64) :
  Result ((betree.List T) × (betree.List T))
  :=
  if n = 0#u64
  then Result.ok (betree.List.Nil, self)
  else
    match self with
    | betree.List.Cons hd tl =>
      do
      let i ← n - 1#u64
      let p ← betree.List.split_at T tl i
      let (ls0, ls1) := p
      Result.ok (betree.List.Cons hd ls0, ls1)
    | betree.List.Nil => Result.fail .panic

/- [betree_main::betree::{betree_main::betree::List<T>#1}::push_front]:
   Source: 'src/betree.rs', lines 299:4-299:34 -/
def betree.List.push_front
  (T : Type) (self : betree.List T) (x : T) : Result (betree.List T) :=
  let (tl, _) := core.mem.replace (betree.List T) self betree.List.Nil
  Result.ok (betree.List.Cons x tl)

/- [betree_main::betree::{betree_main::betree::List<T>#1}::pop_front]:
   Source: 'src/betree.rs', lines 306:4-306:32 -/
def betree.List.pop_front
  (T : Type) (self : betree.List T) : Result (T × (betree.List T)) :=
  let (ls, _) := core.mem.replace (betree.List T) self betree.List.Nil
  match ls with
  | betree.List.Cons x tl => Result.ok (x, tl)
  | betree.List.Nil => Result.fail .panic

/- [betree_main::betree::{betree_main::betree::List<T>#1}::hd]:
   Source: 'src/betree.rs', lines 318:4-318:22 -/
def betree.List.hd (T : Type) (self : betree.List T) : Result T :=
  match self with
  | betree.List.Cons hd _ => Result.ok hd
  | betree.List.Nil => Result.fail .panic

/- [betree_main::betree::{betree_main::betree::List<(u64, T)>#2}::head_has_key]:
   Source: 'src/betree.rs', lines 327:4-327:44 -/
def betree.ListPairU64T.head_has_key
  (T : Type) (self : betree.List (U64 × T)) (key : U64) : Result Bool :=
  match self with
  | betree.List.Cons hd _ => let (i, _) := hd
                             Result.ok (i = key)
  | betree.List.Nil => Result.ok false

/- [betree_main::betree::{betree_main::betree::List<(u64, T)>#2}::partition_at_pivot]:
   Source: 'src/betree.rs', lines 339:4-339:73 -/
divergent def betree.ListPairU64T.partition_at_pivot
  (T : Type) (self : betree.List (U64 × T)) (pivot : U64) :
  Result ((betree.List (U64 × T)) × (betree.List (U64 × T)))
  :=
  match self with
  | betree.List.Cons hd tl =>
    let (i, t) := hd
    if i >= pivot
    then Result.ok (betree.List.Nil, betree.List.Cons (i, t) tl)
    else
      do
      let p ← betree.ListPairU64T.partition_at_pivot T tl pivot
      let (ls0, ls1) := p
      Result.ok (betree.List.Cons (i, t) ls0, ls1)
  | betree.List.Nil => Result.ok (betree.List.Nil, betree.List.Nil)

/- [betree_main::betree::{betree_main::betree::Leaf#3}::split]:
   Source: 'src/betree.rs', lines 359:4-364:17 -/
def betree.Leaf.split
  (self : betree.Leaf) (content : betree.List (U64 × U64))
  (params : betree.Params) (node_id_cnt : betree.NodeIdCounter) (st : State) :
  Result (State × (betree.Internal × betree.NodeIdCounter))
  :=
  do
  let p ← betree.List.split_at (U64 × U64) content params.split_size
  let (content0, content1) := p
  let p1 ← betree.List.hd (U64 × U64) content1
  let (pivot, _) := p1
  let (id0, node_id_cnt1) ← betree.NodeIdCounter.fresh_id node_id_cnt
  let (id1, node_id_cnt2) ← betree.NodeIdCounter.fresh_id node_id_cnt1
  let (st1, _) ← betree.store_leaf_node id0 content0 st
  let (st2, _) ← betree.store_leaf_node id1 content1 st1
  let n := betree.Node.Leaf { id := id0, size := params.split_size }
  let n1 := betree.Node.Leaf { id := id1, size := params.split_size }
  Result.ok (st2, (betree.Internal.mk self.id pivot n n1, node_id_cnt2))

/- [betree_main::betree::{betree_main::betree::Node#5}::lookup_first_message_for_key]:
   Source: 'src/betree.rs', lines 789:4-792:34 -/
divergent def betree.Node.lookup_first_message_for_key
  (key : U64) (msgs : betree.List (U64 × betree.Message)) :
  Result ((betree.List (U64 × betree.Message)) × (betree.List (U64 ×
    betree.Message) → Result (betree.List (U64 × betree.Message))))
  :=
  match msgs with
  | betree.List.Cons x next_msgs =>
    let (i, m) := x
    if i >= key
    then Result.ok (betree.List.Cons (i, m) next_msgs, Result.ok)
    else
      do
      let (l, lookup_first_message_for_key_back) ←
        betree.Node.lookup_first_message_for_key key next_msgs
      let back :=
        fun ret =>
          do
          let next_msgs1 ← lookup_first_message_for_key_back ret
          Result.ok (betree.List.Cons (i, m) next_msgs1)
      Result.ok (l, back)
  | betree.List.Nil => Result.ok (betree.List.Nil, Result.ok)

/- [betree_main::betree::{betree_main::betree::Node#5}::lookup_in_bindings]:
   Source: 'src/betree.rs', lines 636:4-636:80 -/
divergent def betree.Node.lookup_in_bindings
  (key : U64) (bindings : betree.List (U64 × U64)) : Result (Option U64) :=
  match bindings with
  | betree.List.Cons hd tl =>
    let (i, i1) := hd
    if i = key
    then Result.ok (some i1)
    else
      if i > key
      then Result.ok none
      else betree.Node.lookup_in_bindings key tl
  | betree.List.Nil => Result.ok none

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_upserts]:
   Source: 'src/betree.rs', lines 819:4-819:90 -/
divergent def betree.Node.apply_upserts
  (msgs : betree.List (U64 × betree.Message)) (prev : Option U64) (key : U64)
  :
  Result (U64 × (betree.List (U64 × betree.Message)))
  :=
  do
  let b ← betree.ListPairU64T.head_has_key betree.Message msgs key
  if b
  then
    do
    let (msg, msgs1) ← betree.List.pop_front (U64 × betree.Message) msgs
    let (_, m) := msg
    match m with
    | betree.Message.Insert _ => Result.fail .panic
    | betree.Message.Delete => Result.fail .panic
    | betree.Message.Upsert s =>
      do
      let v ← betree.upsert_update prev s
      betree.Node.apply_upserts msgs1 (some v) key
  else
    do
    let v ← core.option.Option.unwrap U64 prev
    let msgs1 ←
      betree.List.push_front (U64 × betree.Message) msgs (key,
        betree.Message.Insert v)
    Result.ok (v, msgs1)

/- [betree_main::betree::{betree_main::betree::Internal#4}::lookup_in_children]:
   Source: 'src/betree.rs', lines 395:4-395:63 -/
mutual divergent def betree.Internal.lookup_in_children
  (self : betree.Internal) (key : U64) (st : State) :
  Result (State × ((Option U64) × betree.Internal))
  :=
  let ⟨ i, i1, n, n1 ⟩ := self
  if key < i1
  then
    do
    let (st1, (o, n2)) ← betree.Node.lookup n key st
    Result.ok (st1, (o, betree.Internal.mk i i1 n2 n1))
  else
    do
    let (st1, (o, n2)) ← betree.Node.lookup n1 key st
    Result.ok (st1, (o, betree.Internal.mk i i1 n n2))

/- [betree_main::betree::{betree_main::betree::Node#5}::lookup]:
   Source: 'src/betree.rs', lines 709:4-709:58 -/
divergent def betree.Node.lookup
  (self : betree.Node) (key : U64) (st : State) :
  Result (State × ((Option U64) × betree.Node))
  :=
  match self with
  | betree.Node.Internal node =>
    do
    let ⟨ i, i1, n, n1 ⟩ := node
    let (st1, msgs) ← betree.load_internal_node i st
    let (pending, lookup_first_message_for_key_back) ←
      betree.Node.lookup_first_message_for_key key msgs
    match pending with
    | betree.List.Cons p l =>
      let (k, msg) := p
      if k != key
      then
        do
        let (st2, (o, node1)) ←
          betree.Internal.lookup_in_children (betree.Internal.mk i i1 n n1) key
            st1
        let _ ←
          lookup_first_message_for_key_back (betree.List.Cons (k, msg) l)
        Result.ok (st2, (o, betree.Node.Internal node1))
      else
        match msg with
        | betree.Message.Insert v =>
          do
          let _ ←
            lookup_first_message_for_key_back (betree.List.Cons (k,
              betree.Message.Insert v) l)
          Result.ok (st1, (some v, betree.Node.Internal (betree.Internal.mk i
            i1 n n1)))
        | betree.Message.Delete =>
          do
          let _ ←
            lookup_first_message_for_key_back (betree.List.Cons (k,
              betree.Message.Delete) l)
          Result.ok (st1, (none, betree.Node.Internal (betree.Internal.mk i i1
            n n1)))
        | betree.Message.Upsert ufs =>
          do
          let (st2, (v, node1)) ←
            betree.Internal.lookup_in_children (betree.Internal.mk i i1 n n1)
              key st1
          let (v1, pending1) ←
            betree.Node.apply_upserts (betree.List.Cons (k,
              betree.Message.Upsert ufs) l) v key
          let ⟨ i2, i3, n2, n3 ⟩ := node1
          let msgs1 ← lookup_first_message_for_key_back pending1
          let (st3, _) ← betree.store_internal_node i2 msgs1 st2
          Result.ok (st3, (some v1, betree.Node.Internal (betree.Internal.mk i2
            i3 n2 n3)))
    | betree.List.Nil =>
      do
      let (st2, (o, node1)) ←
        betree.Internal.lookup_in_children (betree.Internal.mk i i1 n n1) key
          st1
      let _ ← lookup_first_message_for_key_back betree.List.Nil
      Result.ok (st2, (o, betree.Node.Internal node1))
  | betree.Node.Leaf node =>
    do
    let (st1, bindings) ← betree.load_leaf_node node.id st
    let o ← betree.Node.lookup_in_bindings key bindings
    Result.ok (st1, (o, betree.Node.Leaf node))

end

/- [betree_main::betree::{betree_main::betree::Node#5}::filter_messages_for_key]:
   Source: 'src/betree.rs', lines 674:4-674:77 -/
divergent def betree.Node.filter_messages_for_key
  (key : U64) (msgs : betree.List (U64 × betree.Message)) :
  Result (betree.List (U64 × betree.Message))
  :=
  match msgs with
  | betree.List.Cons p l =>
    let (k, m) := p
    if k = key
    then
      do
      let (_, msgs1) ←
        betree.List.pop_front (U64 × betree.Message) (betree.List.Cons (k, m)
          l)
      betree.Node.filter_messages_for_key key msgs1
    else Result.ok (betree.List.Cons (k, m) l)
  | betree.List.Nil => Result.ok betree.List.Nil

/- [betree_main::betree::{betree_main::betree::Node#5}::lookup_first_message_after_key]:
   Source: 'src/betree.rs', lines 689:4-692:34 -/
divergent def betree.Node.lookup_first_message_after_key
  (key : U64) (msgs : betree.List (U64 × betree.Message)) :
  Result ((betree.List (U64 × betree.Message)) × (betree.List (U64 ×
    betree.Message) → Result (betree.List (U64 × betree.Message))))
  :=
  match msgs with
  | betree.List.Cons p next_msgs =>
    let (k, m) := p
    if k = key
    then
      do
      let (l, lookup_first_message_after_key_back) ←
        betree.Node.lookup_first_message_after_key key next_msgs
      let back :=
        fun ret =>
          do
          let next_msgs1 ← lookup_first_message_after_key_back ret
          Result.ok (betree.List.Cons (k, m) next_msgs1)
      Result.ok (l, back)
    else Result.ok (betree.List.Cons (k, m) next_msgs, Result.ok)
  | betree.List.Nil => Result.ok (betree.List.Nil, Result.ok)

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_to_internal]:
   Source: 'src/betree.rs', lines 521:4-521:89 -/
def betree.Node.apply_to_internal
  (msgs : betree.List (U64 × betree.Message)) (key : U64)
  (new_msg : betree.Message) :
  Result (betree.List (U64 × betree.Message))
  :=
  do
  let (msgs1, lookup_first_message_for_key_back) ←
    betree.Node.lookup_first_message_for_key key msgs
  let b ← betree.ListPairU64T.head_has_key betree.Message msgs1 key
  if b
  then
    match new_msg with
    | betree.Message.Insert i =>
      do
      let msgs2 ← betree.Node.filter_messages_for_key key msgs1
      let msgs3 ←
        betree.List.push_front (U64 × betree.Message) msgs2 (key,
          betree.Message.Insert i)
      lookup_first_message_for_key_back msgs3
    | betree.Message.Delete =>
      do
      let msgs2 ← betree.Node.filter_messages_for_key key msgs1
      let msgs3 ←
        betree.List.push_front (U64 × betree.Message) msgs2 (key,
          betree.Message.Delete)
      lookup_first_message_for_key_back msgs3
    | betree.Message.Upsert s =>
      do
      let p ← betree.List.hd (U64 × betree.Message) msgs1
      let (_, m) := p
      match m with
      | betree.Message.Insert prev =>
        do
        let v ← betree.upsert_update (some prev) s
        let (_, msgs2) ← betree.List.pop_front (U64 × betree.Message) msgs1
        let msgs3 ←
          betree.List.push_front (U64 × betree.Message) msgs2 (key,
            betree.Message.Insert v)
        lookup_first_message_for_key_back msgs3
      | betree.Message.Delete =>
        do
        let (_, msgs2) ← betree.List.pop_front (U64 × betree.Message) msgs1
        let v ← betree.upsert_update none s
        let msgs3 ←
          betree.List.push_front (U64 × betree.Message) msgs2 (key,
            betree.Message.Insert v)
        lookup_first_message_for_key_back msgs3
      | betree.Message.Upsert _ =>
        do
        let (msgs2, lookup_first_message_after_key_back) ←
          betree.Node.lookup_first_message_after_key key msgs1
        let msgs3 ←
          betree.List.push_front (U64 × betree.Message) msgs2 (key,
            betree.Message.Upsert s)
        let msgs4 ← lookup_first_message_after_key_back msgs3
        lookup_first_message_for_key_back msgs4
  else
    do
    let msgs2 ←
      betree.List.push_front (U64 × betree.Message) msgs1 (key, new_msg)
    lookup_first_message_for_key_back msgs2

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_messages_to_internal]:
   Source: 'src/betree.rs', lines 502:4-505:5 -/
divergent def betree.Node.apply_messages_to_internal
  (msgs : betree.List (U64 × betree.Message))
  (new_msgs : betree.List (U64 × betree.Message)) :
  Result (betree.List (U64 × betree.Message))
  :=
  match new_msgs with
  | betree.List.Cons new_msg new_msgs_tl =>
    do
    let (i, m) := new_msg
    let msgs1 ← betree.Node.apply_to_internal msgs i m
    betree.Node.apply_messages_to_internal msgs1 new_msgs_tl
  | betree.List.Nil => Result.ok msgs

/- [betree_main::betree::{betree_main::betree::Node#5}::lookup_mut_in_bindings]:
   Source: 'src/betree.rs', lines 653:4-656:32 -/
divergent def betree.Node.lookup_mut_in_bindings
  (key : U64) (bindings : betree.List (U64 × U64)) :
  Result ((betree.List (U64 × U64)) × (betree.List (U64 × U64) → Result
    (betree.List (U64 × U64))))
  :=
  match bindings with
  | betree.List.Cons hd tl =>
    let (i, i1) := hd
    if i >= key
    then Result.ok (betree.List.Cons (i, i1) tl, Result.ok)
    else
      do
      let (l, lookup_mut_in_bindings_back) ←
        betree.Node.lookup_mut_in_bindings key tl
      let back :=
        fun ret =>
          do
          let tl1 ← lookup_mut_in_bindings_back ret
          Result.ok (betree.List.Cons (i, i1) tl1)
      Result.ok (l, back)
  | betree.List.Nil => Result.ok (betree.List.Nil, Result.ok)

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_to_leaf]:
   Source: 'src/betree.rs', lines 460:4-460:87 -/
def betree.Node.apply_to_leaf
  (bindings : betree.List (U64 × U64)) (key : U64) (new_msg : betree.Message)
  :
  Result (betree.List (U64 × U64))
  :=
  do
  let (bindings1, lookup_mut_in_bindings_back) ←
    betree.Node.lookup_mut_in_bindings key bindings
  let b ← betree.ListPairU64T.head_has_key U64 bindings1 key
  if b
  then
    do
    let (hd, bindings2) ← betree.List.pop_front (U64 × U64) bindings1
    match new_msg with
    | betree.Message.Insert v =>
      do
      let bindings3 ← betree.List.push_front (U64 × U64) bindings2 (key, v)
      lookup_mut_in_bindings_back bindings3
    | betree.Message.Delete => lookup_mut_in_bindings_back bindings2
    | betree.Message.Upsert s =>
      do
      let (_, i) := hd
      let v ← betree.upsert_update (some i) s
      let bindings3 ← betree.List.push_front (U64 × U64) bindings2 (key, v)
      lookup_mut_in_bindings_back bindings3
  else
    match new_msg with
    | betree.Message.Insert v =>
      do
      let bindings2 ← betree.List.push_front (U64 × U64) bindings1 (key, v)
      lookup_mut_in_bindings_back bindings2
    | betree.Message.Delete => lookup_mut_in_bindings_back bindings1
    | betree.Message.Upsert s =>
      do
      let v ← betree.upsert_update none s
      let bindings2 ← betree.List.push_front (U64 × U64) bindings1 (key, v)
      lookup_mut_in_bindings_back bindings2

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_messages_to_leaf]:
   Source: 'src/betree.rs', lines 444:4-447:5 -/
divergent def betree.Node.apply_messages_to_leaf
  (bindings : betree.List (U64 × U64))
  (new_msgs : betree.List (U64 × betree.Message)) :
  Result (betree.List (U64 × U64))
  :=
  match new_msgs with
  | betree.List.Cons new_msg new_msgs_tl =>
    do
    let (i, m) := new_msg
    let bindings1 ← betree.Node.apply_to_leaf bindings i m
    betree.Node.apply_messages_to_leaf bindings1 new_msgs_tl
  | betree.List.Nil => Result.ok bindings

/- [betree_main::betree::{betree_main::betree::Internal#4}::flush]:
   Source: 'src/betree.rs', lines 410:4-415:26 -/
mutual divergent def betree.Internal.flush
  (self : betree.Internal) (params : betree.Params)
  (node_id_cnt : betree.NodeIdCounter)
  (content : betree.List (U64 × betree.Message)) (st : State) :
  Result (State × ((betree.List (U64 × betree.Message)) × (betree.Internal
    × betree.NodeIdCounter)))
  :=
  do
  let ⟨ i, i1, n, n1 ⟩ := self
  let p ← betree.ListPairU64T.partition_at_pivot betree.Message content i1
  let (msgs_left, msgs_right) := p
  let len_left ← betree.List.len (U64 × betree.Message) msgs_left
  if len_left >= params.min_flush_size
  then
    do
    let (st1, p1) ←
      betree.Node.apply_messages n params node_id_cnt msgs_left st
    let (n2, node_id_cnt1) := p1
    let len_right ← betree.List.len (U64 × betree.Message) msgs_right
    if len_right >= params.min_flush_size
    then
      do
      let (st2, p2) ←
        betree.Node.apply_messages n1 params node_id_cnt1 msgs_right st1
      let (n3, node_id_cnt2) := p2
      Result.ok (st2, (betree.List.Nil, (betree.Internal.mk i i1 n2 n3,
        node_id_cnt2)))
    else
      Result.ok (st1, (msgs_right, (betree.Internal.mk i i1 n2 n1,
        node_id_cnt1)))
  else
    do
    let (st1, p1) ←
      betree.Node.apply_messages n1 params node_id_cnt msgs_right st
    let (n2, node_id_cnt1) := p1
    Result.ok (st1, (msgs_left, (betree.Internal.mk i i1 n n2, node_id_cnt1)))

/- [betree_main::betree::{betree_main::betree::Node#5}::apply_messages]:
   Source: 'src/betree.rs', lines 588:4-593:5 -/
divergent def betree.Node.apply_messages
  (self : betree.Node) (params : betree.Params)
  (node_id_cnt : betree.NodeIdCounter)
  (msgs : betree.List (U64 × betree.Message)) (st : State) :
  Result (State × (betree.Node × betree.NodeIdCounter))
  :=
  match self with
  | betree.Node.Internal node =>
    do
    let ⟨ i, i1, n, n1 ⟩ := node
    let (st1, content) ← betree.load_internal_node i st
    let content1 ← betree.Node.apply_messages_to_internal content msgs
    let num_msgs ← betree.List.len (U64 × betree.Message) content1
    if num_msgs >= params.min_flush_size
    then
      do
      let (st2, (content2, p)) ←
        betree.Internal.flush (betree.Internal.mk i i1 n n1) params node_id_cnt
          content1 st1
      let (node1, node_id_cnt1) := p
      let ⟨ i2, i3, n2, n3 ⟩ := node1
      let (st3, _) ← betree.store_internal_node i2 content2 st2
      Result.ok (st3, (betree.Node.Internal (betree.Internal.mk i2 i3 n2 n3),
        node_id_cnt1))
    else
      do
      let (st2, _) ← betree.store_internal_node i content1 st1
      Result.ok (st2, (betree.Node.Internal (betree.Internal.mk i i1 n n1),
        node_id_cnt))
  | betree.Node.Leaf node =>
    do
    let (st1, content) ← betree.load_leaf_node node.id st
    let content1 ← betree.Node.apply_messages_to_leaf content msgs
    let len ← betree.List.len (U64 × U64) content1
    let i ← 2#u64 * params.split_size
    if len >= i
    then
      do
      let (st2, (new_node, node_id_cnt1)) ←
        betree.Leaf.split node content1 params node_id_cnt st1
      let (st3, _) ← betree.store_leaf_node node.id betree.List.Nil st2
      Result.ok (st3, (betree.Node.Internal new_node, node_id_cnt1))
    else
      do
      let (st2, _) ← betree.store_leaf_node node.id content1 st1
      Result.ok (st2, (betree.Node.Leaf { node with size := len },
        node_id_cnt))

end

/- [betree_main::betree::{betree_main::betree::Node#5}::apply]:
   Source: 'src/betree.rs', lines 576:4-582:5 -/
def betree.Node.apply
  (self : betree.Node) (params : betree.Params)
  (node_id_cnt : betree.NodeIdCounter) (key : U64) (new_msg : betree.Message)
  (st : State) :
  Result (State × (betree.Node × betree.NodeIdCounter))
  :=
  do
  let (st1, p) ←
    betree.Node.apply_messages self params node_id_cnt (betree.List.Cons (key,
      new_msg) betree.List.Nil) st
  let (self1, node_id_cnt1) := p
  Result.ok (st1, (self1, node_id_cnt1))

/- [betree_main::betree::{betree_main::betree::BeTree#6}::new]:
   Source: 'src/betree.rs', lines 849:4-849:60 -/
def betree.BeTree.new
  (min_flush_size : U64) (split_size : U64) (st : State) :
  Result (State × betree.BeTree)
  :=
  do
  let node_id_cnt ← betree.NodeIdCounter.new
  let (id, node_id_cnt1) ← betree.NodeIdCounter.fresh_id node_id_cnt
  let (st1, _) ← betree.store_leaf_node id betree.List.Nil st
  Result.ok (st1,
    {
      params := { min_flush_size := min_flush_size, split_size := split_size },
      node_id_cnt := node_id_cnt1,
      root := (betree.Node.Leaf { id := id, size := 0#u64 })
    })

/- [betree_main::betree::{betree_main::betree::BeTree#6}::apply]:
   Source: 'src/betree.rs', lines 868:4-868:47 -/
def betree.BeTree.apply
  (self : betree.BeTree) (key : U64) (msg : betree.Message) (st : State) :
  Result (State × betree.BeTree)
  :=
  do
  let (st1, p) ←
    betree.Node.apply self.root self.params self.node_id_cnt key msg st
  let (n, nic) := p
  Result.ok (st1, { self with node_id_cnt := nic, root := n })

/- [betree_main::betree::{betree_main::betree::BeTree#6}::insert]:
   Source: 'src/betree.rs', lines 874:4-874:52 -/
def betree.BeTree.insert
  (self : betree.BeTree) (key : U64) (value : U64) (st : State) :
  Result (State × betree.BeTree)
  :=
  betree.BeTree.apply self key (betree.Message.Insert value) st

/- [betree_main::betree::{betree_main::betree::BeTree#6}::delete]:
   Source: 'src/betree.rs', lines 880:4-880:38 -/
def betree.BeTree.delete
  (self : betree.BeTree) (key : U64) (st : State) :
  Result (State × betree.BeTree)
  :=
  betree.BeTree.apply self key betree.Message.Delete st

/- [betree_main::betree::{betree_main::betree::BeTree#6}::upsert]:
   Source: 'src/betree.rs', lines 886:4-886:59 -/
def betree.BeTree.upsert
  (self : betree.BeTree) (key : U64) (upd : betree.UpsertFunState) (st : State)
  :
  Result (State × betree.BeTree)
  :=
  betree.BeTree.apply self key (betree.Message.Upsert upd) st

/- [betree_main::betree::{betree_main::betree::BeTree#6}::lookup]:
   Source: 'src/betree.rs', lines 895:4-895:62 -/
def betree.BeTree.lookup
  (self : betree.BeTree) (key : U64) (st : State) :
  Result (State × ((Option U64) × betree.BeTree))
  :=
  do
  let (st1, (o, n)) ← betree.Node.lookup self.root key st
  Result.ok (st1, (o, { self with root := n }))

/- [betree_main::main]:
   Source: 'src/betree_main.rs', lines 5:0-5:9 -/
def main : Result Unit :=
  Result.ok ()

/- Unit test for [betree_main::main] -/
#assert (main == Result.ok ())

end betree_main
