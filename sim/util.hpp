#pragma once
#include <vector>
#include <fstream>
#include <string>
#include <map>
#include "../asm/Parse.hpp"
#include "../asm/Instructions.hpp"

inline int getBits(int num, int start, int end){
    return ((num >> end) & ((1 << (start - end + 1)) - 1));
}
inline int getSextBits(int num, int start, int end){
    return ((num >> end) & ((1 << (start - end + 1)) - 1)) | \
    (((((num >> start) & 1) << (32 - (start - end + 1))) - ((num >> start) & 1)) << (start - end + 1));
}
void print_instruction(unsigned int instr);
void get_filesize(std::fstream& f, unsigned long long& fsize);
void setup(std::vector<int>& instr, std::vector<std::string>& str_instr, std::map<std::string, unsigned int>& labels, std::string filename, bool isasm);
string joking_face();
void print_instr(unsigned int instr);
double elapsed();