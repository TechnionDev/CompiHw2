%{
    #include <stdlib.h>
    #include <stdio.h>
    #include "tokens.hpp"

    int is_str_unclosed = 0;
    int is_str_undefined_escape = 0;
    int is_str_invalid_hex = 0;

    char current_str[1025];
    int current_str_length = 0;
%}

%option yylineno
%option noyywrap


digit           ([0-9])
nozerodigit     ([1-9])
letter          ([a-zA-Z])
whitespace      ([\t\n\r ])
xdd             (\\x[0-9A-Fa-f]{2})
escapechars     ([\\"nrt0])
printableascii  ([\x20-\x21\x23-\x5B\x5D-\x7E])

%x IN_STRING


%%
{whitespace}                                            ;
(void)                                                  return VOID;
(int)                                                   return INT;
(byte)                                                  return BYTE;
(b)                                                     return B;
(and)                                                   return AND;
(or)                                                    return OR;
(not)                                                   return NOT;
(true)                                                  return TRUE;
(false)                                                 return FALSE;
(return)                                                return RETURN;
(if)                                                    return IF;
(else)                                                  return ELSE;
(while)                                                 return WHILE;
(break)                                                 return BREAK;
(continue)                                              return CONTINUE;
(\;)                                                    return SC;
(\,)                                                    return COMMA;
(\()                                                    return LPAREN;
(\))                                                    return RPAREN;
(\{)                                                    return LBRACE;
(\})                                                    return RBRACE;
(=)                                                     return ASSIGN;
(\/\/[^\n\r]+)                                          return COMMENT;
((==)|(!=)|(\<=)|(\>=)|(\<)|(\>))                       return RELOP;
((\+)|(\-)|(\*)|(\/))                                   return BINOP;
({letter}({letter}|{digit})*)                           return ID;
(0|{nozerodigit}{digit}*)                               return NUM;
\"                                                      BEGIN(IN_STRING); printf("BEGIN\n");
<IN_STRING>\n                                           is_str_unclosed = 1; printf("is_str_unclosed\n");
<IN_STRING>\\[^x\\"nrt0]                                is_str_undefined_escape = 1; printf("is_str_undefined\n");
<IN_STRING>\\x[^0-9a-fA-F]{2}                           is_str_invalid_hex = 1; printf("is_str_invalid_hex\n");
<IN_STRING>\\{escapechars}                              {
                                                            char current_escape = yytext[1];
                                                            if (current_escape == 'n') current_str[current_str_length++] = '\n';
                                                            else if (current_escape == 'r') current_str[current_str_length++] = '\r';
                                                            else if (current_escape == 't') current_str[current_str_length++] = '\t';
                                                            else if (current_escape == '0') current_str[current_str_length++] = '\0';
                                                            else if (current_escape == '"') current_str[current_str_length++] = '"';
                                                            else {
                                                                current_str[current_str_length++] = '\\';
                                                                current_str[current_str_length++] = '\\';
                                                            }
                                                        }
<IN_STRING>({xdd}|{printableascii})                     current_str[current_str_length++] = *yytext;
<IN_STRING>\"                                           {
                                                            BEGIN(INITIAL);
                                                            current_str[current_str_length] = '\0';
                                                            current_str_length = 0;
                                                            is_str_unclosed = 0;
                                                            is_str_undefined_escape = 0;
                                                            is_str_invalid_hex = 0;
                                                            return STRING;
                                                        }
.                                                       return -1;
%%