module lang::Func::Eval

import lang::Func::AST;
import lang::Func::Load;
import List;
import Map;
import IO;
alias Env = map[str, Exp];

public Exp eval(str p) {
    env = ();
    return eval(load(p).exp, env);
}

public Exp eval(loc l) = eval(load(l));

public Exp eval(Prog p) {
    env = ();
    for (b <- p.globs) {
        assert size(b.vars) == size(b.exps) : "Mismatched arguments to Letg";
        for (i <- [0..size(b.vars)])  env += ( b.vars[i] : b.exps[i] );
    }
    return eval(p.exp, env);
}

public Exp eval(nat(int n), Env env) = nat(n);
public Exp eval(var(str name), Env env) {
    assert (size(domainR(env, {name})) != 0) :
    "ERROR: var: <name> not in current environment";
    return eval(env[name], env);
}
public Exp eval(seq(Exp e1, Exp e2), Env env) {eval(e1, env); return eval(e2, env);}
public Exp eval(cond(Exp cond, Exp then, list[Elif] elifs, Exp otherwise), Env env) {
    if (eval(cond, env) != nat(0)) return eval(then, env);
    for (e <- elifs)
        if (eval(e.cond, env) != nat(0)) return eval(e.then, env);
    return eval(otherwise, env);
}

public Exp eval(let(list[str] vars, list[Exp] exps, Exp exp), Env env) {
    assert size(vars) == size(exps) : "Mismatched arguments to Let";
    for (i <- [0..size(vars)])  env += ( vars[i] : exps[i] );
    return eval(exp, env);
}
public Exp eval(mul(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return nat(n1*n2);
}
public Exp eval(div(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return nat(n1/n2);
}
public Exp eval(md(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return nat(n1%n2);
}
public Exp eval(add(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return nat(n1+n2);
}
public Exp eval(sub(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return nat(n1-n2);
}
public Exp eval(eq(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return (n1==n2) ? nat(1) : nat(0);
}
public Exp eval(gt(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return (n1>n2) ? nat(1) : nat(0);
}
public Exp eval(lt(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return (n1<n2) ? nat(1) : nat(0);
}
public Exp eval(geq(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return (n1>=n2) ? nat(1) : nat(0);
}
public Exp eval(leq(Exp e1, Exp e2), Env env) {
    <nat(n1), nat(n2)> = <eval(e1, env), eval(e2, env)>;
    return (n1<=n2) ? nat(1) : nat(0);
}

public Exp eval(func(list[str] formals, Exp body), Env env) = func(formals, body);

public Exp eval(app(str fun, list[Exp] args), Env env) {
    assert (size(domainR(env, {fun})) != 0) :
    "ERROR: fun: <fun> not in current environment";
    switch (env[fun]) {
        case func(list[str] formals, Exp body): {
            if (!isEmpty(args)) {
                assert size(formals) <= size(args) : "arguments to App";
                new_env = env;
                for (i <- [0..size(formals)]) new_env += ( formals[i] : eval(args[i], env) );
                args = drop(size(formals), args);
                switch (body) {
                    case func(list[str] f0s, Exp b0): {
                        // println("f0: <f0s> b0: <b0> empty:<isEmpty(args)>\n");
                        if (isEmpty(args)) return func(f0s, b0);
                        else {
                            nm = "_"+intercalate("",formals)+"_"+intercalate("",f0s);
                            new_env += (nm : body);
                            return eval(app(nm, args), new_env);
                        }
                    }
                    case _: return { eval(body, new_env); }
                }
            }
            else return func(formal, body);
        }
        case _: assert false : "App is not a function";
    }
}
public tuple[&T,list[&T]] popp(list[&T] li) = pop(li);

