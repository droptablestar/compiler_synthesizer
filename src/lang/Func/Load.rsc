module lang::Func::Load
import lang::Func::AST;
import lang::Func::Parse;
import ParseTree;

public Prog load(loc l) = implode(#Prog, parse(l));
public Prog load(str s) = implode(#Prog, parse(s));
