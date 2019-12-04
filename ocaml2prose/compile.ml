open Ast
open Dsl

let c = ref 0
let name() = incr c; Printf.sprintf "a%d" (!c)

let string_of_ty (t : ty) =
    begin match t with
    | TBool -> "bool"
    | TInt -> "int"
    | TStr -> "string"
    | TFun _ -> failwith "unimplemented"
    | TPair (t1, t2) -> failwith "unimplemented"
    end

let cmp_grammar (ity, oty, d : dsl) : string =
    let language = "language Verse;" in
    let input = (Printf.sprintf "@input %s %s;" (string_of_ty ity) (string_of_ty ity)) in
    let start = "@start" in
    String.concat "\n" [language; input; start]

let cmp_semantics (d : dsl) : string = ""

let cmp_witnesses (d : dsl) : string = ""

let cmp_dsl (d : dsl) : string * string * string =
    let grammar = cmp_grammar d in
    let semantics = cmp_semantics d in
    let witnesses = cmp_witnesses d in
    grammar, semantics, witnesses
