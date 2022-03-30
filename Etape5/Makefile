CFLAGS= -lfl -o
DEBUGFLAGS = -Wall
LEX=etape5.lex
OBJ=y.tab.c lex.yy.o
YACC=etape5.yacc
BIN=analyseurProjet
LBIN=analyseurLex

.PHONY: all fcheck


all:
	@yacc -d $(YACC)
	@lex $(LEX)
	@gcc -c lex.yy.c
	@gcc $(OBJ) $(CFLAGS) $(BIN)
	./$(BIN) < test.txt

t:
	lex tmp.lex
	@gcc -c lex.yy.c
	@gcc lex.yy.o $(CFLAGS) $(BIN)
	./$(BIN) < test.txt

clean:
	rm $(OBJ) $(BIN)  lex.yy.c y.tab.h