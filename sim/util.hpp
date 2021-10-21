#include <vector>
#include <fstream>
#include <string>
#include <map>
#include "Parse.hpp"
#include "Instructions.hpp"

int getBits(int num, int start, int end);
int getSextBits(int num, int start, int end);
void print_instruction(unsigned int instr);
void get_filesize(std::fstream& f, unsigned long long& fsize);
void setup(std::vector<int>& instr, std::map<std::string, unsigned int>& labels, std::string filename, bool isasm);
string joking_face();
void print_instr(unsigned int instr);