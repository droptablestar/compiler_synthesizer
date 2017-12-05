module lang::DFunc::Eval

import lang::DFunc::AST;
import lang::DFunc::Load;
import List;
import Map;
import IO;
alias Env = map[str, Exp];

public Exp eval(str p) {
    env = ();
    return eval(load(p).exp, env);
}

public Exp eval(loc l) {
    p = load(l);
    env = ( b.var : b.exp | b <- p.globs );
    return eval(p.exp, env);
}

public Exp eval(Prog p) {
    env = ( b.var : b.exp | b <- p.globs );
    return eval(p.exp, env);
}

public Exp eval(nat(int n), Env env) = nat(n);
public Exp eval(var(str name), Env env) {
    assert (size(domainR(env, {name})) != 0) :
    "ERROR: var: <name> not in current environment";
    return eval(env[name], env);
}
public Exp eval(seq(Exp e1, Exp e2), Env env) {eval(e1, env); return eval(e2, env);}
public Exp eval(cond(Exp cond, Exp then, Exp otherwise), Env env) =
    (eval(cond, env) != nat(0)) ? eval(then, env) : eval(otherwise, env);

public Exp eval(let(str var, Exp e0, Exp e1), Env env) {
    env += (var : e0);
    return eval(e1, env);
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

public Exp eval(func(str formal, Exp body), Env env) = func(formal, body);

public Exp eval(app(str fun, list[Exp] args), Env env) {
    // println("ARGS: <args>\n");
    assert (size(domainR(env, {fun})) != 0) :
    "ERROR: fun: <name> not in current environment";
    switch (env[fun]) {
        case func(str formal, Exp body): {
            // println("formal: <formal> body: <body> empty: <isEmpty(args)>\n");
            if (!isEmpty(args)) {
                // println("\n***shouldnt***\n");
                <a, args> = popp(args);
                new_env = env + (formal : eval(a,env));
                switch (body) {
                    case func(str f0, Exp b0): {
                        // println("f0: <f0> b0: <b0> empty:<isEmpty(args)>\n");
                        if (isEmpty(args)) return func(f0, b0);
                        else {
                            nm = "_"+formal+"_"+f0;
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

