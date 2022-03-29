#include <string>
#include <iostream>
#include "tokens.hpp"

using std::string;
using std::cout;
using std::endl;

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
        } else {
            print_token(token);
        }
	}

	return 0;
}

void print_invalid_token() {
    // TODO: implement
    // TODO: consider pushing an "exit(-1)" after print if necessary
}

void print_token(int token) {
    cout << yylineno << " " << token << " ";

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
    // TODO: implement
}
