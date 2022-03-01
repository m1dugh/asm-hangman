CC=nasm
CFLAGS=-felf64 -g
LK=gcc
# LK=ld
LFLAGS=-no-pie
# LFLAGS=-e main -lc -I /lib/ld-linux-x86-64.so.2

SRC=main.asm utils/strings.asm
OBJ_FOLDER=obj
OBJ=$(SRC:%.asm=$(OBJ_FOLDER)/%.o)
BIN_FOLDER=bin
BIN=$(BIN_FOLDER)/program

DBG=gdb
DFLAGS=-quiet

.PHONY: clean build run

all: clean run

debug: clean link
	@$(DBG) $(DFLAGS) $(BIN) 

run: link
	@clear
	@./$(BIN)

link: $(OBJ)
	@mkdir -p $(BIN_FOLDER)
	$(LK) -o $(BIN) $^ $(LFLAGS)

build: $(OBJ)

$(OBJ_FOLDER)/%.o: %.asm
	@NAME=$(shell echo $@ | awk -F/ '{for(i=1;i<NF;i++) printf "%s/", $$i; printf "\n"}'); mkdir -p $$NAME
	$(CC) $(CFLAGS) -o $@ $< 

clean:
	@rm -rf $(OBJ_FOLDER) $(BIN_FOLDER)
