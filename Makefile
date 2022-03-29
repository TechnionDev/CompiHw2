CC = g++
COMP_FLAG = -std=c++11
SOURCE = hw1.cpp tokens.hpp lex.yy.c
OBJS = hw1.o lex.yy.o
EXECS = hw1.out

all: hw1.out

hw1.out: hw1.o
	${CC} ${COMP_FLAG} ${OBJS} -o $@

hw1.o: hw1.cpp lex.yy.o
	${CC} ${COMP_FLAG} -c ${SOURCE}

lex.yy.o: lex.yy.c tokens.hpp
	${CC} ${COMP_FLAG} -c lex.yy.c

lex.yy.c: scanner.lex
	flex scanner.lex

clean:
	rm -f ${OBJS} ${EXEC} lex.yy.c tokens.hpp