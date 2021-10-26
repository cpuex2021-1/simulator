#include <vector>
#include <fstream>
#include <string>
#include <map>
#include "Parse.hpp"
#include "Instructions.hpp"

#define getBits(num, start, end) ((num >> end) & ((1 << (start - end + 1)) - 1))
#define getSextBits(num, start, end) ((num >> end) & ((1 << (start - end + 1)) - 1)) | \
    (((((num >> start) & 1) << (32 - (start - end + 1))) - ((num >> start) & 1)) << (start - end + 1))

void print_instruction(unsigned int instr);
void get_filesize(std::fstream& f, unsigned long long& fsize);
void setup(std::vector<int>& instr, std::map<std::string, unsigned int>& labels, std::string filename, bool isasm);
string joking_face();
void print_instr(unsigned int instr);
double elapsed();