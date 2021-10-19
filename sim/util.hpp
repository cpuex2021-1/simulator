
#include <fstream>

int getBits(int num, int start, int end, bool sext);
void print_instruction(unsigned int instr);
void get_filesize(std::fstream& f, unsigned long long& fsize);