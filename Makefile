
all:cli gui

clean:
	make clean -C build
	rm -f assembler simulator gui-simulator memResult.txt

cli:
	mkdir -p build
	cmake -S ./ -B build
	make -C build assembler
	make -C build simulator
	cp build/assembler assembler
	cp build/simulator simulator

gui:
	mkdir -p build
	cmake -S ./ -B build
	make -C build gui-simulator

fver:
	make -C sim fverify
	cp sim/fverify ./

exec-gui:gui
	./gui-simulator