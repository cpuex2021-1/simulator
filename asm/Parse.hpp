
#pragma once
#include "Instructions.hpp"
#include <string>
#include <map>
#include <regex>
using namespace std;

typedef enum {label, instruction, none, error} LineTypes;

void debug_parse();

class Parse
{
public:
    Parse(string);
    int type;
    uint32_t code;
    string labl;

    void print_instr();
};

