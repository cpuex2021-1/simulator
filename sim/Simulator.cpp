#include "Simulator.hpp"
#include "util.hpp"
#include <iostream>
#include <iomanip>
#include <map>

using namespace std;

Simulator::Simulator(unsigned int memsize, unsigned int cachesize, int pc_)
{
    pc = pc_;
    clk = 0;
    mem = new Memory(memsize, cachesize);
    reg = new int[REGNUM];
    reg[2] = memsize-1;
    freg = new int[FREGNUM];
}

Simulator::~Simulator(){
    delete mem;
    delete reg;
    delete freg;
}

void Simulator::simulate(unsigned int instr)
{
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    switch (op)
    {
    case 0:
    {
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);
        unsigned int funct11 = getBits(instr, 21, 11);
        
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d funct11:%d\n", op, funct3, rd, rs1, rs2, funct11);
        #endif

        switch (funct3)
        {
        case 0:
            switch (funct11)
            {
            case 0:
                reg[rd] = (int)reg[rs1] + (int)reg[rs2];
                pc++; return; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                pc++; return; break;
            default:
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            pc++; return; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                pc++; return; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                pc++; return; break;
            default:
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            pc++; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            pc++; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            pc++; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            pc++; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 1:
    {
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] * (int)reg[rs2];
            pc++; return; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            pc++; return; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; return; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; return; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            pc++; return; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            pc++; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            pc++; return; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 2:
    {
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = fadd(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 1:
            freg[rd] = fsub(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 2:
            freg[rd] = fmul(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 3:
            freg[rd] = fdiv(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 4:
            freg[rd] = fsqrt(freg[rs1]);
            pc++; return; break;
        case 5:
            freg[rd] = fneg(freg[rs1]);
            pc++; return; break;
        case 6:
            freg[rd] = fmin(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 7:
            freg[rd] = fmax(freg[rs1], freg[rs2]);
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 3:
    {
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = feq(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 1:
            freg[rd] = flt(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 2:
            freg[rd] = fle(freg[rs1], freg[rs2]);
            pc++; return; break;
        case 3:
            reg[rd] = freg[rs1];
            pc++; return; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 4:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        int imm = getSextBits(instr, 21, 6);
        int shamt = getSextBits(instr, 10, 6);
        unsigned int judge = getBits(instr, 11, 11);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] + imm;
            pc++; return; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            pc++; return; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            pc++; return; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            pc++; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            pc++; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            pc++; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            pc++; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 5:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        int offset = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; return; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; return; break;
        case 2:
            reg[rd] = ((rs1 << 16) + offset) << 12;
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 6:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);
        int imm = getSextBits(instr, 26, 11);

        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            if((int)reg[rs1] == (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            return; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            pc++; return; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            pc++; return; break;
        default:
            break;
        }
        break;
    }
    case 7:
    {
        int addr = getSextBits(instr, 30, 6);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        int imm = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc += addr;
            return; break;
        case 1:
            reg[rd] = pc + 1;
            pc += imm;
            return; break;
        case 2:
            reg[rd] = pc + 4;
            pc = reg[rs1] + imm;
            return; break;
        default:
            break;
        }
        break;
    }
    default:
        break;
    }

    cout << "Invalid Instruction:";
    print_instruction(instr);
    exit(1);
    return;
}

map<int, string> xregName = {
    {0, "zero"},
    {1, "ra"},
    {2, "sp"},
    {3, "gp"},
    {4, "tp"},
    {5, "t0"},
    {6, "t1"},
    {7, "t2"},
    {8, "s0/fp"},
    {9, "s1"},
    {10, "a0"},
    {11, "a1"},
    {12, "a2"},
    {13, "a3"},
    {14, "a4"},
    {15, "a5"},
    {16, "a6"},
    {17, "a7"},
    {18, "s2"},
    {19, "s3"},
    {20, "s4"},
    {21, "s5"},
    {22, "s6"},
    {23, "s7"},
    {24, "s8"},
    {25, "s9"},
    {26, "s10"},
    {27, "s11"},
    {28, "t3"},
    {29, "t4"},
    {30, "t5"},
    {31, "t6"}
};

map<int, string> fregName = {
    {0, "ft0"},
    {1, "ft1"},
    {2, "ft2"},
    {3, "ft3"},
    {4, "ft4"},
    {5, "ft5"},
    {6, "ft6"},
    {7, "ft7"},
    {8, "fs0"},
    {9, "fs1"},
    {10, "fa0"},
    {11, "fa1"},
    {12, "fa2"},
    {13, "fa3"},
    {14, "fa4"},
    {15, "fa5"},
    {16, "fa6"},
    {17, "fa7"},
    {18, "fs2"},
    {19, "fs3"},
    {20, "fs4"},
    {21, "fs5"},
    {22, "fs6"},
    {23, "fs7"},
    {24, "fs8"},
    {25, "fs9"},
    {26, "fs10"},
    {27, "fs11"},
    {28, "ft8"},
    {29, "ft9"},
    {30, "ft10"},
    {31, "ft11"}
};

void Simulator::print_register(){
    for(int i=0; i<REGNUM; i++){
    if(i % 8 == 0 && i > 0) cout << endl;
        cout << left << setw(5) << xregName[i] << ":" << right << setw(11) << reg[i] << " ";
    }
    cout << endl;
    for(int i=0; i<FREGNUM; i++){
        if(i % 8 == 0 && i>0) cout << endl;
        cout << left << setw(5) << fregName[i] << ":" << right << setw(11) << freg[i] << " ";
    }
    cout << endl;
}