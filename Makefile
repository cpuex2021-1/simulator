all:
	make -C asm
	make -C sim
	cp asm/assembler ./
	cp sim/simulator ./

clean:
	make clean -C asm
	make clean -C sim
	rm -f assembler simulator memResult.txt

gui:
	mkdir -p OreOre-V/build
	qmake -o OreOre-V/build/Makefile OreOre-V/OreOre-V.pro
	make -C OreOre-V/build
	cp OreOre-V/build/OreOre-V ./gui-simulator

exec-gui:gui
	./gui-simulator