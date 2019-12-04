open Tc

let _ = tc_corpus (("x", TStr), TStr, [App (Id "substring", [Id "x"; CInt 2; CInt 3])])
