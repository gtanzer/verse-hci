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

let rec string_of_ty (t : ty) =
    begin match t with
    | TBool -> "bool"
    | TInt -> "int"
    | TStr -> "string"
    | TFun (ts, rt) -> string_of_ty rt
    | TPair (t1, t2) -> failwith "unimplemented"
    end

let cmp_operator names (ity, in_name : ty * string) (o : operator) : string option =
    begin match o with
    | OOp0 i -> let ope = i ^ "(" in
                let tbs = List.assoc i stdargs in
                let args = List.map (fun (t, b) -> if b then (TMap.find t names)
                                                   else if t <> ity then failwith "argument must be input"
                                                   else in_name) tbs in
                Some (ope ^ (String.concat "," args) ^ ")")
    | _ -> None
    end

let cmp_rule names (ity, in_name : ty * string) (t : ty) (o : Rule.t) : string * (ty list) =
    let decl = Printf.sprintf "%s %s" (string_of_ty t) (TMap.find t names) in
    let constrs = List.map (cmp_operator names (ity, in_name)) (Rule.elements o) in
    let constrs' = List.fold_left (fun l c -> match c with
                                             | Some c' -> (c' :: l)
                                             | _ -> l ) [] constrs in
    let constrs'' = if ity = t then in_name :: constrs' else constrs' in
    begin match constrs'' with
    | [] -> (decl ^ ";"), [t]
    | _ -> (decl ^ " := " ^ (String.concat " | " constrs'') ^ ";"), []
    end

let cmp_grammar (ity, oty, d : dsl) : string * (ty * string) list =
    let header = read_file (headerpath ^ "/grammar") in
    let in_name = name() in
    let input = (Printf.sprintf "@input %s %s;\n@start" (string_of_ty ity) in_name) in
    let names = TMap.fold (fun t _ m -> TMap.add t (name()) m) d TMap.empty in
    let body2 = TMap.fold (fun t o ss -> (cmp_rule names (ity, in_name) t o)::ss) d [] in
    let body, priml = List.split body2 in
    let prims = List.map (fun t -> t, (TMap.find t names)) (List.flatten priml) in
    let footer = read_file (footerpath ^ "/grammar") in
    (String.concat "\n" ([header; input] @ body @ [footer])), prims

let cmp_other (ids : string list) (p : string) : string =
    let header = read_file (headerpath ^ "/" ^ p) in
    let ppath = libpath ^ "/" ^ p ^ "/" in
    let body = List.map (fun n -> read_file (ppath ^ n)) ids in
    let footer = read_file (footerpath ^ "/" ^ p) in
    String.concat "\n" (header :: body @ [footer])

let cmp_prim_scores (tss : (ty * string) list) : string =
    let ss = List.map (fun (t, s) ->
        Printf.sprintf "[FeatureCalculator(\"%s\", Method = CalculationMethod.FromLiteral)]\n
                        public static double %s(%s %s) => -1.0;" s (String.uppercase_ascii s) (string_of_ty t) s
    ) tss in
    String.concat "\n" ss

let cmp_scores (ids : string list) (p : string) (tss : (ty * string) list): string =
    let header = read_file (headerpath ^ "/" ^ p) in
    let ppath = libpath ^ "/" ^ p ^ "/" in
    let body = List.map (fun n -> read_file (ppath ^ n)) ids in
    let footer = read_file (footerpath ^ "/" ^ p) in
    String.concat "\n" (header :: body @ [cmp_prim_scores tss; footer])

let cmp_dsl (ity, oty, d : dsl) : unit =
    let grammar, prims = cmp_grammar (ity, oty, d) in
    let ids = TMap.fold (fun _ os l -> Rule.fold (fun o l -> match o with OOp0 i -> i::l | _ -> l) os l) d [] in
    let semantics = cmp_other ids "semantics" in
    let witnesses = cmp_other ids "witnesses" in
    let scores = cmp_scores ids "scores" prims in
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
