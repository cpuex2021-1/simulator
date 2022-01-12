#include "Profiler.hpp"
#include "../asm/Instructions.hpp"
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>

Profiler sim;

int mode;

int main(int argc, char* argv[]){
    string fname = string(argv[1]);
    sim.read_asm(fname);
    sim.initProfiler();
    sim.print_sectionid_summary();
}