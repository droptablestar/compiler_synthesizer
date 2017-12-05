module lang::DFunc::Parse
import lang::DFunc::DFunc;
import ParseTree;

public Prog parse(loc l) = parse(#Prog, l);
public Prog parse(str s) = parse(#Prog, s);

