#include <iostream>
#include <fstream>
#include "Simulator.hpp"
#include "util.hpp"

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
    int filesize;
    get_filesize(input, filesize);

    unsigned int instr;

    while(sim.pc < filesize){
        #ifdef DEBUG
            cout << "PC:" << sim.pc << endl << "Instruction:";
            print_instruction(instr);
            for(int i=0; i<REGNUM; i++){
                cout << "x" << i << ":" << sim.reg[i] << " ";
            }
            cout << endl;
            for(int i=0; i<FREGNUM; i++){
                cout << "f" << i << ":" << sim.freg[i] << " ";
            }
            cout << endl;
        #endif

        input.seekg((sim.pc / 4) * sizeof(unsigned int));
        input.read((char *) &instr, sizeof(unsigned int));
        sim.simulate(instr);    
        
        #ifdef DEBUG
        cout << endl;
        #endif
    }

    fstream regres, memres;

    regres.open("registerResult.txt", ios::out);
    memres.open("memoryResult.txt", ios::out);

    for(int i=0; i<REGNUM; i++){
        regres << "x" << i << ":" << sim.reg[i] << endl;
    }
    for(int i=0; i<FREGNUM; i++){
        regres << "f" << i << ":" << sim.freg[i] << endl;
    }

    for(int i=0; i<MEMSIZE; i+=4){
        memres << "0x" << hex << i << ":" << hex << sim.mem->read(i) << endl;
    }
}