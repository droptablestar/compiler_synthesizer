module lang::Func::Parse
import lang::Func::Func;
import ParseTree;
import IO;
public Prog parse(loc l) = parse(#Prog, l);
public Prog parse(str s) = parse(#Prog, s);

