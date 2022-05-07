%{
    #include <stdlib.h>
    #include <stdio.h>
    #include "output.hpp"
    #include "parser.tab.hpp"
%}

%option yylineno
%option noyywrap

digit           ([0-9])
nozerodigit     ([1-9])
letter          ([a-zA-Z])
whitespace      ([\t\n\r ])
escapechars     ([\\"nrt0])

%%
{whitespace}                        ;
(void)                              return VOID;
(int)                               return INT;
(byte)                              return BYTE;
(b)                                 return B;
(bool)                              return BOOL;
(auto)                              return AUTO;
(and)                               return AND;
(or)                                return OR;
(not)                               return NOT;
(true)                              return TRUE;
(false)                             return FALSE;
(return)                            return RETURN;
(if)                                return IF;
(else)                              return ELSE;
(while)                             return WHILE;
(break)                             return BREAK;
(continue)                          return CONTINUE;
(\;)                                return SC;
(\,)                                return COMMA;
(\()                                return LPAREN;
(\))                                return RPAREN;
(\{)                                return LBRACE;
(\})                                return RBRACE;
(=)                                 return ASSIGN;
((\<=)|(\>=)|(\<)|(\>))             return RELOP;
((==)|(!=))                         return EQOP;
((\+)|(\-))                         return PLUSOP;
((\*)|(\/))                         return MULTOP;
(\/\/[^\r\n]*[ \r|\n|\r\n]?)        ; // Handle comment
({letter}({letter}|{digit})*)       return ID;
(0{digit}+)                         output::errorLex(yylineno);
(0|{nozerodigit}{digit}*)           return NUM;
(\"([^\n\r\"\\]|\\[rnt"\\])+\")     return STRING;
.                                   output::errorLex(yylineno);
%%

