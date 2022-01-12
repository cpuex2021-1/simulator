
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
    int label_to_addr(string str, int now_addr);
    int regname_to_addr(string str);

    //label exception
    class label_not_found : public invalid_argument{
    public:
        label_not_found(string _Message)
        : invalid_argument(_Message)
        {}
    };
public:
    typedef enum {label, instruction, unresolved, none, error} LineTypes;
    Parse(string, int now_addr);
    int type;
    vector<uint32_t> codes;
    string labl;
    int size;

    void print_instr();
};

