#include "Simulator.hpp"
#include "util.hpp"
#include <iostream>

using namespace std;

Simulator::Simulator(unsigned int memsize, unsigned int cachesize, int pc_)
{
    pc = pc_;
    mem = new Memory(memsize, cachesize);
    reg = new int[REGNUM];
    freg = new int[FREGNUM];
}

Simulator::~Simulator(){
    delete mem;
    delete reg;
    delete freg;
}

void Simulator::simulate(unsigned int instr)
{
    unsigned int op = getBits(instr, 2, 0, false);
    unsigned int funct3 = getBits(instr, 5, 3, false);

    switch (op)
    {
    case 0:
    {
        unsigned int rd = getBits(instr, 26, 22, false);
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rs2 = getBits(instr, 10, 6, false);
        unsigned int funct11 = getBits(instr, 21, 11, false);
        
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
                pc += 4; return; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                pc += 4; return; break;
            default:
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            pc += 4; return; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                pc += 4; return; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                pc += 4; return; break;
            default:
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            pc += 4; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            pc += 4; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            pc += 4; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            pc += 4; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 1:
    {
        unsigned int rd = getBits(instr, 26, 22, false);
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rs2 = getBits(instr, 10, 6, false);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] * (int)reg[rs2];
            pc += 4; return; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            pc += 4; return; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc += 4; return; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc += 4; return; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            pc += 4; return; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            pc += 4; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            pc += 4; return; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 2:
    {
        unsigned int rd = getBits(instr, 26, 22, false);
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rs2 = getBits(instr, 10, 6, false);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = fadd(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 1:
            freg[rd] = fsub(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 2:
            freg[rd] = fmul(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 3:
            freg[rd] = fdiv(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 4:
            freg[rd] = fsqrt(freg[rs1]);
            pc += 4; return; break;
        case 5:
            freg[rd] = fneg(freg[rs1]);
            pc += 4; return; break;
        case 6:
            freg[rd] = fmin(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 7:
            freg[rd] = fmax(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 3:
    {
        unsigned int rd = getBits(instr, 26, 22, false);
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rs2 = getBits(instr, 10, 6, false);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = feq(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 1:
            freg[rd] = flt(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 2:
            freg[rd] = fle(freg[rs1], freg[rs2]);
            pc += 4; return; break;
        case 3:
            reg[rd] = freg[rs1];
            pc += 4; return; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 4:
    {
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rd = getBits(instr, 26, 22, false);
        int imm = getBits(instr, 21, 6, true);
        int shamt = getBits(instr, 10, 6, true);
        unsigned int judge = getBits(instr, 11, 11, false);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] + imm;
            pc += 4; return; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            pc += 4; return; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            pc += 4; return; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            pc += 4; return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            pc += 4; return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            pc += 4; return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            pc += 4; return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 5:
    {
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rd = getBits(instr, 26, 22, false);
        int offset = getBits(instr, 21, 6, true);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            pc += 4; return; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            pc += 4; return; break;
        case 2:
            reg[rd] = ((rs1 << 16) + offset) << 12;
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 6:
    {
        unsigned int rs1 = getBits(instr, 31, 27, false);
        unsigned int rs2 = getBits(instr, 10, 6, false);
        int imm = getBits(instr, 26, 11, true);

        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            if((int)reg[rs1] == (int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc += 4;
            }
            return; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            pc += 4; return; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            pc += 4; return; break;
        default:
            break;
        }
        break;
    }
    case 7:
    {
        int imm = getBits(instr, 30, 6, true);
        int rs1 = getBits(instr, 31, 27, false);
        int rd = getBits(instr, 26, 22, false);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc += imm;
            return; break;
        case 1:
            reg[rd] = pc + 4;
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