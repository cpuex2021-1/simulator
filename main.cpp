#include "Parse.hpp"
#include "Instructions.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
#include <ios>
#include <cassert>
#include <regex>
#include <string>
#include <map>

using namespace std;

//globals
int line_num = 1;
int now_addr = 0x0;

int main(int argc, char* argv[]){
    if(argc < 3) {
        cout << "Usage: assembler [input file] [output file]" << endl;
    }
    fstream input;
    fstream output;
    string infile(argv[1]);
    string outfile(argv[2]);

    input.open(infile, ios::in);
    output.open(outfile, ios::binary | ios::out);

    string str;
    while(getline(input, str)){
        Parse pres(str);
        if(pres.type == label){
            cout << pres.labl << endl;
            labels[pres.labl] = now_addr;
            line_num++;
        }else if(pres.type == instruction){
            output.write(reinterpret_cast<char *>(&pres.code), sizeof(pres.code));
            line_num++;
            now_addr += 0x4;
        }else if(pres.type == none){
            line_num++;
        }else if(pres.type == error){
            cerr << "Parsing Error at line " << line_num << endl;
            break;
        }
    }
    input.close();
    output.close();
}