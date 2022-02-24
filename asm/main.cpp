#include "Parse.hpp"
#include "Instructions.hpp"
#include "Reader.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
#include <ios>
#include <cassert>
#include <regex>
#include <string>
#include <map>

using namespace std;

Reader Asm;

int main(int argc, char* argv[]){
    if(argc < 3) {
        cout << "Usage: assembler [input file] [output file]" << endl;
        exit(1);
    }
    try{
        Asm.read_asm(argv[1]);
    }catch(exception &e){
        cerr << e.what() << endl;
        exit(0);
    }
    Asm.write_to_file(argv[2]);
    Asm.export_debugging_info("debuginfo.txt");
    cerr << "[INFO] Debugging information written in debuginfo.txt" << endl;
}