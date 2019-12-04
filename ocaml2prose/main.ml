open Ast
open Typecheck
open Extract
open Compile
open Parser

(*
let corpus = (("x", TStr), TStr,
              [ App (Id "String.sub", [Id "x"; CInt 2; CInt 3])
              ; App (Id "String.append", [Id "x"; Id "x"])])
              *)
              
let corpus = (("x", TStr), TStr,
[ App (Id "String.sub", [Id "x"; CInt 2; CInt 3]) ])
              
let main file = let code = read_file file in
                let corpus = Parser.corpus Lexer.token (Lexing.from_string code) in
                tc_corpus corpus;
                let dsl = ext_dsl_corpus corpus in
                cmp_dsl dsl

let _ = main Sys.argv.(1)
