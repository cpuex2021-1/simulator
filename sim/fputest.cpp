#include "Simulator.hpp"
#include "../asm/Instructions.hpp"
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>

Simulator sim;

typedef enum{SIN, COS, ATAN} type;
using namespace std;

int mode;

int main(int argc, char* argv[]){

    if(argc > 1){
        if(string(argv[1]) == "sin"){
            mode = SIN;
        }else{
            mode = COS;
        }
    }else{
        cout << "Usage: fverify [mode]" << endl;
        exit(0);
    }

    sim.isasm = true;
    string fname = (mode == SIN)? "fsin.s" : "fcos.s";
    sim.read_asm(fname);

    typedef union{
        float f;
        int i;
    } fi;

    fi a;

    for(a.f = -4 * M_PI; a.f <= 4 * M_PI; a.f += 0.01){

        sim.freg[regs["fa0"]] = a.i;
        sim.run();
        fi res;
        res.i = sim.freg[regs["fa0"]];
        sim.reset();
        float real = (mode == SIN)? std::sin(a.f) : std::cos(a.f);

        cout << "x: " << a.f << " real: " << real << " res: " << res.f << " diff: " << fabs(real - res.f) << endl;
    }
}
