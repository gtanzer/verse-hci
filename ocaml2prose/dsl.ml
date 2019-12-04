open Ast

type operator =
| OHole
| OVBool
| OCBool of bool
| OVInt
| OCInt of int
| OVStr
| OCStr of string
| OBop0 of binop
| OBopn of binop * operator list
| OOp0 of string
| OOpn of string * operator list

module Operator = struct
  type t = operator
  let compare = compare
end

module Dsl = Set.Make(Operator)