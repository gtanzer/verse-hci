%{
open Ast
%}

/* Declare your tokens here. */
%token EOF
%token <int64>  INT
%token <string> STRING
%token <string> IDENT

%token TINT     /* int */
%token TSTRING  /* string */
%token COMMA    /* , */
%token PLUS     /* + */
%token DASH     /* - */
%token EQ       /* = */
%token LPAREN   /* ( */
%token RPAREN   /* ) */
%token TBOOL    /* bool */
%token TRUE
%token FALSE
%token LET
%token IN
%token INPUT
%token OUTPUT
%token SEMICOLON
%token AT

%left PLUS DASH
%nonassoc LPAREN

/* ---------------------------------------------------------------------- */

%start corpus
%type <(string * Ast.ty) * Ast.ty * Ast.exp list> corpus
%type <string * Ast.ty> input
%type <Ast.ty> output
%type <Ast.exp> exp
%type <Ast.ty> ty
%%

corpus:
| AT i=input AT o=output es=separated_list(SEMICOLON,let_exp) EOF { i, o, es }

ty:
| TINT {TInt}
| TBOOL {TBool}
| TSTRING {TStr}

input:
| INPUT t=ty id=IDENT  { (id, t) }

output:
| OUTPUT t=ty { t }

let_exp:
| LET id=IDENT EQ e1=exp IN e2=let_exp {Let(id, e1, e2)}
| e=exp {e}

exp:
| LPAREN e=exp RPAREN {e}
| TRUE {CBool true}
| FALSE {CBool false}
| i=INT {CInt (Int64.to_int i)}
| s=STRING {CStr s}
| e1=exp b=bop e2=exp {Bop(b, e1, e2)}
| id=IDENT {Id id}
| f=exp LPAREN es=separated_list(COMMA, exp) RPAREN {App (f, es)}

%inline bop:
| PLUS   { Add }
| DASH   { Sub }
