all:simulator
CC=g++
CFLAGS= -O3 -pg -Wall -o simulator 

simulator:*.cpp *.hpp
	$(CC) $(CFLAGS) *.cpp

clean:
	rm -f simulator