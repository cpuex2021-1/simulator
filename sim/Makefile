all:simulator
CC=g++
CFLAGS= -O3 -Wall -std=c++17 -o simulator 

simulator:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) ../asm/Instructions.cpp ../asm/Parse.cpp *.cpp

prof:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -pg ../asm/Instructions.cpp ../asm/Parse.cpp *.cpp

gdb:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -g ../asm/Instructions.cpp ../asm/Parse.cpp *.cpp
	
debug:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -DDEBUG ../asm/Instructions.cpp ../asm/Parse.cpp *.cpp

clean:
	rm -f simulator