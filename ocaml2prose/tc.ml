open Ast
open Prose

let ti_binop (bop : binop) : (ty * ty) * ty =
    begin match bop with
    | Add | Sub -> (TInt, TInt), TInt
    end

let rec ti_exp (c : ty Ctxt.t) (e : exp) : ty =
    begin match e with
    | CBool _ -> TBool
    | CInt _ -> TInt
    | CStr _ -> TStr
    
    | Bop (bop, e1, e2) -> let (t1, t2), t3 = ti_binop bop in
                           tc_exp c t1 e1;
                           tc_exp c t2 e2;
                           t3
                           
    | Id x -> if Ctxt.mem x c
              then Ctxt.find x c
              else failwith (Printf.sprintf "undefined reference '%s'" x)
              
    | App (f, es) -> let t = ti_exp c f in
                     begin match t with
                     | TFun (ts, rt) -> List.iter2 (tc_exp c) ts es;
                                        rt
                     | _ -> failwith "tried to apply a non-function"
                     end
                      
    | Fun (xts, e) -> let ts = List.map snd xts in
                      let rt = ti_exp (List.fold_left (fun c (x, t) -> Ctxt.add x t c) c xts) e in
                      TFun (ts, rt)
                      
    | Let (x, e1, e2) -> let t = ti_exp c e1 in
                         ti_exp (Ctxt.add x t c) e2
    end
    
and tc_exp (c : ty Ctxt.t) (t : ty) (e : exp) : unit =
    if ti_exp c e = t then () else failwith "type error"

let tc_corpus ( (x, ity), oty, es : corpus) : unit =
    List.iter (tc_exp (Ctxt.add x ity stdlib) oty) es
