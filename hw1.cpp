#include <string>
#include <iostream>
#include "tokens.hpp"

using std::string;
using std::cout;
using std::endl;

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
    cout << current_str << endl;
}
