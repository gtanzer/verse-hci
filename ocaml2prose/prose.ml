open Ast
open Dsl

module Ctxt = Map.Make(String)

let stdfuns : (string * ty) list = ["substring", TFun ([TString; TInt; TInt], TString)
                                   ; ]

let stdlib : ty Ctxt.t = List.fold_left (fun c (s, t) -> Ctxt.add s t c) Ctxt.empty stdfuns

let gen_dsl ( (x, ity), oty, es : corpus) : dsl =
    [PName "map"]
