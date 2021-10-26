all:simulator
CC=g++
CFLAGS= -O3 -Wall -o simulator 

simulator:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) ../asm/Instructions.cpp ../asm/Parse.cpp *.cpp



clean:
	rm -f simulator