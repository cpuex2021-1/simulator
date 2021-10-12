all:simulator

simulator:FPU.hpp FPU.cpp Memory.hpp Memory.cpp Simulator.hpp Simulator.cpp main.cpp
	g++ -g -Wall -o simulator *.hpp *.cpp

.PHONY:clean
clean:
	rm -rf simulator