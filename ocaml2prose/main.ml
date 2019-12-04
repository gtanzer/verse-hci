open Ast
open Typecheck
open Extract
open Compile

let corpus = (("x", TStr), TStr,
              [ App (Id "String.sub", [Id "x"; CInt 2; CInt 3])
              ; App (Id "String.append", [Id "x"; Id "x"])])
              
let main () = tc_corpus corpus;
              let dsl = ext_dsl_corpus corpus in
              cmp_dsl dsl

let _ = main ()
