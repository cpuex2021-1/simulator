all:simulator
CC=g++
CFLAGS= -O3 -Wall -std=c++17 -o simulator -I ../include/asmjit/src -DASMJIT_STATIC
ASMJIT_SRC_DIR=../include/asmjit/src/asmjit
ASMJIT_SRC=$(ASMJIT_SRC_DIR)/x86/*.cpp $(ASMJIT_SRC_DIR)/core/*.cpp $(ASMJIT_SRC_DIR)/*.h

simulator:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp $(ASMJIT_SRC)

prof:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -pg ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp

gdb:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -g ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp
	
debug:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) $(CFLAGS) -DDEBUG ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp main.cpp util.cpp

fverify:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) -O3 -Wall -std=c++17 -o fverify ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp fputest.cpp util.cpp

proftest:*.cpp *.hpp ../asm/Instructions.cpp ../asm/Parse.cpp
	$(CC) -g -Wall -std=c++17 -o proftest ../asm/Instructions.cpp ../asm/Parse.cpp CPU.cpp Memory.cpp Simulator.cpp fpu.cpp proftest.cpp util.cpp Profiler.cpp

clean:
	rm -f simulator