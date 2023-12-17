CC = gcc
CFLAGS = -g -std=gnu17
WFLAGS = -Wpedantic -Wextra -Wall -Werror
LEX = flex

.PHONY: clean

all: scanner

scanner: lex.yy.c
	$(CC) $(CFLAGS) -o $@ $^

lex.yy.c: scanner.l
	$(LEX) $^

clean:
	rm -rf *.o lex.yy.c scanner
