#include <string>
#include <iostream>
#include "tokens.hpp"

using std::string;
using std::cout;
using std::endl;

extern int is_str_unclosed;
extern int is_str_undefined_escape;
extern int is_str_invalid_hex;
extern char current_str[1025];

const char *token_type_string[] = {
    "",
    "VOID",
    "INT",
    "BYTE",
    "B",
    "BOOL",
    "AND",
    "OR",
    "NOT",
    "TRUE",
    "FALSE",
    "RETURN",
    "IF",
    "ELSE",
    "WHILE",
    "BREAK",
    "CONTINUE",
    "SC",
    "COMMA",
    "LPAREN",
    "RPAREN",
    "LBRACE",
    "RBRACE",
    "ASSIGN",
    "RELOP",
    "BINOP",
    "COMMENT",
    "ID",
    "NUM",
    "STRING",
    "AUTO"
};

void print_invalid_token();
void print_token(int token);
void print_comment_token();
void print_string_token();

int main()
{
	int token;

	while ((token = yylex())) {
        if (token == -1) {
            print_invalid_token();
            exit(0);
        } else {
            print_token(token);
        }
	}

	return 0;
}

void print_invalid_token() {
    cout << "Error " << yytext << endl;
}

void print_token(int token) {
    cout << yylineno << " " << token_type_string[token] << " ";

    if (token == COMMENT) {
        print_comment_token();
    } else if (token == STRING) {
        print_string_token();
    } else {
        cout << yytext << endl;
    }
}

void print_comment_token() {
    cout << "//" << endl;
}

void print_string_token() {
    bool did_fail = is_str_unclosed || is_str_undefined_escape || is_str_invalid_hex;

    if (is_str_unclosed) {
        cout << "Error unclosed string" << endl;
    } else if (is_str_undefined_escape || is_str_invalid_hex) {
        cout << "Error undefined escape sequence" << yytext[1] << endl;
    }

    if (did_fail) {
        exit(0);
    }

    printf(current_str); // will it work? maybe we need to concat in scanner.lex
    cout << endl;
}
