(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [constants] *)
module Constants
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [constants::X0]
    Source: 'src/constants.rs', lines 5:0-5:17 *)
let x0_body : result u32 = Ok 0
let x0 : u32 = eval_global x0_body

(** [constants::X1]
    Source: 'src/constants.rs', lines 7:0-7:17 *)
let x1_body : result u32 = Ok core_u32_max
let x1 : u32 = eval_global x1_body

(** [constants::X2]
    Source: 'src/constants.rs', lines 10:0-10:17 *)
let x2_body : result u32 = Ok 3
let x2 : u32 = eval_global x2_body

(** [constants::incr]:
    Source: 'src/constants.rs', lines 17:0-17:32 *)
let incr (n : u32) : result u32 =
  u32_add n 1

(** [constants::X3]
    Source: 'src/constants.rs', lines 15:0-15:17 *)
let x3_body : result u32 = incr 32
let x3 : u32 = eval_global x3_body

(** [constants::mk_pair0]:
    Source: 'src/constants.rs', lines 23:0-23:51 *)
let mk_pair0 (x : u32) (y1 : u32) : result (u32 & u32) =
  Ok (x, y1)

(** [constants::Pair]
    Source: 'src/constants.rs', lines 36:0-36:23 *)
type pair_t (t1 t2 : Type0) = { x : t1; y : t2; }

(** [constants::mk_pair1]:
    Source: 'src/constants.rs', lines 27:0-27:55 *)
let mk_pair1 (x : u32) (y1 : u32) : result (pair_t u32 u32) =
  Ok { x = x; y = y1 }

(** [constants::P0]
    Source: 'src/constants.rs', lines 31:0-31:24 *)
let p0_body : result (u32 & u32) = mk_pair0 0 1
let p0 : (u32 & u32) = eval_global p0_body

(** [constants::P1]
    Source: 'src/constants.rs', lines 32:0-32:28 *)
let p1_body : result (pair_t u32 u32) = mk_pair1 0 1
let p1 : pair_t u32 u32 = eval_global p1_body

(** [constants::P2]
    Source: 'src/constants.rs', lines 33:0-33:24 *)
let p2_body : result (u32 & u32) = Ok (0, 1)
let p2 : (u32 & u32) = eval_global p2_body

(** [constants::P3]
    Source: 'src/constants.rs', lines 34:0-34:28 *)
let p3_body : result (pair_t u32 u32) = Ok { x = 0; y = 1 }
let p3 : pair_t u32 u32 = eval_global p3_body

(** [constants::Wrap]
    Source: 'src/constants.rs', lines 49:0-49:18 *)
type wrap_t (t : Type0) = { value : t; }

(** [constants::{constants::Wrap<T>}::new]:
    Source: 'src/constants.rs', lines 54:4-54:41 *)
let wrap_new (t : Type0) (value : t) : result (wrap_t t) =
  Ok { value = value }

(** [constants::Y]
    Source: 'src/constants.rs', lines 41:0-41:22 *)
let y_body : result (wrap_t i32) = wrap_new i32 2
let y : wrap_t i32 = eval_global y_body

(** [constants::unwrap_y]:
    Source: 'src/constants.rs', lines 43:0-43:30 *)
let unwrap_y : result i32 =
  Ok y.value

(** [constants::YVAL]
    Source: 'src/constants.rs', lines 47:0-47:19 *)
let yval_body : result i32 = unwrap_y
let yval : i32 = eval_global yval_body

(** [constants::get_z1::Z1]
    Source: 'src/constants.rs', lines 62:4-62:17 *)
let get_z1_z1_body : result i32 = Ok 3
let get_z1_z1 : i32 = eval_global get_z1_z1_body

(** [constants::get_z1]:
    Source: 'src/constants.rs', lines 61:0-61:28 *)
let get_z1 : result i32 =
  Ok get_z1_z1

(** [constants::add]:
    Source: 'src/constants.rs', lines 66:0-66:39 *)
let add (a : i32) (b : i32) : result i32 =
  i32_add a b

(** [constants::Q1]
    Source: 'src/constants.rs', lines 74:0-74:17 *)
let q1_body : result i32 = Ok 5
let q1 : i32 = eval_global q1_body

(** [constants::Q2]
    Source: 'src/constants.rs', lines 75:0-75:17 *)
let q2_body : result i32 = Ok q1
let q2 : i32 = eval_global q2_body

(** [constants::Q3]
    Source: 'src/constants.rs', lines 76:0-76:17 *)
let q3_body : result i32 = add q2 3
let q3 : i32 = eval_global q3_body

(** [constants::get_z2]:
    Source: 'src/constants.rs', lines 70:0-70:28 *)
let get_z2 : result i32 =
  let* i = get_z1 in let* i1 = add i q3 in add q1 i1

(** [constants::S1]
    Source: 'src/constants.rs', lines 80:0-80:18 *)
let s1_body : result u32 = Ok 6
let s1 : u32 = eval_global s1_body

(** [constants::S2]
    Source: 'src/constants.rs', lines 81:0-81:18 *)
let s2_body : result u32 = incr s1
let s2 : u32 = eval_global s2_body

(** [constants::S3]
    Source: 'src/constants.rs', lines 82:0-82:29 *)
let s3_body : result (pair_t u32 u32) = Ok p3
let s3 : pair_t u32 u32 = eval_global s3_body

(** [constants::S4]
    Source: 'src/constants.rs', lines 83:0-83:29 *)
let s4_body : result (pair_t u32 u32) = mk_pair1 7 8
let s4 : pair_t u32 u32 = eval_global s4_body

(** [constants::V]
    Source: 'src/constants.rs', lines 86:0-86:31 *)
type v_t (t : Type0) (n : usize) = { x : array t n; }

(** [constants::{constants::V<T, N>#1}::LEN]
    Source: 'src/constants.rs', lines 91:4-91:24 *)
let v_len_body (t : Type0) (n : usize) : result usize = Ok n
let v_len (t : Type0) (n : usize) : usize = eval_global (v_len_body t n)

(** [constants::use_v]:
    Source: 'src/constants.rs', lines 94:0-94:42 *)
let use_v (t : Type0) (n : usize) : result usize =
  Ok (v_len t n)

