(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [betree_main]: type definitions *)
Require Import Primitives.
Import Primitives.
Require Import Coq.ZArith.ZArith.
Local Open Scope Primitives_scope.
Module BetreeMain_Types.

(** [betree_main::betree::List] *)
Inductive Betree_list_t (T : Type) :=
| BetreeListCons : T -> Betree_list_t T -> Betree_list_t T
| BetreeListNil : Betree_list_t T
.

Arguments BetreeListCons {T} _ _.
Arguments BetreeListNil {T}.

(** [betree_main::betree::UpsertFunState] *)
Inductive Betree_upsert_fun_state_t :=
| BetreeUpsertFunStateAdd : u64 -> Betree_upsert_fun_state_t
| BetreeUpsertFunStateSub : u64 -> Betree_upsert_fun_state_t
.

(** [betree_main::betree::Message] *)
Inductive Betree_message_t :=
| BetreeMessageInsert : u64 -> Betree_message_t
| BetreeMessageDelete : Betree_message_t
| BetreeMessageUpsert : Betree_upsert_fun_state_t -> Betree_message_t
.

(** [betree_main::betree::Leaf] *)
Record Betree_leaf_t :=
mkBetree_leaf_t {
  Betree_leaf_id : u64; Betree_leaf_size : u64;
}
.

(** [betree_main::betree::Node] *)
Inductive Betree_node_t :=
| BetreeNodeInternal : Betree_internal_t -> Betree_node_t
| BetreeNodeLeaf : Betree_leaf_t -> Betree_node_t

(** [betree_main::betree::Internal] *)
with Betree_internal_t :=
| mkBetree_internal_t :
  u64 ->
  u64 ->
  Betree_node_t ->
  Betree_node_t ->
  Betree_internal_t
.

Definition Betree_internal_id (x : Betree_internal_t) :=
  match x with | mkBetree_internal_t x0 _ _ _ => x0 end
.

Notation "x1 .(Betree_internal_id)" := (Betree_internal_id x1) (at level 9).

Definition Betree_internal_pivot (x : Betree_internal_t) :=
  match x with | mkBetree_internal_t _ x0 _ _ => x0 end
.

Notation "x1 .(Betree_internal_pivot)" := (Betree_internal_pivot x1)
  (at level 9)
.

Definition Betree_internal_left (x : Betree_internal_t) :=
  match x with | mkBetree_internal_t _ _ x0 _ => x0 end
.

Notation "x1 .(Betree_internal_left)" := (Betree_internal_left x1) (at level 9)
.

Definition Betree_internal_right (x : Betree_internal_t) :=
  match x with | mkBetree_internal_t _ _ _ x0 => x0 end
.

Notation "x1 .(Betree_internal_right)" := (Betree_internal_right x1)
  (at level 9)
.

(** [betree_main::betree::Params] *)
Record Betree_params_t :=
mkBetree_params_t {
  Betree_params_min_flush_size : u64; Betree_params_split_size : u64;
}
.

(** [betree_main::betree::NodeIdCounter] *)
Record Betree_node_id_counter_t :=
mkBetree_node_id_counter_t {
  Betree_node_id_counter_next_node_id : u64;
}
.

(** [betree_main::betree::BeTree] *)
Record Betree_be_tree_t :=
mkBetree_be_tree_t {
  Betree_be_tree_params : Betree_params_t;
  Betree_be_tree_node_id_cnt : Betree_node_id_counter_t;
  Betree_be_tree_root : Betree_node_t;
}
.

(** [core::num::u64::{10}::MAX] *)
Definition core_num_u64_max_body : result u64 :=
  Return (18446744073709551615%u64)
.
Definition core_num_u64_max_c : u64 := core_num_u64_max_body%global.

(** The state type used in the state-error monad *)
Axiom state : Type.

End BetreeMain_Types .
