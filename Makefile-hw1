CC = g++
GCC = gcc
COMP_FLAGS = -Wall -pedantic -Wextra -Wmissing-declarations
CPP_FLAGS = -std=c++11  ${COMP_FLAGS}
SOURCE = hw1.cpp tokens.hpp lex.yy.c
OBJS = hw1.o lex.yy.o
EXECS = hw1.out
ZIP_NAME = amiti_gurt_hw1.zip

all: hw1.out

hw1.out: hw1.o
	${CC} ${CPP_FLAGS} ${OBJS} -o $@

hw1.o: hw1.cpp lex.yy.o tokens.hpp
	${CC} ${CPP_FLAGS} -c ${SOURCE}

lex.yy.o: lex.yy.c tokens.hpp
	${GCC} ${COMP_FLAGS} -c lex.yy.c

lex.yy.c: scanner.lex
	flex --outfile=lex.yy.c scanner.lex

clean:
	rm -f ${OBJS} ${EXEC} lex.yy.c hw1-tests/*.res *.res hw1-tests/outsourced/*.res hw1.out *.o

zip: scanner.lex hw1.cpp tokens.hpp
	zip ${ZIP_NAME} scanner.lex tokens.hpp hw1.cpp

test: hw1.out
	./run_tests.sh
