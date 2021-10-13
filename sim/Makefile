all:simulator

simulator:util.hpp util.cpp FPU.hpp FPU.cpp Memory.hpp Memory.cpp Simulator.hpp Simulator.cpp main.cpp
	g++ -O3 -Wall -o simulator *.hpp *.cpp

debug:util.hpp util.cpp FPU.hpp FPU.cpp Memory.hpp Memory.cpp Simulator.hpp Simulator.cpp main.cpp
	g++ -g -DDEBUG -Wall -o simulator *.hpp *.cpp

.PHONY:clean
clean:
	rm -rf simulator