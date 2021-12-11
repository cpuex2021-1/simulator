#include "CPU.hpp"

using namespace std;

CPU::CPU()
{
    pc = 0;
    clk = 0;
    mem = new Memory();
    reg = new int[REGNUM + FREGNUM];
    freg = &reg[REGNUM];
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0; freg[i] = 0;
    }
    reg[2] = MEMSIZE-1;
}

CPU::~CPU(){
    delete mem;
    delete reg;
}

map<int, string> xregName{
    {0, "zero"},
    {1, "ra"},
    {2, "sp"},
    {3, "hp"},
    {4, "cl"},
    {5, "sw"},
    {6, "a0"},
    {7, "a1"},
    {8, "a2"},
    {9, "a3"},
    {10, "a4"},
    {11, "a5"},
    {12, "a6"},
    {13, "a7"},
    {14, "a8"},
    {15, "a9"},
    {16, "a10"},
    {17, "a11"},
    {18, "a12"},
    {19, "a13"},
    {20, "a14"},
    {21, "a15"},
    {22, "a16"},
    {23, "a17"},
    {24, "a18"},
    {25, "a19"},
    {26, "a20"},
    {27, "a21"},
    {28, "a22"},
    {29, "r0"},
    {30, "r1"},
    {31, "r2"}
};

map<int, string> fregName {
    {0, "fzero"},
    {1, "fsw"},
    {2, "f0"},
    {3, "f1"},
    {4, "f2"},
    {5, "f3"},
    {6, "f4"},
    {7, "f5"},
    {8, "f6"},
    {9, "f7"},
    {10, "f8"},
    {11, "f9"},
    {12, "f10"},
    {13, "f11"},
    {14, "f12"},
    {15, "f13"},
    {16, "f14"},
    {17, "f15"},
    {18, "f16"},
    {19, "f17"},
    {20, "f18"},
    {21, "f19"},
    {22, "f20"},
    {23, "f21"},
    {24, "f22"},
    {25, "f23"},
    {26, "f24"},
    {27, "f25"},
    {28, "f26"},
    {29, "fr0"},
    {30, "fr1"},
    {31, "fr2"}
};

void CPU::print_register(){
    cout << " ";
    for(int i=0; i<REGNUM; i++){
    if(i % 8 == 0 && i > 0) cout << endl << " ";
        cout << left << setw(6) << xregName[i] + ":" << hex << right << setw(8) << reg[i] << " " << dec;
    }
    cout << endl << " ";
    for(int i=0; i<FREGNUM; i++){
        if(i % 8 == 0 && i>0) cout << endl << " ";
        cout << left << setw(6) << fregName[i] + ":" << hex << right << setw(8) << freg[i] << " " << dec;
    }
    cout << endl;
}

void CPU::reset(){
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0;
    }
    for(int i=0; i<FREGNUM; i++){
        freg[i] = 0;
    }
    reg[2] = (1 << 25)-2;
    pc = 0;
    clk = 0;
    mem->reset();
    p.reset();
    log.reset();
}


void CPU::throw_err(int instr){
    stringstream sserr;
    sserr << "Invalid_instruction: ";
    for(int i=31; i>=0; i--){
        sserr << (instr >> i & 1);
    }
    sserr << endl;
    throw invalid_argument(sserr.str());
}


void CPU::revert(){
    if(log.logSize <= 0) return;
    auto logd = log.pop();
    if(logd.isreg){
        if(logd.index){
            reg[logd.index] = logd.former_val;
        }
    }else{
        mem->write_without_cache(logd.index, logd.former_val);
    }

    pc = logd.pc;

    p.revert(pc, clk);
}