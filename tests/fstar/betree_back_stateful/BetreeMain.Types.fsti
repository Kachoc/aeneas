(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [betree_main]: type definitions *)
module BetreeMain.Types
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [betree_main::betree::List] *)
type betree_list_t (t : Type0) =
| BetreeListCons : t -> betree_list_t t -> betree_list_t t
| BetreeListNil : betree_list_t t

(** [betree_main::betree::UpsertFunState] *)
type betree_upsert_fun_state_t =
| BetreeUpsertFunStateAdd : u64 -> betree_upsert_fun_state_t
| BetreeUpsertFunStateSub : u64 -> betree_upsert_fun_state_t

(** [betree_main::betree::Message] *)
type betree_message_t =
| BetreeMessageInsert : u64 -> betree_message_t
| BetreeMessageDelete : betree_message_t
| BetreeMessageUpsert : betree_upsert_fun_state_t -> betree_message_t

(** [betree_main::betree::Leaf] *)
type betree_leaf_t = { betree_leaf_id : u64; betree_leaf_size : u64; }

(** [betree_main::betree::Internal] *)
type betree_internal_t =
{
  betree_internal_id : u64;
  betree_internal_pivot : u64;
  betree_internal_left : betree_node_t;
  betree_internal_right : betree_node_t;
}

(** [betree_main::betree::Node] *)
and betree_node_t =
| BetreeNodeInternal : betree_internal_t -> betree_node_t
| BetreeNodeLeaf : betree_leaf_t -> betree_node_t

(** [betree_main::betree::Params] *)
type betree_params_t =
{
  betree_params_min_flush_size : u64; betree_params_split_size : u64;
}

(** [betree_main::betree::NodeIdCounter] *)
type betree_node_id_counter_t = { betree_node_id_counter_next_node_id : u64; }

(** [betree_main::betree::BeTree] *)
type betree_be_tree_t =
{
  betree_be_tree_params : betree_params_t;
  betree_be_tree_node_id_cnt : betree_node_id_counter_t;
  betree_be_tree_root : betree_node_t;
}

(** The state type used in the state-error monad *)
val state : Type0

