#include "Parse.hpp"
#include "Instructions.hpp"
#include "Assembler.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
#include <ios>
#include <cassert>
#include <regex>
#include <string>
#include <map>

using namespace std;

Assembler Asm;

int main(int argc, char* argv[]){
    if(argc < 3) {
        cout << "Usage: assembler [input file] [output file]" << endl;
        exit(1);
    }
    Asm.read_asm(argv[1]);
    Asm.write_to_file(argv[2]);
}