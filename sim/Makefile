all:simulator
CC=g++
CFLAGS= -O3 -Wall -std=c++17 -o simulator 

simulator:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp

prof:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -pg ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp

gdb:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -g ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp
	
debug:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -DDEBUG ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp

fverify:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) -O3 -Wall -std=c++17 -o fverify ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp fputest.cpp util.cpp
clean:
	rm -f simulator