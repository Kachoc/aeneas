(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [arrays]: function definitions *)
module Arrays.Funs
open Primitives
include Arrays.Types
include Arrays.Clauses

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [arrays::incr]:
    Source: 'tests/src/arrays.rs', lines 11:0-13:1 *)
let incr (x : u32) : result u32 =
  u32_add x 1

(** [arrays::array_to_shared_slice_]:
    Source: 'tests/src/arrays.rs', lines 19:0-21:1 *)
let array_to_shared_slice_ (#t : Type0) (s : array t 32) : result (slice t) =
  array_to_slice s

(** [arrays::array_to_mut_slice_]:
    Source: 'tests/src/arrays.rs', lines 24:0-26:1 *)
let array_to_mut_slice_
  (#t : Type0) (s : array t 32) :
  result ((slice t) & (slice t -> result (array t 32)))
  =
  array_to_slice_mut s

(** [arrays::array_len]:
    Source: 'tests/src/arrays.rs', lines 28:0-30:1 *)
let array_len (#t : Type0) (s : array t 32) : result usize =
  let* s1 = array_to_slice s in Ok (slice_len s1)

(** [arrays::shared_array_len]:
    Source: 'tests/src/arrays.rs', lines 32:0-34:1 *)
let shared_array_len (#t : Type0) (s : array t 32) : result usize =
  let* s1 = array_to_slice s in Ok (slice_len s1)

(** [arrays::shared_slice_len]:
    Source: 'tests/src/arrays.rs', lines 36:0-38:1 *)
let shared_slice_len (#t : Type0) (s : slice t) : result usize =
  Ok (slice_len s)

(** [arrays::index_array_shared]:
    Source: 'tests/src/arrays.rs', lines 40:0-42:1 *)
let index_array_shared (#t : Type0) (s : array t 32) (i : usize) : result t =
  array_index_usize s i

(** [arrays::index_array_u32]:
    Source: 'tests/src/arrays.rs', lines 47:0-49:1 *)
let index_array_u32 (s : array u32 32) (i : usize) : result u32 =
  array_index_usize s i

(** [arrays::index_array_copy]:
    Source: 'tests/src/arrays.rs', lines 51:0-53:1 *)
let index_array_copy (x : array u32 32) : result u32 =
  array_index_usize x 0

(** [arrays::index_mut_array]:
    Source: 'tests/src/arrays.rs', lines 55:0-57:1 *)
let index_mut_array
  (#t : Type0) (s : array t 32) (i : usize) :
  result (t & (t -> result (array t 32)))
  =
  array_index_mut_usize s i

(** [arrays::index_slice]:
    Source: 'tests/src/arrays.rs', lines 59:0-61:1 *)
let index_slice (#t : Type0) (s : slice t) (i : usize) : result t =
  slice_index_usize s i

(** [arrays::index_mut_slice]:
    Source: 'tests/src/arrays.rs', lines 63:0-65:1 *)
let index_mut_slice
  (#t : Type0) (s : slice t) (i : usize) :
  result (t & (t -> result (slice t)))
  =
  slice_index_mut_usize s i

(** [arrays::slice_subslice_shared_]:
    Source: 'tests/src/arrays.rs', lines 67:0-69:1 *)
let slice_subslice_shared_
  (x : slice u32) (y : usize) (z : usize) : result (slice u32) =
  core_slice_index_Slice_index (core_slice_index_SliceIndexRangeUsizeSliceTInst
    u32) x { start = y; end_ = z }

(** [arrays::slice_subslice_mut_]:
    Source: 'tests/src/arrays.rs', lines 71:0-73:1 *)
let slice_subslice_mut_
  (x : slice u32) (y : usize) (z : usize) :
  result ((slice u32) & (slice u32 -> result (slice u32)))
  =
  let* (s, index_mut_back) =
    core_slice_index_Slice_index_mut
      (core_slice_index_SliceIndexRangeUsizeSliceTInst u32) x
      { start = y; end_ = z } in
  Ok (s, index_mut_back)

(** [arrays::array_to_slice_shared_]:
    Source: 'tests/src/arrays.rs', lines 75:0-77:1 *)
let array_to_slice_shared_ (x : array u32 32) : result (slice u32) =
  array_to_slice x

(** [arrays::array_to_slice_mut_]:
    Source: 'tests/src/arrays.rs', lines 79:0-81:1 *)
let array_to_slice_mut_
  (x : array u32 32) :
  result ((slice u32) & (slice u32 -> result (array u32 32)))
  =
  array_to_slice_mut x

(** [arrays::array_subslice_shared_]:
    Source: 'tests/src/arrays.rs', lines 83:0-85:1 *)
let array_subslice_shared_
  (x : array u32 32) (y : usize) (z : usize) : result (slice u32) =
  core_array_Array_index (core_ops_index_IndexSliceTIInst
    (core_slice_index_SliceIndexRangeUsizeSliceTInst u32)) x
    { start = y; end_ = z }

(** [arrays::array_subslice_mut_]:
    Source: 'tests/src/arrays.rs', lines 87:0-89:1 *)
let array_subslice_mut_
  (x : array u32 32) (y : usize) (z : usize) :
  result ((slice u32) & (slice u32 -> result (array u32 32)))
  =
  let* (s, index_mut_back) =
    core_array_Array_index_mut (core_ops_index_IndexMutSliceTIInst
      (core_slice_index_SliceIndexRangeUsizeSliceTInst u32)) x
      { start = y; end_ = z } in
  Ok (s, index_mut_back)

(** [arrays::index_slice_0]:
    Source: 'tests/src/arrays.rs', lines 91:0-93:1 *)
let index_slice_0 (#t : Type0) (s : slice t) : result t =
  slice_index_usize s 0

(** [arrays::index_array_0]:
    Source: 'tests/src/arrays.rs', lines 95:0-97:1 *)
let index_array_0 (#t : Type0) (s : array t 32) : result t =
  array_index_usize s 0

(** [arrays::index_index_array]:
    Source: 'tests/src/arrays.rs', lines 106:0-108:1 *)
let index_index_array
  (s : array (array u32 32) 32) (i : usize) (j : usize) : result u32 =
  let* a = array_index_usize s i in array_index_usize a j

(** [arrays::update_update_array]:
    Source: 'tests/src/arrays.rs', lines 117:0-119:1 *)
let update_update_array
  (s : array (array u32 32) 32) (i : usize) (j : usize) : result unit =
  let* (a, index_mut_back) = array_index_mut_usize s i in
  let* a1 = array_update_usize a j 0 in
  let* _ = index_mut_back a1 in
  Ok ()

(** [arrays::array_local_deep_copy]:
    Source: 'tests/src/arrays.rs', lines 121:0-123:1 *)
let array_local_deep_copy (x : array u32 32) : result unit =
  Ok ()

(** [arrays::take_array]:
    Source: 'tests/src/arrays.rs', lines 125:0-125:33 *)
let take_array (a : array u32 2) : result unit =
  Ok ()

(** [arrays::take_array_borrow]:
    Source: 'tests/src/arrays.rs', lines 126:0-126:41 *)
let take_array_borrow (a : array u32 2) : result unit =
  Ok ()

(** [arrays::take_slice]:
    Source: 'tests/src/arrays.rs', lines 127:0-127:31 *)
let take_slice (s : slice u32) : result unit =
  Ok ()

(** [arrays::take_mut_slice]:
    Source: 'tests/src/arrays.rs', lines 128:0-128:39 *)
let take_mut_slice (s : slice u32) : result (slice u32) =
  Ok s

(** [arrays::const_array]:
    Source: 'tests/src/arrays.rs', lines 130:0-132:1 *)
let const_array : result (array u32 2) =
  Ok (mk_array 2 [ 0; 0 ])

(** [arrays::const_slice]:
    Source: 'tests/src/arrays.rs', lines 134:0-136:1 *)
let const_slice : result unit =
  let* _ = array_to_slice (mk_array 2 [ 0; 0 ]) in Ok ()

(** [arrays::take_all]:
    Source: 'tests/src/arrays.rs', lines 144:0-156:1 *)
let take_all : result unit =
  let* _ = take_array (mk_array 2 [ 0; 0 ]) in
  let* _ = take_array (mk_array 2 [ 0; 0 ]) in
  let* _ = take_array_borrow (mk_array 2 [ 0; 0 ]) in
  let* s = array_to_slice (mk_array 2 [ 0; 0 ]) in
  let* _ = take_slice s in
  let* (s1, to_slice_mut_back) = array_to_slice_mut (mk_array 2 [ 0; 0 ]) in
  let* s2 = take_mut_slice s1 in
  let* _ = to_slice_mut_back s2 in
  Ok ()

(** [arrays::index_array]:
    Source: 'tests/src/arrays.rs', lines 158:0-160:1 *)
let index_array (x : array u32 2) : result u32 =
  array_index_usize x 0

(** [arrays::index_array_borrow]:
    Source: 'tests/src/arrays.rs', lines 161:0-163:1 *)
let index_array_borrow (x : array u32 2) : result u32 =
  array_index_usize x 0

(** [arrays::index_slice_u32_0]:
    Source: 'tests/src/arrays.rs', lines 165:0-167:1 *)
let index_slice_u32_0 (x : slice u32) : result u32 =
  slice_index_usize x 0

(** [arrays::index_mut_slice_u32_0]:
    Source: 'tests/src/arrays.rs', lines 169:0-171:1 *)
let index_mut_slice_u32_0 (x : slice u32) : result (u32 & (slice u32)) =
  let* i = slice_index_usize x 0 in Ok (i, x)

(** [arrays::index_all]:
    Source: 'tests/src/arrays.rs', lines 173:0-185:1 *)
let index_all : result u32 =
  let* i = index_array (mk_array 2 [ 0; 0 ]) in
  let* i1 = index_array (mk_array 2 [ 0; 0 ]) in
  let* i2 = u32_add i i1 in
  let* i3 = index_array_borrow (mk_array 2 [ 0; 0 ]) in
  let* i4 = u32_add i2 i3 in
  let* s = array_to_slice (mk_array 2 [ 0; 0 ]) in
  let* i5 = index_slice_u32_0 s in
  let* i6 = u32_add i4 i5 in
  let* (s1, to_slice_mut_back) = array_to_slice_mut (mk_array 2 [ 0; 0 ]) in
  let* (i7, s2) = index_mut_slice_u32_0 s1 in
  let* i9 = u32_add i6 i7 in
  let* _ = to_slice_mut_back s2 in
  Ok i9

(** [arrays::update_array]:
    Source: 'tests/src/arrays.rs', lines 187:0-189:1 *)
let update_array (x : array u32 2) : result unit =
  let* _ = array_update_usize x 0 1 in Ok ()

(** [arrays::update_array_mut_borrow]:
    Source: 'tests/src/arrays.rs', lines 190:0-192:1 *)
let update_array_mut_borrow (x : array u32 2) : result (array u32 2) =
  array_update_usize x 0 1

(** [arrays::update_mut_slice]:
    Source: 'tests/src/arrays.rs', lines 193:0-195:1 *)
let update_mut_slice (x : slice u32) : result (slice u32) =
  slice_update_usize x 0 1

(** [arrays::update_all]:
    Source: 'tests/src/arrays.rs', lines 197:0-203:1 *)
let update_all : result unit =
  let* _ = update_array (mk_array 2 [ 0; 0 ]) in
  let* _ = update_array (mk_array 2 [ 0; 0 ]) in
  let* x = update_array_mut_borrow (mk_array 2 [ 0; 0 ]) in
  let* (s, to_slice_mut_back) = array_to_slice_mut x in
  let* s1 = update_mut_slice s in
  let* _ = to_slice_mut_back s1 in
  Ok ()

(** [arrays::incr_array]:
    Source: 'tests/src/arrays.rs', lines 205:0-207:1 *)
let incr_array (x : array u32 2) : result (array u32 2) =
  let* i = array_index_usize x 0 in
  let* i1 = u32_add i 1 in
  array_update_usize x 0 i1

(** [arrays::incr_slice]:
    Source: 'tests/src/arrays.rs', lines 209:0-211:1 *)
let incr_slice (x : slice u32) : result (slice u32) =
  let* i = slice_index_usize x 0 in
  let* i1 = u32_add i 1 in
  slice_update_usize x 0 i1

(** [arrays::range_all]:
    Source: 'tests/src/arrays.rs', lines 216:0-220:1 *)
let range_all : result unit =
  let* (s, index_mut_back) =
    core_array_Array_index_mut (core_ops_index_IndexMutSliceTIInst
      (core_slice_index_SliceIndexRangeUsizeSliceTInst u32))
      (mk_array 4 [ 0; 0; 0; 0 ]) { start = 1; end_ = 3 } in
  let* s1 = update_mut_slice s in
  let* _ = index_mut_back s1 in
  Ok ()

(** [arrays::deref_array_borrow]:
    Source: 'tests/src/arrays.rs', lines 225:0-228:1 *)
let deref_array_borrow (x : array u32 2) : result u32 =
  array_index_usize x 0

(** [arrays::deref_array_mut_borrow]:
    Source: 'tests/src/arrays.rs', lines 230:0-233:1 *)
let deref_array_mut_borrow (x : array u32 2) : result (u32 & (array u32 2)) =
  let* i = array_index_usize x 0 in Ok (i, x)

(** [arrays::take_array_t]:
    Source: 'tests/src/arrays.rs', lines 238:0-238:34 *)
let take_array_t (a : array aB_t 2) : result unit =
  Ok ()

(** [arrays::non_copyable_array]:
    Source: 'tests/src/arrays.rs', lines 240:0-248:1 *)
let non_copyable_array : result unit =
  take_array_t (mk_array 2 [ AB_A; AB_B ])

(** [arrays::sum]: loop 0:
    Source: 'tests/src/arrays.rs', lines 256:4-259:5 *)
let rec sum_loop
  (s : slice u32) (sum1 : u32) (i : usize) :
  Tot (result u32) (decreases (sum_loop_decreases s sum1 i))
  =
  let i1 = slice_len s in
  if i < i1
  then
    let* i2 = slice_index_usize s i in
    let* sum3 = u32_add sum1 i2 in
    let* i3 = usize_add i 1 in
    sum_loop s sum3 i3
  else Ok sum1

(** [arrays::sum]:
    Source: 'tests/src/arrays.rs', lines 253:0-261:1 *)
let sum (s : slice u32) : result u32 =
  sum_loop s 0 0

(** [arrays::sum2]: loop 0:
    Source: 'tests/src/arrays.rs', lines 267:4-270:5 *)
let rec sum2_loop
  (s : slice u32) (s2 : slice u32) (sum1 : u32) (i : usize) :
  Tot (result u32) (decreases (sum2_loop_decreases s s2 sum1 i))
  =
  let i1 = slice_len s in
  if i < i1
  then
    let* i2 = slice_index_usize s i in
    let* i3 = slice_index_usize s2 i in
    let* i4 = u32_add i2 i3 in
    let* sum3 = u32_add sum1 i4 in
    let* i5 = usize_add i 1 in
    sum2_loop s s2 sum3 i5
  else Ok sum1

(** [arrays::sum2]:
    Source: 'tests/src/arrays.rs', lines 263:0-272:1 *)
let sum2 (s : slice u32) (s2 : slice u32) : result u32 =
  let i = slice_len s in
  let i1 = slice_len s2 in
  if i = i1 then sum2_loop s s2 0 0 else Fail Failure

(** [arrays::f0]:
    Source: 'tests/src/arrays.rs', lines 274:0-277:1 *)
let f0 : result unit =
  let* (s, to_slice_mut_back) = array_to_slice_mut (mk_array 2 [ 1; 2 ]) in
  let* s1 = slice_update_usize s 0 1 in
  let* _ = to_slice_mut_back s1 in
  Ok ()

(** [arrays::f1]:
    Source: 'tests/src/arrays.rs', lines 279:0-282:1 *)
let f1 : result unit =
  let* _ = array_update_usize (mk_array 2 [ 1; 2 ]) 0 1 in Ok ()

(** [arrays::f2]:
    Source: 'tests/src/arrays.rs', lines 284:0-284:20 *)
let f2 (i : u32) : result unit =
  Ok ()

(** [arrays::f4]:
    Source: 'tests/src/arrays.rs', lines 293:0-295:1 *)
let f4 (x : array u32 32) (y : usize) (z : usize) : result (slice u32) =
  core_array_Array_index (core_ops_index_IndexSliceTIInst
    (core_slice_index_SliceIndexRangeUsizeSliceTInst u32)) x
    { start = y; end_ = z }

(** [arrays::f3]:
    Source: 'tests/src/arrays.rs', lines 286:0-291:1 *)
let f3 : result u32 =
  let* i = array_index_usize (mk_array 2 [ 1; 2 ]) 0 in
  let* _ = f2 i in
  let b = array_repeat 32 0 in
  let* s = array_to_slice (mk_array 2 [ 1; 2 ]) in
  let* s1 = f4 b 16 18 in
  sum2 s s1

(** [arrays::SZ]
    Source: 'tests/src/arrays.rs', lines 297:0-297:25 *)
let sz_body : result usize = Ok 32
let sz : usize = eval_global sz_body

(** [arrays::f5]:
    Source: 'tests/src/arrays.rs', lines 300:0-302:1 *)
let f5 (x : array u32 32) : result u32 =
  array_index_usize x 0

(** [arrays::ite]:
    Source: 'tests/src/arrays.rs', lines 305:0-312:1 *)
let ite : result unit =
  let* (s, to_slice_mut_back) = array_to_slice_mut (mk_array 2 [ 0; 0 ]) in
  let* (_, s1) = index_mut_slice_u32_0 s in
  let* (s2, to_slice_mut_back1) = array_to_slice_mut (mk_array 2 [ 0; 0 ]) in
  let* (_, s3) = index_mut_slice_u32_0 s2 in
  let* _ = to_slice_mut_back1 s3 in
  let* _ = to_slice_mut_back s1 in
  Ok ()

(** [arrays::zero_slice]: loop 0:
    Source: 'tests/src/arrays.rs', lines 317:4-320:5 *)
let rec zero_slice_loop
  (a : slice u8) (i : usize) (len : usize) :
  Tot (result (slice u8)) (decreases (zero_slice_loop_decreases a i len))
  =
  if i < len
  then
    let* (_, index_mut_back) = slice_index_mut_usize a i in
    let* i1 = usize_add i 1 in
    let* a1 = index_mut_back 0 in
    zero_slice_loop a1 i1 len
  else Ok a

(** [arrays::zero_slice]:
    Source: 'tests/src/arrays.rs', lines 314:0-321:1 *)
let zero_slice (a : slice u8) : result (slice u8) =
  let len = slice_len a in zero_slice_loop a 0 len

(** [arrays::iter_mut_slice]: loop 0:
    Source: 'tests/src/arrays.rs', lines 326:4-328:5 *)
let rec iter_mut_slice_loop
  (len : usize) (i : usize) :
  Tot (result unit) (decreases (iter_mut_slice_loop_decreases len i))
  =
  if i < len
  then let* i1 = usize_add i 1 in iter_mut_slice_loop len i1
  else Ok ()

(** [arrays::iter_mut_slice]:
    Source: 'tests/src/arrays.rs', lines 323:0-329:1 *)
let iter_mut_slice (a : slice u8) : result (slice u8) =
  let len = slice_len a in let* _ = iter_mut_slice_loop len 0 in Ok a

(** [arrays::sum_mut_slice]: loop 0:
    Source: 'tests/src/arrays.rs', lines 334:4-337:5 *)
let rec sum_mut_slice_loop
  (a : slice u32) (i : usize) (s : u32) :
  Tot (result u32) (decreases (sum_mut_slice_loop_decreases a i s))
  =
  let i1 = slice_len a in
  if i < i1
  then
    let* i2 = slice_index_usize a i in
    let* s1 = u32_add s i2 in
    let* i3 = usize_add i 1 in
    sum_mut_slice_loop a i3 s1
  else Ok s

(** [arrays::sum_mut_slice]:
    Source: 'tests/src/arrays.rs', lines 331:0-339:1 *)
let sum_mut_slice (a : slice u32) : result (u32 & (slice u32)) =
  let* i = sum_mut_slice_loop a 0 0 in Ok (i, a)

