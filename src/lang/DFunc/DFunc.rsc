module lang::DFunc::DFunc

lexical Ident = [a-zA-Z][a-zA-Z]*  !>> [a-zA-Z0-9];
lexical Natural = [0-9]+  !>> [0-9];
lexical LAYOUT = [\t-\n\r\ ];
layout LAYOUTLIST = LAYOUT*  !>> [\t-\n\r\ ];

start syntax Prog = prog: Letg* ";;" Exp ;
syntax Letg = letg: "let" Ident "=" Exp "end" LAYOUTLIST;

syntax Exp =
    var: Ident LAYOUTLIST
    | nat: Natural LAYOUTLIST
    | bracket "(" Exp ")" LAYOUTLIST
    | let: "let" Ident "=" Exp "in" Exp "end" LAYOUTLIST
    | cond: "if" Exp "then" Exp "else" Exp "end" LAYOUTLIST
    | func: "fun" Ident "-\>" Exp
    > non-assoc (
        left mul: Exp "*" Exp 
        | non-assoc div: Exp "/" Exp 
        | non-assoc md: Exp "%" Exp 
    )
    > left (
        left add: Exp "+" Exp 
        | left sub: Exp "-" Exp 
    )
    > non-assoc (
        non-assoc eq: Exp "=" Exp 
        | non-assoc gt: Exp "\>" Exp 
        | non-assoc lt: Exp "\<" Exp 
        | non-assoc geq: Exp "\>=" Exp 
        | non-assoc leq: Exp "\<=" Exp
    )
    > app: Ident "(" {Exp ","}* ")" LAYOUTLIST
    > right seq: Exp ";" Exp
    ;
