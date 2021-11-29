all:
	make -C asm
	make -C sim
	cp asm/assembler ./
	cp sim/simulator ./

clean:
	make clean -C asm
	make clean -C sim
	make clean -C OreOre-V/build
	rm -f assembler simulator gui-simulator memResult.txt

gui:
	mkdir -p OreOre-V/build
	qmake -o OreOre-V/build/Makefile OreOre-V/OreOre-V.pro
	sed s/-O2/-O3/g < OreOre-V/build/Makefile | sed s/-O1/-O3/g > OreOre-V/build/Makefile_New
	mv OreOre-V/build/Makefile_New OreOre-V/build/Makefile
	make -C OreOre-V/build
	cp OreOre-V/build/OreOre-V ./gui-simulator

build-windows-on-linux:
	~/git/mxe/usr/bin/i686-w64-mingw32.static-qmake-qt5 -o OreOre-V/build/Makefile_for_Windows_on_linux OreOre-V/OreOre-V.pro
	sed s/-O2/-O3/g < OreOre-V/build/Makefile_for_Windows_on_linux | sed s/-O1/-O3/g > OreOre-V/build/Makefile_New
	mv OreOre-V/build/Makefile_New OreOre-V/build/Makefile_for_Windows_on_linux
	make -f Makefile_for_Windows_on_linux -C OreOre-V/build 
	cp OreOre-V/build/OreOre-V ./gui-simulator

exec-gui:gui
	./gui-simulator