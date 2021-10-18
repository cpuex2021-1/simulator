#include <iostream>
#include <fstream>
#include <iomanip>
#include "Simulator.hpp"
#include "util.hpp"

#define MEMSIZE (1 << 25)
#define CACHESIZE (1 << 12)

using namespace std;

Simulator sim(MEMSIZE, CACHESIZE, 0);

int main(int argc, char* argv[]){
    if(argc < 2){
        cout << "Usage: simulator [binary file] [register data output file] [memory data output file]" << endl;
        exit(0);
    }

    fstream input;
    input.open(string(argv[1]), ios::in | ios::binary);
    int filesize;
    get_filesize(input, filesize);

    unsigned int instr;

    while(sim.pc < filesize){
        #ifdef DEBUG
            cout << "PC:" << sim.pc << endl << "Instruction:";
            for(int i=0; i<REGNUM; i++){
                if(i % 8 == 0 && i>0) cout << endl;
                cout << "x" << i << ":" << sim.reg[i] << " ";
            }
            cout << endl;
            for(int i=0; i<FREGNUM; i++){
                if(i % 8 == 0 && i>0) cout << endl;
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

    fstream regres;
    string regfilename = (argc < 4) ? "registerResult.txt" : string(argv[3]);
    string memfilename = (argc < 4) ? "memResult.txt" : string(argv[4]);
    regres.open("registerResult.txt", ios::out);

    for(int i=0; i<REGNUM; i++){
        regres << "x" << i << ":" << sim.reg[i] << endl;
    }
    for(int i=0; i<FREGNUM; i++){
        regres << "f" << i << ":" << sim.freg[i] << endl;
    }

    sim.mem->print_memory(memfilename);
}