
all:cli gui

clean:
	make clean -C build
	rm -f assembler simulator gui-simulator memResult.txt build/CMakeCache.txt

cli:
	mkdir -p build
	cmake -B build
	make -C build assembler
	make -C build cli-simulator
	make -C build simple-simulator
	cp build/assembler assembler
	cp build/cli-simulator cli-simulator
	cp build/simple-simulator simple-simulator
	cp build/disassembler disassembler

gui:
	mkdir -p build
	cmake  -B build
	make -C build gui-simulator
	cp build/gui-simulator gui-simulator

ninja:
	mkdir -p build
	cmake -GNinja  -B build
	ninja -C build
	cp build/assembler assembler
	cp build/cli-simulator cli-simulator
	cp build/simple-simulator simple-simulator
	cp build/gui-simulator gui-simulator	
	cp build/disassembler disassembler	

fver:
	make -C sim fverify
	cp sim/fverify ./

exec-gui:gui
	./gui-simulator