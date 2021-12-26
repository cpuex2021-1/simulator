
all:cli gui

clean:
	make clean -C build
	rm -f assembler simulator gui-simulator memResult.txt

cli:
	mkdir -p build
	rm -f build/CMakeCache.txt
	cmake -S ./OreOre-V-CMake-JIT -B build
	make -C build assembler
	make -C build cli-simulator
	cp build/assembler assembler
	cp build/cli-simulator cli-simulator

gui:
	mkdir -p build
	rm -f build/CMakeCache.txt
	cmake -S ./OreOre-V-CMake-JIT -B build
	make -C build gui-simulator
	cp build/gui-simulator gui-simulator

ninja:
	mkdir -p build
	rm -f build/CMakeCache.txt
	cmake -GNinja -S ./OreOre-V-CMake-JIT -B build
	ninja -C build
	cp build/assembler assembler
	cp build/cli-simulator cli-simulator
	cp build/gui-simulator gui-simulator		

fver:
	make -C sim fverify
	cp sim/fverify ./

exec-gui:gui
	./gui-simulator