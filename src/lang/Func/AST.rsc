module lang::Func::AST

data Prog = prog(list[Letg] globs, Exp exp);
data Letg = letg(list[str] vars, list[Exp] exps);
data Elif = elif(Exp cond, Exp then);

data Exp =
    var(str name)
    | nat(int nat)
    | let(list[str] vars, list[Exp] exps, Exp exp)
    | cond(Exp cond, Exp then, list[Elif] elifs, Exp otherwise)
    | func(list[str] formals, Exp body)
    | app(str fun, list[Exp] args)
    | seq(Exp lhs, Exp rhs)

    | mul(Exp lhs, Exp rhs)
    | div(Exp lhs, Exp rhs)
    | md(Exp lhs, Exp rhs)
    | add(Exp lhs, Exp rhs)
    | sub(Exp lhs, Exp rhs)
    | eq(Exp lhs, Exp rhs)
    | gt(Exp lhs, Exp rhs)
    | lt(Exp lhs, Exp rhs)
    | geq(Exp lhs, Exp rhs)
    | leq(Exp lhs, Exp rhs)
    ;
