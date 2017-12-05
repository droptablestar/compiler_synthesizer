module lang::DFunc::Load
import lang::DFunc::AST;
import lang::DFunc::Parse;
import ParseTree;

public Prog load(loc l) = implode(#Prog, parse(l));
public Prog load(str s) = implode(#Prog, parse(s));
