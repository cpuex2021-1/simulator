#include "Profiler.hpp"

Profiler::Profiler()
: Simulator(), sectid(0)
{}

int Profiler::genSectid(int p){
    if(sectid_list[p] > 0){
        return sectid;
    }   
    sectid++;
    return sectid;
}

void Profiler::initLabellist(int p){
    if(p >= instructions.size()) {
        return;
    }
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
        case 2:
        {
            //if(p + 1 < instructions.size()) label_list[p + 1] = 1;
        }       
        default:
            break;
        }
    }

    default:
        break;
    }

    initLabellist(p + 1);
}

void Profiler::initSectId(int p, int sect){
    if(p >= instructions.size()){
        return;
    }
    if(sectid_list[p] > 0){
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
            initSectId(p + 1, genSectid(p + 1));
            initSectId(p + imm, genSectid(p + imm));
        }else{
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
            initSectId(p + addr, genSectid(p + addr));
            break;
        }
        case 1:
        {
            int imm = getSextBits(instr, 21, 6);
            initSectId(p + 1, genSectid(p + 1));
            initSectId(p + imm, genSectid(p + imm));
            break;
        }
        case 2:
        {
            break;
        }
        default:
            initSectId(p + 1, sect);
            break;
        }
    }

    default:
        initSectId(p + 1, sect);
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
    initLabellist(0);
    initSectId(0, genSectid(0));
}

void Profiler::print_sectionid_summary(){
    for(int i=0; i<instructions.size(); i++){
        cout << str_instr[pc_to_line(i)] << "\t" << sectid_list[i] << endl;
    }
}
