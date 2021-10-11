
#pragma once
#include "Instructions.hpp"
#include <string>
#include <map>
#include <regex>
using namespace std;

typedef enum {label, instruction, none, error} LineTypes;

void Debug_parse(string);

class Parse
{
public:
    Parse(string, bool label_only, int now_addr);
    int type;
    uint32_t code;
    string labl;

    void print_instr();
};

