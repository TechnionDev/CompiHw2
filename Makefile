CC = g++
COMP_FLAG = -std=c++11
SOURCE = hw1.cpp tokens.hpp lex.yy.c
OBJS = hw1.o lex.yy.o
EXECS = hw1.out
ZIP_NAME = amiti_gurt_hw1.zip

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
	rm -f ${OBJS} ${EXEC} lex.yy.c tokens.hpp tests/*.res

zip: scanner.lex hw1.cpp
	zip ${ZIP_NAME} scanner.lex tokens.hpp hw1.cpp

test: hw1.out
	./hw1.out < tests/t1.in > tests/t1.res
	./hw1.out < tests/t2.in > tests/t2.res
	./hw1.out < tests/t3.in > tests/t3.res
	./hw1.out < tests/t4.in > tests/t4.res
	./hw1.out < tests/t5.in > tests/t5.res
	./hw1.out < tests/t6.in > tests/t6.res
	./hw1.out < tests/t7.in > tests/t7.res
