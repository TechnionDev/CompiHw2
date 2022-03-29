%{
    #include <stdlib.h>
    #include "tokens.hpp"
%}

%option yylineno
%option noyywrap


digit           ([0-9])
nozerodigit     ([1-9])
letter          ([a-zA-Z])
whitespace      ([\t\n\r ])
xdd             (\\x[0-9A-Fa-f]{2})
escapechars     (\\[\\"nrt0])
printableascii  ([\x20-\x7E])


%%
{whitespace}                                    ;
(void)                                          return VOID;
(int)                                           return INT;
(byte)                                          return BYTE;
(b)                                             return B;
(and)                                           return AND;
(or)                                            return OR;
(not)                                           return NOT;
(true)                                          return TRUE;
(false)                                         return FALSE;
(return)                                        return RETURN;
(if)                                            return IF;
(else)                                          return ELSE;
(while)                                         return WHILE;
(break)                                         return BREAK;
(continue)                                      return CONTINUE;
(\;)                                            return SC;
(\,)                                            return COMMA;
(\()                                            return LPAREN;
(\))                                            return RPAREN;
(\{)                                            return LBRACE;
(\})                                            return RBRACE;
(=)                                             return ASSIGN;
(\/\/[^\n\r]+)                                  return COMMENT;
((==)|(!=)|(\<=)|(\>=)|(\<)|(\>))               return RELOP;
((\+)|(\-)|(\*)|(\/))                           return BINOP;
({letter}({letter}|{digit})*)                   return ID;
(0|{nozerodigit}{digit}*)                       return NUM;
(\"({xdd}|{escapechars}|{printableascii})*\")   return STRING;
.                                               return -1;
%%