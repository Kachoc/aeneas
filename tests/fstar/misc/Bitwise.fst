(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [bitwise] *)
module Bitwise
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [bitwise::shift_u32]:
    Source: 'tests/src/bitwise.rs', lines 4:0-4:31 *)
let shift_u32 (a : u32) : result u32 =
  let* t = u32_shr #Usize a 16 in u32_shl #Usize t 16

(** [bitwise::shift_i32]:
    Source: 'tests/src/bitwise.rs', lines 11:0-11:31 *)
let shift_i32 (a : i32) : result i32 =
  let* t = i32_shr #Isize a 16 in i32_shl #Isize t 16

(** [bitwise::xor_u32]:
    Source: 'tests/src/bitwise.rs', lines 18:0-18:37 *)
let xor_u32 (a : u32) (b : u32) : result u32 =
  Ok (u32_xor a b)

(** [bitwise::or_u32]:
    Source: 'tests/src/bitwise.rs', lines 22:0-22:36 *)
let or_u32 (a : u32) (b : u32) : result u32 =
  Ok (u32_or a b)

(** [bitwise::and_u32]:
    Source: 'tests/src/bitwise.rs', lines 26:0-26:37 *)
let and_u32 (a : u32) (b : u32) : result u32 =
  Ok (u32_and a b)

