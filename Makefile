
all:
	make -C asm
	make -C sim -f sim/OldMakefile
	cp asm/assembler ./
	cp sim/simulator ./

clean:
	make clean -C asm
	make clean -C sim -f sim/OldMakefile
	make clean -C OreOre-V/build
	rm -f assembler simulator gui-simulator memResult.txt

gui:
	mkdir -p OreOre-V/build
	qmake -o OreOre-V/build/Makefile OreOre-V/OreOre-V.pro
	sed s/-O2/-O3/g < OreOre-V/build/Makefile | sed s/-O1/-O3/g > OreOre-V/build/Makefile_New
	mv OreOre-V/build/Makefile_New OreOre-V/build/Makefile
	make -C OreOre-V/build
	cp OreOre-V/build/OreOre-V ./gui-simulator

fver:
	make -C sim fverify
	cp sim/fverify ./

exec-gui:gui
	./gui-simulator