open Ast

module Ctxt = Map.Make(String)
module StringS = Set.Make(String)

let stdfuns : (string * ty) list = [ "substring", TFun ([TStr; TInt; TInt], TStr)
                                   ; "append", TFun ([TStr; TStr], TStr)]

let stdlib : ty Ctxt.t = List.fold_left (fun c (s, t) -> Ctxt.add s t c) Ctxt.empty stdfuns

let stdnames : (string * string) list = [ "substring", "Substring"
                                       ; "append", "Append" ]
              
(* false means it can't be an arbitrary obj, only the input *)
let stdargs : (string * (ty * bool) list) list = [ "Substring", [TStr, false; TInt, true; TInt, true]
                                                 ; "Append", [TStr, true; TStr, true] ]
