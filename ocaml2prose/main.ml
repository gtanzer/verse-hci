open Ast
open Typecheck

let corpus = (("x", TStr), TStr,
              [ App (Id "String.sub", [Id "x"; CInt 2; CInt 3])
              ; App (Id "String.append", [Id "x"; Id "x"])])

let _ = tc_corpus corpus
