
#pragma once
#include "Instructions.hpp"
#include <string>
#include <map>
#include <regex>
#include <vector>
using namespace std;

typedef enum {label, instruction, none, error} LineTypes;

void Debug_parse(string);

class Parse
{
public:
    Parse(string, bool label_only, int now_addr);
    int type;
    vector<uint32_t> codes;
    string labl;
    int size;

    void print_instr();
};

