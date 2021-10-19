all:
	make debug -C asm
	make -C sim
	cp asm/assembler ./
	cp sim/simulator ./

clean:
	make clean -C asm
	make clean -C sim
	rm -f assembler simulator