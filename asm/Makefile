CC=g++
CFLAGS= -Wall -std=c++17

all: assembler

assembler:main.cpp Instructions.cpp Parse.cpp
	$(CC) $(CFLAGS) -O3 -o assembler Parse.cpp Instructions.cpp main.cpp

debug:main.cpp Instructions.cpp Parse.cpp
	$(CC) $(CFLAGS) -g -DDEBUG -o assembler main.cpp Instructions.cpp Parse.cpp

.PHOMY:clean
clean:
	rm -rf assembler *.o