CC=g++
CFLAGS=-g -std=c++17

all: assembler

assembler:main.cpp Instructions.cpp Parse.cpp
	$(CC) $(CFLAGS) -o assembler Parse.cpp Instructions.cpp main.cpp

.PHOMY:clean
clean:
	rm -rf assembler