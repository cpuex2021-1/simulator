#ifndef ASSEMBLER_H_INCLUDED
#define ASSEMBLER_H_INCLUDED

#include "Instructions.hpp"
#include "Parse.hpp"
#include <string>
#include <fstream>
#include <queue>

#define VLIW_SIZE 4

using namespace std;

class Reader
{
private:
    class tobeAssembled{
    public:
        int32_t addr;
        string str;
        int8_t slot;
        tobeAssembled():addr(0), str(0), slot(0){}
        tobeAssembled(int32_t a, string s, int8_t sl):addr(a), str(s), slot(sl){}
    };

    const vector<vector<bool>> slotPolicy = {
        {true, true, true, false, false, true},
        {false, true, true, false, false, true},
        {false, false, false, true, true, true},
        {false, false ,false, false, true, true}
    };

    const bool checkSlotPolicy(int8_t slot, int8_t codetype){
        return slotPolicy[slot][codetype];
    }

    const vector<string> slotTypeName = {
        "Branch/Jump",
        "ALU",
        "FPU",
        "UART",
        "Memory Access",
        "NOP"
    };

    class vliw_slot_policy_violation : public invalid_argument{
    public:
        vliw_slot_policy_violation(string _Message)
        : invalid_argument(_Message)
        {}
    };
    
    class vliw_not_alingned : public invalid_argument{
    public:
        vliw_not_alingned(string _Message)
        : invalid_argument(_Message)
        {}
    };

protected:
    queue<tobeAssembled> unresolved;
    static vector<int> l_to_p;
    static vector<int> p_to_l;



    void read_one_line(int32_t &line_num, int32_t &now_addr, string str, int8_t &slot);

    class pcandlabel{
    public:
        uint32_t pc;
        string label;
        pcandlabel()
        :pc(0), label("")
        {}
        pcandlabel(uint32_t p, string l)
        :pc(p), label(l)
        {};
    };

    //debugging info (label position)
    bool hasDebuggingInfo;
    vector<pcandlabel> labellist;

public:
    class parsing_error : public invalid_argument{
    public:
        parsing_error(string _Message)
        : invalid_argument(_Message)
        {}
    };
    vector<uint32_t> instructions;
    static vector<string> str_instr;
    Reader();
    void write_to_file(string filename);
    int read_asm(string filename);
    int eat_bin(string filename);
    void export_debugging_info(string filename);
    void import_debugging_info(string filename);
    int line_to_pc(int l);
    int pc_to_line(int p);
    void full_reset();
};

#endif
