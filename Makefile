.PHONY: all clean

all: clean
	flex scanner.lex
	bison -d parser.ypp
	g++ -std=c++17 *.c *.cpp -o hw2
clean:
	rm -f lex.yy.c
	rm -f parser.tab.*pp
	rm -f hw2

zip:
	zip amiti_gurt_hw2.zip scanner.lex parser.ypp output.hpp tokens.hpp output.cpp