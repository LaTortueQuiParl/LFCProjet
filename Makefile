CFLAGS= -lfl -o
DEBUGFLAGS = -Wall
LEX=etape4.lex
OBJ=y.tab.c lex.yy.o
YACC=etape4.yacc
BIN=analyseurProjet
LBIN=analyseurLex

.PHONY: all fcheck

all:
	@yacc $(YACC)
	@yacc -d $(YACC)
	@lex $(LEX)
	@gcc -c lex.yy.c
	@gcc $(OBJ) $(CFLAGS) $(BIN)
	./$(BIN) < test.txt

lex: $(LEX)
	@lex $^
	@gcc -c lex.yy.c
	@gcc lex.yy.o $(CFLAGS) $(LBIN)
	@./$(LBIN) < test.txt > output.txt
	@diff -y output.txt outlex.txt

clean:
	rm $(OBJ) $(BIN)  lex.yy.c y.tab.h