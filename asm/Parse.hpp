
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
public:
    typedef enum {label, instruction, unresolved, none, error} LineTypes;
    Parse(string, int32_t now_addr);
    int32_t type;
    vector<uint32_t> codes;
    string labl;
    int32_t size;

    void print_instr();
};

