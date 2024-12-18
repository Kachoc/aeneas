-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [polonius_list]
import Base
open Primitives
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

namespace polonius_list

/- [polonius_list::List]
   Source: 'tests/src/polonius_list.rs', lines 6:0-9:1 -/
inductive List (T : Type) :=
| Cons : T → List T → List T
| Nil : List T

/- [polonius_list::get_list_at_x]:
   Source: 'tests/src/polonius_list.rs', lines 16:0-30:1 -/
divergent def get_list_at_x
  (ls : List U32) (x : U32) : Result ((List U32) × (List U32 → List U32)) :=
  match ls with
  | List.Cons hd tl =>
    if hd = x
    then Result.ok (ls, fun ret => ret)
    else
      do
      let (l, get_list_at_x_back) ← get_list_at_x tl x
      let back := fun ret => let tl1 := get_list_at_x_back ret
                             List.Cons hd tl1
      Result.ok (l, back)
  | List.Nil => Result.ok (List.Nil, fun ret => ret)

end polonius_list
