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
	cd OreOre-V/build
	qmake ../OreOre-V.pro
	make
	cd ../../

exec-gui:gui
	./OreOre-V/build/OreOre-V