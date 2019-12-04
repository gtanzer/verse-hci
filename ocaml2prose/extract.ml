open Ast
open Dsl

let rec ext_dsl_exp (e : exp) : Dsl.t =
    begin match e with
    | CBool b -> Dsl.singleton OVBool
    | CInt i -> Dsl.singleton OVInt
    | CStr s -> Dsl.singleton (OCStr s)
    
    | Bop (bop, e1, e2) -> let dsl = Dsl.singleton (OBop0 bop) in
                           let dsl' = Dsl.union dsl (gen_dsl_exp e1) in
                           Dsl.union dsl' (gen_dsl_exp e2)

    | Id x -> if Ctxt.mem x stdlib
              then Dsl.singleton (OOp0 x)
              else Dsl.empty
    
    | App (f, es) -> List.fold_left (fun dsl e -> Dsl.union dsl (gen_dsl_exp e))
                                        (gen_dsl_exp f) es
    
    | Fun (xts, re) -> gen_dsl_exp re
    
    | Let (x, e1, e2) -> let dsl = gen_dsl_exp e1 in
                         Dsl.union dsl (gen_dsl_exp e2)
    end

let optimize (es : exp list) (dsl : Dsl.t) : Dsl.t = dsl

let ext_dsl_corpus ( _, _, es : corpus) : Dsl.t =
    let dsl = List.fold_left (fun c x -> c) Dsl.empty es in
    optimize es dsl
