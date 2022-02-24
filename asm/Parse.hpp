
#pragma once
#include "Instructions.hpp"
#include <string>
#include <map>
#include <regex>
#include <vector>
using namespace std;

void Debug_parse(string);

class Parse
{
private:
    int32_t label_to_addr(string str, int32_t now_addr);
    uint32_t regname_to_addr(string str);

    //label exception
    class label_not_found : public invalid_argument{
    public:
        label_not_found(string _Message)
        : invalid_argument(_Message)
        {}
    };
    
    class invalid_instruction : public invalid_argument{
    public:
        invalid_instruction(string _Message)
        : invalid_argument(_Message)
        {}
    };    

public:
    //instruction types
    enum {b_j, alu, fpu, uart, ma, nop};

    //parsing results
    enum {label, instruction, unresolved, none, error};

    Parse(string, int32_t now_addr);

    //parsing result type
    int32_t type;
    
    string labl;

    uint32_t code;
    int8_t codetype;

    const int8_t reg_dfl = -1;
    int8_t writetoreg;

    void print_instr();
};

