(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [external]: function definitions *)
module External.Funs
open Primitives
include External.Types
include External.FunsExternal

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** Trait implementation: [core::marker::{core::marker::Copy for u32}#40]
    Source: '/rustc/library/core/src/marker.rs', lines 48:25-48:62
    Name pattern: core::marker::Copy<u32> *)
let core_marker_CopyU32 : core_marker_Copy_t u32 = {
  cloneCloneInst = core_clone_CloneU32;
}

(** [external::use_get]:
    Source: 'tests/src/external.rs', lines 9:0-11:1 *)
let use_get (rc : core_cell_Cell_t u32) (st : state) : result (state & u32) =
  core_cell_Cell_get core_marker_CopyU32 rc st

(** [external::incr]:
    Source: 'tests/src/external.rs', lines 13:0-15:1 *)
let incr
  (rc : core_cell_Cell_t u32) (st : state) :
  result (state & (core_cell_Cell_t u32))
  =
  let* (st1, (i, get_mut_back)) = core_cell_Cell_get_mut rc st in
  let* i1 = u32_add i 1 in
  let* (_, rc1) = get_mut_back i1 st1 in
  Ok (st1, rc1)

