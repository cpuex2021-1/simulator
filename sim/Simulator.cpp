#include "Simulator.hpp"
#include "util.hpp"
#include <iostream>

using namespace std;

Simulator::Simulator(unsigned int memsize, unsigned int cachesize, int pc_)
{
    pc = pc_;
    Memory newmem(memsize, cachesize);
    mem = &newmem;
    reg.reserve(REGNUM);
    freg.reserve(FREGNUM);
}

void Simulator::simulate(unsigned int instr)
{
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    switch (op)
    {
    case 0:
    {
        unsigned int rd = getBits(instr, 26, 22);
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);
        unsigned int funct10 = getBits(instr, 21, 11);
        switch (funct3)
        {
        case 0:
            switch (funct10)
            {
            case 0:
                reg[rd] = (int)reg[rs1] + (int)reg[rs2];
                return; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                return; break;
            default:
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            return; break;
        case 2:
            switch (funct10)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                return; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                return; break;
            default:
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            return; break;
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
        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] * (int)reg[rs2];
            return; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            return; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            return; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            return; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            return; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            return; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            return; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            return; break;
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
        switch (funct3)
        {
        case 0:
            freg[rd] = fadd(freg[rs1], freg[rs2]);
            return; break;
        case 1:
            freg[rd] = fsub(freg[rs1], freg[rs2]);
            return; break;
        case 2:
            freg[rd] = fmul(freg[rs1], freg[rs2]);
            return; break;
        case 3:
            freg[rd] = fdiv(freg[rs1], freg[rs2]);
            return; break;
        case 4:
            freg[rd] = fsqrt(freg[rs1], freg[rs2]);
            return; break;
        case 5:
            freg[rd] = fneg(freg[rs1]);
            return; break;
        case 6:
            freg[rd] = fmin(freg[rs1], freg[rs2]);
            return; break;
        case 7:
            freg[rd] = fmax(freg[rs1], freg[rs2]);
            return; break;
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
        switch (funct3)
        {
        case 0:
            freg[rd] = feq(freg[rs1], freg[rs2]);
            return; break;
        case 1:
            freg[rd] = flt(freg[rs1], freg[rs2]);
            return; break;
        case 2:
            freg[rd] = fle(freg[rs1], freg[rs2]);
            return; break;
        case 3:
            reg[rd] = freg[rs1];
            return; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            return; break;
        default:
            break;
        }
        break;
    }
    case 4:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        int imm = getBits(instr, 21, 6);
        int shamt = getBits(instr, 10, 6);
        unsigned int judge = getBits(instr, 11, 11);
        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] + imm;
            return; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            return; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            return; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            return; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            return; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            return; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            return; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            return; break;
        default:
            break;
        }
        break;
    }
    case 5:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rd = getBits(instr, 26, 22);
        int offset = getBits(instr, 21, 6);
        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            return; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            return; break;
        case 2:
            reg[rd] = ((rs1 << 16) + offset) << 12;
            return; break;
        default:
            break;
        }
        break;
    }
    case 6:
    {
        unsigned int rs1 = getBits(instr, 31, 27);
        unsigned int rs2 = getBits(instr, 10, 6);
        int imm = getBits(instr, 26, 11);
        switch (funct3)
        {
        case 0:
            if((int)reg[rs1] == (int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
            }
            return; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            return; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            return; break;
        default:
            break;
        }
        break;
    }
    case 7:
    {
        int imm = getBits(instr, 30, 6);
        int rs1 = getBits(instr, 31, 27);
        int rd = getBits(instr, 26, 22);
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