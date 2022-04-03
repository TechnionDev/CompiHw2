%{
    #include <stdlib.h>
    #include <stdio.h>
    #include "tokens.hpp"

    char current_str[1025];
    int current_str_length = 0;

    void error_unclosed_string() {
        printf("Error unclosed string\n");
        exit(0);
    }

    void error_undefined_escape(char escape_char) {
        printf("Error undefined escape sequence %c\n", escape_char);
        exit(0);
    }

    void error_undefined_hex_escape(char non_hex1, char non_hex2) {
        printf("Error undefined escape sequence x%c%c\n", non_hex1, non_hex2);
        exit(0);
    }
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
{whitespace}                        ;
(void)                              return VOID;
(int)                               return INT;
(byte)                              return BYTE;
(b)                                 return B;
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
(\/\/[^\n\r]+)                      return COMMENT;
((==)|(!=)|(\<=)|(\>=)|(\<)|(\>))   return RELOP;
((\+)|(\-)|(\*)|(\/))               return BINOP;
({letter}({letter}|{digit})*)       return ID;
(0|{nozerodigit}{digit}*)           return NUM;
\"                                  BEGIN(IN_STRING);
<IN_STRING>[\n\0]                   error_unclosed_string();
<IN_STRING>\\\"                     error_unclosed_string();
<IN_STRING>\\[^x\\"nrt0]            error_undefined_escape(yytext[1]);
<IN_STRING>\\x[^0-9a-fA-F]{2}       error_undefined_hex_escape(yytext[2], yytext[3]);
<IN_STRING>\\{escapechars}          {
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
<IN_STRING>{printableascii}         current_str[current_str_length++] = *yytext;
<IN_STRING>{xdd}                    {
                                        char *ptr;
                                        char *current_xdd = yytext;
                                        char current_hex;

                                        current_xdd[0] = '0';
                                        current_hex = (char) strtol(current_xdd, &ptr, 16);
                                        current_str[current_str_length++] = current_hex;
                                    }
<IN_STRING>\"                       {
                                        BEGIN(INITIAL);
                                        current_str[current_str_length] = '\0';
                                        current_str_length = 0;
                                        return STRING;
                                    }
.                                   return -1;
%%