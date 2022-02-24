all: translator packer

CC=g++
CFLAGS= -O3 -Wall -std=c++17


translator: Translator.cpp
	$(CC) $(CFLAGS) $^ -o $@

packer: Packer.cpp
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm packer translator