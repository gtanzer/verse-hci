open Ast

module Ctxt = Map.Make(String)

let stdfuns : (string * ty) list = [ "String.sub", TFun ([TStr; TInt; TInt], TStr)
                                   ; "String.append", TFun ([TStr; TStr], TStr)]

let stdlib : ty Ctxt.t = List.fold_left (fun c (s, t) -> Ctxt.add s t c) Ctxt.empty stdfuns
