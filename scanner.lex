%{
    #include <stdlib.h>
    #include <stdio.h>
    #include "tokens.hpp"
    #include "output.hpp"

    char current_str[1025];
    int current_str_length = 0;

    void error_unclosed_string();
    void error_undefined_escape(char escape_char);
    void error_undefined_hex_escape(char non_hex1, char non_hex2);
    void error_unprintable_char(char bad_char);
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
((==)|(!=)|(\<=)|(\>=)|(\<)|(\>))   return RELOP;
((\+)|(\-)|(\*)|(\/))               return BINOP;
(\/\/[^\n\r]*)                      return COMMENT;
({letter}({letter}|{digit})*)       return ID;
(0{digit}+)                         error_unprintable_char(*yytext);
(0|{nozerodigit}{digit}*)           return NUM;
\"                                  BEGIN(IN_STRING);
<IN_STRING>[\n\r]                   error_unclosed_string();
<IN_STRING>\\[^x\\"nrt0]            error_undefined_escape(yytext[1]);
<IN_STRING>\\{escapechars}          {
                                        char current_escape = yytext[1];
                                        switch(current_escape) {
                                            case 'n':
                                                current_str[current_str_length++] = '\n';
                                                break;
                                            case 'r':
                                                current_str[current_str_length++] = '\r';
                                                break;
                                            case 't':
                                                current_str[current_str_length++] = '\t';
                                                break;
                                            case '0':
                                                current_str[current_str_length++] = '\0';
                                                break;
                                            case '"':
                                                current_str[current_str_length++] = '"';
                                                break;
                                            case '\\':
                                                current_str[current_str_length++] = '\\';
                                                break;
                                        }
                                    }
<IN_STRING>{printableascii}         current_str[current_str_length++] = *yytext;
<IN_STRING>{xdd}                    {
                                        char *ptr;
                                        char current_xdd[3] = {yytext[2], yytext[3], '\0'};
                                        int current_hex;
                                        current_hex = strtol(current_xdd, &ptr, 16);
                                        if (current_hex >= 0x00 && current_hex <= 0x7F) {
                                            current_str[current_str_length++] = (char) current_hex;
                                        } else {
                                            error_undefined_hex_escape(current_xdd[0], current_xdd[1]);
                                        }
                                    }
<IN_STRING>(\\x[^"]{2})             error_undefined_hex_escape(yytext[2], yytext[3]);
<IN_STRING>(\\x[^"])                error_undefined_hex_escape(yytext[2], '\0');
<IN_STRING>(\\x)                    error_undefined_hex_escape('\0', '\0');
<IN_STRING>\"                       {
                                        BEGIN(INITIAL);
                                        current_str[current_str_length] = '\0';
                                        current_str_length = 0;
                                        return STRING;
                                    }
<IN_STRING><<EOF>>                  error_unclosed_string();
<IN_STRING>.                        error_unprintable_char(*yytext);
.                                   return -1;
%%

void error_unclosed_string() {
    printf("Error unclosed string\n");
    exit(0);
}

void error_undefined_escape(char escape_char) {
    printf("Error undefined escape sequence %c\n", escape_char);
    exit(0);
}

void error_undefined_hex_escape(char non_hex1, char non_hex2) {
    if (non_hex1 != '\0' && non_hex2 != '\0') {
        printf("Error undefined escape sequence x%c%c\n", non_hex1, non_hex2);
    } else if (non_hex1 != '\0') {
        printf("Error undefined escape sequence x%c\n", non_hex1);
    } else {
        printf("Error undefined escape sequence x\n");
    }
    exit(0);
}

void error_unprintable_char(char bad_char) {
    printf("Error %c\n", bad_char);
    exit(0);
}
