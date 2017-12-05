module lang::DFunc::AST

data Prog = prog(list[Letg] globs, Exp exp);
data Letg = letg(str var, Exp exp);

data Exp =
    var(str name)
    | nat(int nat)
    | let (str var, Exp exp, Exp exp)
    | cond(Exp cond, Exp then, Exp otherwise)
    | func(str formal, Exp body)
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
