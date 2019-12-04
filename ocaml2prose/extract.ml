open Ast
open Dsl
open Prose
open Typecheck

let update_union y oz =
    begin match oz with
    | Some z -> Some (Dsl.add y z)
    | None -> Some (Dsl.singleton y)
    end

let insert x y m : Dsl.t TMap.t = TMap.update x (update_union y) m

let rec ext_dsl_exp (d : Dsl.t TMap.t) (e : exp) : Dsl.t TMap.t =
    begin match e with
    | CBool b -> insert TBool OVBool d
    | CInt i -> insert TInt OVInt d
    | CStr s -> insert TStr (OCStr s) d
    
    | Bop (bop, e1, e2) -> let d' = insert (snd (ti_binop bop)) (OBop0 bop) d in
                           let d'' = ext_dsl_exp d' e1 in
                           ext_dsl_exp d'' e2

    | Id x -> if Ctxt.mem x stdlib
              then insert (Ctxt.find x stdlib) (OOp0 x) d
              else d
    
    | App (f, es) -> List.fold_left ext_dsl_exp (ext_dsl_exp d f) es
    
    | Fun (xts, re) -> ext_dsl_exp d re (* TODO *)
    
    | Let (x, e1, e2) -> let d' = ext_dsl_exp d e1 in
                         ext_dsl_exp d' e2
    end

let optimize (d : dsl) (es : exp list) : dsl = d

let ext_dsl_corpus ( (_, ity), oty, es : corpus) : dsl =
    let d = ity, oty, List.fold_left ext_dsl_exp TMap.empty es in
    optimize d es
