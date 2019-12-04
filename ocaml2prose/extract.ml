open Ast
open Dsl
open Prose
open Typecheck

let update_union y oz =
    begin match oz with
    | Some z -> Some (Rule.add y z)
    | None -> Some (Rule.singleton y)
    end

let insert x y m : Rule.t TMap.t = TMap.update x (update_union y) m

let rec ext_dsl_exp (d : Rule.t TMap.t) (e : exp) : Rule.t TMap.t =
    begin match e with
    | CBool b -> insert TBool OVBool d
    | CInt i -> insert TInt OVInt d
    | CStr s -> insert TStr (OCStr s) d
    
    | Bop (bop, e1, e2) -> let d' = insert (snd (ti_binop bop)) (OBop0 bop) d in
                           let d'' = ext_dsl_exp d' e1 in
                           ext_dsl_exp d'' e2

    | Id x -> if Ctxt.mem x stdlib
              then let t = Ctxt.find x stdlib in
                   begin match t with
                   | TFun (ts, rt) -> insert (rt) (OOp0 (List.assoc x stdnames)) d
                   | _ -> failwith "all stdlib ids are functions"
                   end
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
