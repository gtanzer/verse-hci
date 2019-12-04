open Ast
open Dsl
open Prose

let c = ref 0
let name() = incr c; Printf.sprintf "a%d" (!c)

let libpath = "./stdlib"
let headerpath = libpath ^ "/headers"
let footerpath = libpath ^ "/footers"

let outpath = "./"

let read_file name =
    let ic = open_in name in
    let s = really_input_string ic (in_channel_length ic) in
    close_in ic;
    s
  
let write_file name str =
    let oc = open_out name in
    Printf.fprintf oc "%s\n" str;
    close_out oc

let string_of_ty (t : ty) =
    begin match t with
    | TBool -> "bool"
    | TInt -> "int"
    | TStr -> "string"
    | TFun _ -> failwith "unimplemented"
    | TPair (t1, t2) -> failwith "unimplemented"
    end

let cmp_grammar (ity, oty, d : dsl) : string * string list =
    let header = read_file (headerpath ^ "/grammar") in
    let language = "language Verse;" in
    let input = (Printf.sprintf "@input %s %s;" (string_of_ty ity) (string_of_ty ity)) in
    let start = "@start" in
    let footer = read_file (footerpath ^ "/grammar") in
    (String.concat "\n" [header; language; input; start; footer]), []

let cmp_other (ids : string list) (p : string) : string =
    let header = read_file (headerpath ^ "/" ^ p) in
    let ppath = libpath ^ "/" ^ p ^ "/" in
    let body = List.map (fun n -> read_file ppath ^ n) ids in
    let footer = read_file (footerpath ^ "/" ^ p) in
    String.concat "\n" (header :: body @ [footer])

let cmp_dsl (d : dsl) : unit =
    let grammar, ids = cmp_grammar d in
    let semantics = cmp_other ids "semantics" in
    let witnesses = cmp_other ids "witnesses" in
    let scores = cmp_other ids "scores" in
    let configpath = libpath ^ "/config/" in
    let program = read_file (configpath ^ "Program.cs") in
    let verse = read_file (configpath ^ "Verse.csproj") in
    let outpath = "./output/" in
    write_file (outpath ^ "Program.cs") program;
    write_file (outpath ^ "Verse.csproj") verse;
    let synpath = outpath ^ "synthesis/" in
    write_file (synpath ^ "Semantics.cs") semantics;
    write_file (synpath ^ "WitnessFunctions.cs") witnesses;
    write_file (synpath ^ "RankingScore.cs") scores;
    write_file (synpath ^ "grammar/verse.grammar") grammar
