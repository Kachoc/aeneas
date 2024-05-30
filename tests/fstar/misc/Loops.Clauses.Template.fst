(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [loops]: templates for the decreases clauses *)
module Loops.Clauses.Template
open Primitives
open Loops.Types

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [loops::sum]: decreases clause
    Source: 'tests/src/loops.rs', lines 4:0-14:1 *)
unfold let sum_loop_decreases (max : u32) (i : u32) (s : u32) : nat = admit ()

(** [loops::sum_with_mut_borrows]: decreases clause
    Source: 'tests/src/loops.rs', lines 19:0-31:1 *)
unfold
let sum_with_mut_borrows_loop_decreases (max : u32) (i : u32) (s : u32) : nat =
  admit ()

(** [loops::sum_with_shared_borrows]: decreases clause
    Source: 'tests/src/loops.rs', lines 34:0-48:1 *)
unfold
let sum_with_shared_borrows_loop_decreases (max : u32) (i : u32) (s : u32) :
  nat =
  admit ()

(** [loops::sum_array]: decreases clause
    Source: 'tests/src/loops.rs', lines 50:0-58:1 *)
unfold
let sum_array_loop_decreases (n : usize) (a : array u32 n) (i : usize)
  (s : u32) : nat =
  admit ()

(** [loops::ignore_input_mut_borrow]: decreases clause
    Source: 'tests/src/loops.rs', lines 345:0-349:1 *)
unfold let ignore_input_mut_borrow_loop_decreases (i : u32) : nat = admit ()

(** [loops::incr_ignore_input_mut_borrow]: decreases clause
    Source: 'tests/src/loops.rs', lines 353:0-358:1 *)
unfold
let incr_ignore_input_mut_borrow_loop_decreases (i : u32) : nat = admit ()

(** [loops::ignore_input_shared_borrow]: decreases clause
    Source: 'tests/src/loops.rs', lines 362:0-366:1 *)
unfold let ignore_input_shared_borrow_loop_decreases (i : u32) : nat = admit ()

