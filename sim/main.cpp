#include <iostream>
#include <fstream>
#include "Simulator.hpp"

#define MEMSIZE (1024 << 10)
#define CACHESIZE (128 << 10)

using namespace std;

Simulator sim(MEMSIZE, CACHESIZE, 0);

int main(int argc, char* argv[]){
    if(argc < 2){
        cout << "Usage: simulator [binary file]" << endl;
    }

    fstream input;
    input.open(string(argv[1]), ios::in | ios::binary);

    unsigned int instr;
    

    while(!input.seekg(sim.pc / 4 * sizeof(unsigned int)).fail()){
        input.read((char *) &instr, sizeof(unsigned int));       
        sim.simulate(instr);
    }

    fstream regres, memres;

    regres.open("registerResult.txt", ios::out);
    memres.open("memoryResult.txt", ios::out);

    for(int i=0; i<REGNUM; i++){
        regres << "x" << i << ":" << sim.reg[i] << endl;
    }
    for(int i=0; i<REGNUM; i++){
        regres << "f" << i << ":" << sim.freg[i] << endl;
    }

    for(int i=0; i<MEMSIZE; i++){
        memres << "0x" << hex << i << ":" << hex << sim.mem->read(i) << endl;
    }
}