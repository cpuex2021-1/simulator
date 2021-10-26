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
        exit(1);
    }
    fstream input;
    fstream output;
    string infile(argv[1]);
    string outfile(argv[2]);

    input.open(infile, ios::in);
    output.open(outfile, ios::binary | ios::out);

    string str;
    while(getline(input, str)){
        Parse pres(str, true, now_addr);
        if(pres.type == label){
            labels[pres.labl] = now_addr;
            line_num++;
        }else if(pres.type == error){
            cerr << "Parsing Error at line " << line_num << endl;
            exit(1);
        }else if(pres.type == none){
            line_num++;
        }else{
            line_num++;
            now_addr += 1;
        }
    }
    input.close();
    output.close();

    input.open(infile, ios::in);
    output.open(outfile, ios::binary | ios::out);

    output.write(reinterpret_cast<char *>(now_addr), sizeof(now_addr));

    line_num = 1;
    now_addr = 0;

    while(getline(input, str)){
        #ifdef DEBUG
        cout << "line:" << line_num << " ";
        Debug_parse(str);
        #endif

        Parse pres(str, false, now_addr);
        if(pres.type == instruction){
            #ifdef DEBUG
            pres.print_instr();
            #endif
            output.write(reinterpret_cast<char *>(&pres.code), sizeof(pres.code));
            line_num++;
            now_addr += 1;
        }else if(pres.type == none || pres.type == label){
            line_num++;
        }else if(pres.type == error){
            cerr << "Parsing Error at line " << line_num << endl;
            exit(1);
        }
    }
    input.close();
    output.close();
}