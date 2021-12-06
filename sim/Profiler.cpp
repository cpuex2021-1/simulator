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
            label_list[p + imm] = 1;
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
            label_list[p + addr] = 1;
            break;
        }
        case 1:
        {
            int imm = getSextBits(instr, 21, 6);
            label_list[p + imm] = 1;
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

void Profiler::initSectId(int p, int sect){
    if(label_list[p] && sectid_list[p] > 0){
        return;
    }

    if(pc >= instructions.size()){
        return;
    }

    sectid_list[p] = sect;

    unsigned int instr = instructions[p];
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    switch (op)
    {
    case 6:
    {
        int imm = getSextBits(instr, 26, 11);
        if(funct3 >= 0 && funct3 <= 5){
            initSectId(p + imm, genSectid());
            initSectId(p + 1, sect);
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
            initSectId(p + addr, genSectid());
            break;
        }
        case 1:
        {
            int imm = getSextBits(instr, 21, 6);
            initSectId(p + imm, genSectid());
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

void Profiler::initProfiler(){
    if(!ready){
        return;
    }

    funcid_list = vector<int>(instructions.size(), 0);
    sectid_list = vector<int>(instructions.size(), 0);
    label_list = vector<int>(instructions.size(), 0);

    initSectId(0, genSectid());
}

void Profiler::print_sectionid_summary(){
    for(int i=0; i<instructions.size(); i++){
        cout << instructions[i] << "\t" << sectid_list[i] << endl;
    }
}