# Variables
LEX = flex
YACC = bison
CC = gcc
CFLAGS = -Werror

# Build rules
all: rebuild

10_A3.tab.c 10_A3.tab.h: 10_A3.y
	$(YACC) -d 10_A3.y

lex.yy.c: 10_A3.l
	$(LEX) 10_A3.l

parser: lex.yy.c 10_A3.tab.c 10_A3.tab.h
	$(CC) $(CFLAGS) -c 10_A3.c -o 10_A3.o
	$(CC) $(CFLAGS) -c lex.yy.c -o lex.yy.o
	$(CC) $(CFLAGS) -o parser 10_A3.c lex.yy.c 10_A3.tab.c

build: parser

clean:
	rm -f parser lex.yy.c 10_A3.tab.* *.o

rebuild:
	make clean
	make build

test-all:
	./parser < 10_A3.nc
	./parser < ./tests/test1.nc
	./parser < ./tests/test2.nc
	./parser < ./tests/test3.nc
	./parser < ./tests/test4.nc
	./parser < ./tests/test5.nc
	./parser < ./tests/test6.nc
	./parser < ./tests/test7.nc
	./parser < ./tests/test8.nc
	./parser < ./tests/test9.nc
	./parser < ./tests/test10.nc