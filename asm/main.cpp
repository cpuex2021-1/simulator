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
int now_addr = 0x2;

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
        }else if(pres.type == instruction){
            line_num++;
            now_addr += pres.size;
        }
    }
    input.close();
    output.close();

    input.open(infile, ios::in);
    output.open(outfile, ios::binary | ios::out);

    output.write(reinterpret_cast<char *>(&now_addr), sizeof(now_addr));
    
    stringstream init_ra_str1;
    init_ra_str1 << "\tlui ra, " << ((now_addr) >> 12);

    stringstream init_ra_str2;
    init_ra_str2 << "\taddi ra, ra, " << ((now_addr) & ((1 << 12) - 1));

    Parse init_ra1(init_ra_str1.str(), false, 0);
    Parse init_ra2(init_ra_str2.str(), false, 0);

    line_num = 1;
    now_addr = 0;
    
    
    output.write(reinterpret_cast<char *>(&init_ra1.codes[0]), sizeof(now_addr));
    line_num++;
    now_addr++;

    output.write(reinterpret_cast<char *>(&init_ra2.codes[0]), sizeof(now_addr));
    line_num++;
    now_addr++;

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
            for(unsigned int i = 0; i < pres.codes.size(); i++){
                output.write(reinterpret_cast<char *>(&pres.codes[i]), sizeof(pres.codes[i]));
                now_addr += 1;
            }
            line_num++;
        }else if(pres.type == none || pres.type == label){
            line_num++;
        }else if(pres.type == error){
            cerr << "Parsing Error at line " << line_num << endl;
            exit(1);
        }
    }

    //output.seekp(-sizeof(uint32_t), ios_base::cur);
    //output.write(reinterpret_cast<char *>(0), sizeof(uint32_t));

    input.close();
    output.close();
}