(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [demo] *)
module Demo
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [demo::choose]:
    Source: 'tests/src/demo.rs', lines 7:0-13:1 *)
let choose
  (#t : Type0) (b : bool) (x : t) (y : t) : result (t & (t -> (t & t))) =
  if b
  then let back = fun ret -> (ret, y) in Ok (x, back)
  else let back = fun ret -> (x, ret) in Ok (y, back)

(** [demo::mul2_add1]:
    Source: 'tests/src/demo.rs', lines 15:0-17:1 *)
let mul2_add1 (x : u32) : result u32 =
  let* i = u32_add x x in u32_add i 1

(** [demo::use_mul2_add1]:
    Source: 'tests/src/demo.rs', lines 19:0-21:1 *)
let use_mul2_add1 (x : u32) (y : u32) : result u32 =
  let* i = mul2_add1 x in u32_add i y

(** [demo::incr]:
    Source: 'tests/src/demo.rs', lines 23:0-25:1 *)
let incr (x : u32) : result u32 =
  u32_add x 1

(** [demo::use_incr]:
    Source: 'tests/src/demo.rs', lines 27:0-32:1 *)
let use_incr : result unit =
  let* x = incr 0 in let* x1 = incr x in let* _ = incr x1 in Ok ()

(** [demo::CList]
    Source: 'tests/src/demo.rs', lines 36:0-39:1 *)
type cList_t (t : Type0) =
| CList_CCons : t -> cList_t t -> cList_t t
| CList_CNil : cList_t t

(** [demo::list_nth]:
    Source: 'tests/src/demo.rs', lines 41:0-54:1 *)
let rec list_nth (#t : Type0) (n : nat) (l : cList_t t) (i : u32) : result t =
  if is_zero n
  then Fail OutOfFuel
  else
    let n1 = decrease n in
    begin match l with
    | CList_CCons x tl ->
      if i = 0 then Ok x else let* i1 = u32_sub i 1 in list_nth n1 tl i1
    | CList_CNil -> Fail Failure
    end

(** [demo::list_nth1]: loop 0:
    Source: 'tests/src/demo.rs', lines 57:4-65:1 *)
let rec list_nth1_loop
  (#t : Type0) (n : nat) (l : cList_t t) (i : u32) : result t =
  if is_zero n
  then Fail OutOfFuel
  else
    let n1 = decrease n in
    begin match l with
    | CList_CCons x tl ->
      if i = 0 then Ok x else let* i1 = u32_sub i 1 in list_nth1_loop n1 tl i1
    | CList_CNil -> Fail Failure
    end

(** [demo::list_nth1]:
    Source: 'tests/src/demo.rs', lines 56:0-65:1 *)
let list_nth1 (#t : Type0) (n : nat) (l : cList_t t) (i : u32) : result t =
  list_nth1_loop n l i

(** [demo::list_nth_mut]:
    Source: 'tests/src/demo.rs', lines 67:0-80:1 *)
let rec list_nth_mut
  (#t : Type0) (n : nat) (l : cList_t t) (i : u32) :
  result (t & (t -> cList_t t))
  =
  if is_zero n
  then Fail OutOfFuel
  else
    let n1 = decrease n in
    begin match l with
    | CList_CCons x tl ->
      if i = 0
      then let back = fun ret -> CList_CCons ret tl in Ok (x, back)
      else
        let* i1 = u32_sub i 1 in
        let* (x1, list_nth_mut_back) = list_nth_mut n1 tl i1 in
        let back =
          fun ret -> let tl1 = list_nth_mut_back ret in CList_CCons x tl1 in
        Ok (x1, back)
    | CList_CNil -> Fail Failure
    end

(** [demo::i32_id]:
    Source: 'tests/src/demo.rs', lines 82:0-88:1 *)
let rec i32_id (n : nat) (i : i32) : result i32 =
  if is_zero n
  then Fail OutOfFuel
  else
    let n1 = decrease n in
    if i = 0
    then Ok 0
    else let* i1 = i32_sub i 1 in let* i2 = i32_id n1 i1 in i32_add i2 1

(** [demo::list_tail]:
    Source: 'tests/src/demo.rs', lines 90:0-95:1 *)
let rec list_tail
  (#t : Type0) (n : nat) (l : cList_t t) :
  result ((cList_t t) & (cList_t t -> cList_t t))
  =
  if is_zero n
  then Fail OutOfFuel
  else
    let n1 = decrease n in
    begin match l with
    | CList_CCons x tl ->
      let* (c, list_tail_back) = list_tail n1 tl in
      let back = fun ret -> let tl1 = list_tail_back ret in CList_CCons x tl1
        in
      Ok (c, back)
    | CList_CNil -> Ok (CList_CNil, (fun ret -> ret))
    end

(** Trait declaration: [demo::Counter]
    Source: 'tests/src/demo.rs', lines 99:0-101:1 *)
noeq type counter_t (self : Type0) = { incr : self -> result (usize & self); }

(** [demo::{demo::Counter for usize}::incr]:
    Source: 'tests/src/demo.rs', lines 104:4-108:5 *)
let counterUsize_incr (self : usize) : result (usize & usize) =
  let* self1 = usize_add self 1 in Ok (self, self1)

(** Trait implementation: [demo::{demo::Counter for usize}]
    Source: 'tests/src/demo.rs', lines 103:0-109:1 *)
let counterUsize : counter_t usize = { incr = counterUsize_incr; }

(** [demo::use_counter]:
    Source: 'tests/src/demo.rs', lines 111:0-113:1 *)
let use_counter
  (#t : Type0) (counterInst : counter_t t) (cnt : t) : result (usize & t) =
  counterInst.incr cnt

