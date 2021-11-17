#pragma once
#include "Memory.hpp"
#include "fpu.hpp"
#include "util.hpp"
#include <iostream>
#include <iomanip>
#include <map>
#define REGNUM 32
#define FREGNUM 32

#define CACHESTALL 20
#define DATAHAZARD 1
#define BRANCH 2

class CPU
{
private:
    int* reg;
    int* freg;
    typedef enum{IF, DC, MA1, MA2, WB} STAGE;
    int dests[5];
    int srcs[5][2];
public:
    unsigned long long pc;
    unsigned long long clk;
    Memory* mem;
    FPU fpu;
    CPU(unsigned int memsize, unsigned int cachesize, int pc);
    ~CPU();
    inline void simulate(unsigned int instr);
    void print_register();
    void reset();
};


inline void CPU::simulate(unsigned int instr)
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
                pc++; reg[0] = 0; return; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                pc++; reg[0] = 0; return; break;
            default:
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                pc++; reg[0] = 0; return; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                pc++; reg[0] = 0; return; break;
            default:
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
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
            pc++; reg[0] = 0; return; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; return; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; return; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; return; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            pc++; reg[0] = 0; return; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            pc++; reg[0] = 0; return; break;
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
            freg[rd] = fpu.fadd(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 1:
            freg[rd] = fpu.fsub(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 2:
            freg[rd] = fpu.fmul(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 3:
            freg[rd] = fpu.fdiv(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 4:
            freg[rd] = fpu.fsqrt(freg[rs1]);
            pc++; reg[0] = 0; return; break;
        case 5:
            freg[rd] = fpu.fneg(freg[rs1]);
            pc++; reg[0] = 0; return; break;
        case 6:
            freg[rd] = fpu.fmin(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 7:
            freg[rd] = fpu.fmax(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
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
            reg[rd] = fpu.feq(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 1:
            reg[rd] = fpu.flt(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 2:
            reg[rd] = fpu.fle(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 3:
            reg[rd] = freg[rs1];
            pc++; reg[0] = 0; return; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            pc++; reg[0] = 0; return; break;
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
            pc++; reg[0] = 0; return; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            pc++; reg[0] = 0; return; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            pc++; reg[0] = 0; return; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            pc++; reg[0] = 0; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            pc++; reg[0] = 0; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            pc++; reg[0] = 0; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            pc++; reg[0] = 0; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            pc++; reg[0] = 0; return; break;
        default:
            break;
        }
        break;
    }
    case 5:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int offset = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; reg[0] = 0; return; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; reg[0] = 0; return; break;
        case 2:
            reg[rd] = (((rs1 << 16) + offset) & ((1 << 20) - 1)) << 12;
            pc++; reg[0] = 0; return; break;
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
            reg[0] = 0; return; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; return; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; return; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; return; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; return; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; return; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            pc++; reg[0] = 0; return; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            pc++; reg[0] = 0; return; break;
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
            reg[0] = 0; return; break;
        case 1:
            reg[rd] = pc + 1;
            pc += imm;
            reg[0] = 0; return; break;
        case 2:
            reg[rd] = pc + 1;
            pc = reg[rs1] + imm;
            reg[0] = 0; return; break;
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
