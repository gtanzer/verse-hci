type binop =
| Add
| Sub

type ty =
| TBool
| TInt
| TStr
| TFun of ty list * ty
| TPair of ty * ty

type exp =
| CBool of bool
| CInt of int
| CStr of string
| Bop of binop * exp * exp
| Id of string
| App of exp * exp list
| Fun of (string * ty) list * exp
| Let of string * exp * exp

type corpus = (string * ty) * ty * exp list
