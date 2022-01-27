#ifndef ASSEMBLER_H_INCLUDED
#define ASSEMBLER_H_INCLUDED

#include "Instructions.hpp"
#include "Parse.hpp"
#include <string>
#include <fstream>
#include <queue>

using namespace std;

class Reader
{
protected:
    class tobeAssembled{
    public:
        int addr;
        string str;
        tobeAssembled():addr(0), str(0){}
        tobeAssembled(int a, string s):addr(a), str(s){}
    };
    queue<tobeAssembled> unresolved;
    inline static vector<int> l_to_p;
    inline static vector<int> p_to_l;
    void read_one_line(int &line_num, int &now_addr, string str);

    class pcandlabel{
    public:
        uint32_t pc;
        string label;
        pcandlabel(uint32_t p, string l)
        :pc(p), label(l)
        {};
    };

    vector<pcandlabel> labellist;

public:
    class parsing_error : public invalid_argument{
    public:
        parsing_error(string _Message)
        : invalid_argument(_Message)
        {}
    };
    vector<uint32_t> instructions;
    inline static vector<string> str_instr;
    void write_to_file(string filename);
    int read_asm(string filename);
    int eat_bin(string filename);
    int line_to_pc(int l);
    int pc_to_line(int p);
    void full_reset();
};

#endif
