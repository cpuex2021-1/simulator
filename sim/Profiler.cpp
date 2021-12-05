#include "Profiler.hpp"

Profiler::Profiler()
: Simulator(), sectid(0)
{}

Profiler::~Profiler()
{}

int Profiler::genSectid(){
    sectid++;
    return sectid;
}

void Profiler::initLabellist(int p){
    unsigned int instr = instructions[p];
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    switch (op)
    {
    case 6:
    {
        int imm = getSextBits(instr, 26, 11);
        if(funct3 >= 0 && funct3 <= 5){
            label_list[p + imm] = true;
        }
    }
        break;
    case 7:
    {
        switch (funct3)
        {
        case 0:
        {
            int addr = getSextBits(instr, 30, 6);
            label_list[p + addr] = true;
            break;
        }
        case 1:
        {
            int imm = getSextBits(instr, 21, 6);
            label_list[p + imm] = true;
            break;
        }        
        default:
            break;
        }
    }

    default:
        break;
    }
}

void Profiler::initSectId(int p){
    if(sectid_list[p] > 0){
        return
    }
}

void Profiler::initProfiler(){
    if(!ready){
        return;
    }
}