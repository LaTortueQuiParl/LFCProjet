CFLAGS= -lfl -o
DEBUGFLAGS = -Wall
SRC=etape2CORRIGE.lex
OBJ=lex.yy.c
BIN=analyseurProjet
OUT=output.txt

.PHONY: all fcheck

all: $(SRC)
	lex -v $^
	gcc $(OBJ) $(DEBUGFLAGS) $(CFLAGS) $(BIN)
	./$(BIN) $(BIN)

finalCheck: $(SRC)
	@lex $^
	@gcc $(OBJ) -o analyseurProjet -lfl
	@./$(BIN) < tests/exemple.txt > $(OUT)
	@diff -q tests/resultat.txt $(OUT)

dfc: $(SRC)
	@lex $^
	@gcc $(OBJ) -o analyseurProjet -lfl
	@./$(BIN) < tests/exemple.txt > $(OUT)
	@diff -y tests/resultat.txt $(OUT)

debugCheck: $(SRC)
	@lex -v $^
	@gcc $(OBJ) $(DEBUGFLAGS) $(CFLAGS) $(BIN)
	@./$(BIN) < tests/test.txt > $(OUT)
	diff -y tests/resultatTest.txt $(OUT)

check: $(SRC)
	@lex $^
	@gcc $(OBJ) $(CFLAGS) $(BIN)
	@./$(BIN) < tests/test.txt > $(OUT)
	diff -q tests/resultatTest.txt $(OUT)

clean:
	rm $(OBJ) $(OUT) $(BIN) 