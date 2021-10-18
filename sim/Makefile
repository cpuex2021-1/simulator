all:debug

simulator:util.hpp util.cpp FPU.hpp FPU.cpp Memory.hpp Memory.cpp Simulator.hpp Simulator.cpp main.cpp
	g++ -O3 -Wall -o simulator *.cpp

debug:util.hpp util.cpp FPU.hpp FPU.cpp Memory.hpp Memory.cpp Simulator.hpp Simulator.cpp main.cpp
	g++ -g -DDEBUG -Wall -o simulator *.cpp

.PHONY:clean
clean:
	rm -rf simulator