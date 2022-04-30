#include "output.hpp"

#include <iostream>
#include <sstream>
#include <string>

#include "parser.tab.hpp"
#include "tokens.hpp"

using std::cout;
using std::endl;
using std::string;
namespace output {

const std::string rules[] = {
    "Program -> Funcs",
    "Funcs -> epsilon",
    "Funcs -> FuncDecl Funcs",
    "FuncDecl -> RetType ID LPAREN Formals RPAREN LBRACE Statements RBRACE",
    "RetType -> Type",
    "RetType ->  VOID",
    "Formals -> epsilon",
    "Formals -> FormalsList",
    "FormalsList -> FormalDecl",
    "FormalsList -> FormalDecl COMMA FormalsList",
    "FormalDecl -> Type ID",
    "Statements -> Statement",
    "Statements -> Statements Statement",
    "Statement -> LBRACE Statements RBRACE",
    "Statement -> Type ID SC",
    "Statement -> Type ID ASSIGN Exp SC",
    "Statement -> AUTO ID ASSIGN Exp SC",
    "Statement -> ID ASSIGN Exp SC",
    "Statement -> Call SC",
    "Statement -> RETURN SC",
    "Statement -> RETURN Exp SC",
    "Statement -> IF LPAREN Exp RPAREN Statement",
    "Statement -> IF LPAREN Exp RPAREN Statement ELSE Statement",
    "Statement -> WHILE LPAREN Exp RPAREN Statement",
    "Statement -> BREAK SC",
    "Statement -> CONTINUE SC",
    "Call -> ID LPAREN ExpList RPAREN",
    "Call -> ID LPAREN RPAREN",
    "ExpList -> Exp",
    "ExpList -> Exp COMMA ExpList",
    "Type -> INT",
    "Type -> BYTE",
    "Type -> BOOL",
    "Exp -> LPAREN Exp RPAREN",
    "Exp -> Exp BINOP Exp",
    "Exp -> ID",
    "Exp -> Call",
    "Exp -> NUM",
    "Exp -> NUM B",
    "Exp -> STRING",
    "Exp -> TRUE",
    "Exp -> FALSE",
    "Exp -> NOT Exp",
    "Exp -> Exp AND Exp",
    "Exp -> Exp OR Exp",
    "Exp -> Exp RELOP Exp",
    "Exp -> LPAREN Type RPAREN Exp"};

void printProductionRule(const int ruleno) {
    std::cout << ruleno << ": " << rules[ruleno - 1] << "\n";
    std::cerr << ruleno << ": " << rules[ruleno - 1] << "\n";
}

void printProductionRule(const int ruleno, const char* val) {
    std::cout << ruleno << ": " << rules[ruleno - 1] << "\n" << val << endl;
}

void errorLex(const int lineno) {
    std::cout << "line " << lineno << ": lexical error\n";
}

void errorSyn(const int lineno) {
    std::cout << "line " << lineno << ": syntax error\n";
}

int yyerror(const char* s) {
    cout << "line " << yylineno << ": " << s << endl;
    exit(1);
}
}  // namespace output