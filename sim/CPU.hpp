#pragma once
#include "Memory.hpp"
#include "fpu.hpp"
#include "util.hpp"
#include <string>
#include <iostream>
#include <iomanip>
#include <map>
#include <unordered_map>
#define REGNUM 32
#define FREGNUM 32

#define CACHESTALL 20
#define DATAHAZARD 1
#define BRANCH 2
#define PIPELINE_STAGES 4

using std::exception;
using std::cout;
using std::cerr;
using std::endl;
using std::stringstream;

class Pipeline
{
private:
    int ifidx;
    class Sinfo{
    public:
        int instr_idx;
        int rd;
        int rs1;
        int rs2;
        bool flushed;
        bool valid;
        Sinfo(){
            instr_idx = -1;
            rd = 0;
            rs1 = 0;
            rs2 = 0;
            flushed = false;
            valid = false;
        }
        inline void set_nop(){
            instr_idx = -1;
            rd = 0;
            rs1 = 0;
            rs2 = 0;
            flushed = false;
            valid = false;
        }
        inline void flush(int index){
            instr_idx = index;
            flushed = true;
            valid = false;
        }
        inline void set(int instr_idx_, int rd_, int rs1_, int rs2_){
            instr_idx = instr_idx_;
            rd = rd_;
            rs1 = rs1_;
            rs2 = rs2_;
            valid = true;
            flushed = false;
        }
    };
    Sinfo pipe[PIPELINE_STAGES];
    int stallNum;
    
public:
    Pipeline()
    : ifidx(0), stallNum(0)
    {}

    inline int checkstall(int stallnum, int rs1, int rs2){
        if(stallnum){
            stallNum = stallnum;
            return 0;
        }else{
            int ans;
            if(stallNum){
                if(pipe[(ifidx + (PIPELINE_STAGES - 1)) % PIPELINE_STAGES].rd != 0 \
                 && (pipe[(ifidx + (PIPELINE_STAGES - 1)) % PIPELINE_STAGES].rd == rs1 || pipe[(ifidx + (PIPELINE_STAGES - 1)) % PIPELINE_STAGES].rd == rs2) \
                 && pipe[(ifidx + (PIPELINE_STAGES - 1)) % PIPELINE_STAGES].valid
                ){
                    ans = stallNum;
                }else{
                    ans = 0;
                }
            }else{
                ans = 0;
            }
            stallNum = 0;
            return ans;
        }
    }

    inline void update_pipeline(int instr_idx, int rd, int rs1, int rs2, int numstall, bool flush, unsigned long long &clk){
        if(flush){
            pipe[ifidx].set(instr_idx, rd, rs1, rs2);
            ifidx++; ifidx %= PIPELINE_STAGES;
            for(int i=0; i<BRANCH; i++){
                pipe[ifidx].flush(instr_idx + i + 1);
                ifidx++; ifidx %= PIPELINE_STAGES;
            }
            clk += BRANCH;
        }else{
            for(int i=0; i<numstall; i++){
                pipe[ifidx].set_nop();
                ifidx++; ifidx %= PIPELINE_STAGES;
            }
            pipe[ifidx].set(instr_idx, rd, rs1, rs2);
            ifidx++; ifidx %= PIPELINE_STAGES;
            clk += numstall;
        }
    }

    inline void getPipelineInfo(vector<int>& P){        
        for(int i=0; i<PIPELINE_STAGES; i++){
            P[i] = pipe[(ifidx - i + PIPELINE_STAGES) % PIPELINE_STAGES].instr_idx;
        }
    }
};


class CPU
{
private:
    void throw_err(int instr);
    Pipeline p;
public:
    int* reg;
    int* freg;
    unsigned long long pc;
    unsigned long long clk;
    Memory* mem;
    FPU fpu;
    CPU(unsigned int memsize, unsigned int cachesize, int pc);
    ~CPU();
    inline void simulate_fast(unsigned int instr);
    inline void simulate_acc(unsigned int instr);
    void print_register();
    void reset();
    inline void getPipelineInfo(vector<int>& P){
        return p.getPipelineInfo(P);
    }    
};


inline void CPU::simulate_fast(unsigned int instr)
{
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    int rd;
    int rs1;
    int rs2;

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
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
                pc++; reg[0] = 0; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                pc++; reg[0] = 0; break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                pc++; reg[0] = 0; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                pc++; reg[0] = 0; break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 1:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] * (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 2:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = fpu.fadd(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            freg[rd] = fpu.fsub(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            freg[rd] = fpu.fmul(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 3:
            freg[rd] = fpu.fdiv(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = fpu.fsqrt(freg[rs1]);
            pc++; reg[0] = 0; break;
        case 5:
            freg[rd] = fpu.fneg(freg[rs1]);
            pc++; reg[0] = 0; break;
        case 6:
            freg[rd] = fpu.fmin(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 7:
            freg[rd] = fpu.fmax(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 3:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = fpu.feq(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = fpu.flt(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = fpu.fle(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = freg[rs1];
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 4:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
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
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            pc++; reg[0] = 0; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 5:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        unsigned int offset = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; reg[0] = 0; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (((rs1 << 16) + offset) & ((1 << 20) - 1)) << 12;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 6:
    {
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
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
            reg[0] = 0; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            pc++; reg[0] = 0; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 7:
    {
        int addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int imm = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc += addr;
            reg[0] = 0; break;
        case 1:
            reg[rd] = pc + 1;
            pc += imm;
            reg[0] = 0; break;
        case 2:
            reg[rd] = pc + 1;
            pc = reg[rs1] + imm;
            reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    default:
        throw_err(instr); return;
        break;
    }

    
    return;
}

inline void CPU::simulate_acc(unsigned int instr)
{
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    int former_pc = pc;

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    int rd = 0;
    int rs1 = 0;
    int rs2 = 0;

    int numstall = 0;
    bool isFlush = false;

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
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
                pc++; reg[0] = 0; break;
            case 1:
                reg[rd] = (int)reg[rs1] - (int)reg[rs2];
                pc++; reg[0] = 0; break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 1:
            reg[rd] = (int)reg[rs1] << (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((unsigned int)reg[rs1]) >> ((unsigned int)reg[rs2]);
                pc++; reg[0] = 0; break;
            case 1:
                reg[rd] = ((int)reg[rs1]) >> ((int)reg[rs2]);
                pc++; reg[0] = 0; break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 3:
            reg[rd] = ((int)reg[rs1] < (int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] | (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int)reg[rs1] & (int)reg[rs2];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 1:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int)reg[rs1] * (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (long long)((long long)reg[rs1] * (long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (long long)((long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = (unsigned long long)((unsigned long long)reg[rs1] * (unsigned long long)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = (int)reg[rs1] / (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (unsigned int)reg[rs1] / (unsigned int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] % (int)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (unsigned int)reg[rs1] % (unsigned int)reg[rs2];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 2:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            freg[rd] = fpu.fadd(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 1:
            freg[rd] = fpu.fsub(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 2:
            freg[rd] = fpu.fmul(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 3:
            freg[rd] = fpu.fdiv(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = fpu.fsqrt(freg[rs1]);
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 5:
            freg[rd] = fpu.fneg(freg[rs1]);
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 6:
            freg[rd] = fpu.fmin(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 7:
            freg[rd] = fpu.fmax(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 3:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = fpu.feq(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = fpu.flt(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = fpu.fle(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = freg[rs1];
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 4:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
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
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (int)reg[rs1] << shamt;
            pc++; reg[0] = 0; break;
        case 2:
            if(judge){
                reg[rd] = (int)reg[rs1] >> shamt;
            }else{
                reg[rd] = (unsigned int)reg[rs1] >> shamt;
            }
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = ((int)reg[rs1] < imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((unsigned int)reg[rs1] < (unsigned int)imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int)reg[rs1] ^ imm;
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int)reg[rs1] | imm;
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int)reg[rs1] & imm;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 5:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        unsigned int offset = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            numstall = (mem->checkCacheHit()) ? DATAHAZARD : CACHESTALL;
            pc++; reg[0] = 0; break;
        case 1:
            freg[rd] = mem->read((int)reg[rs1] + offset);
            numstall = (mem->checkCacheHit()) ? DATAHAZARD : CACHESTALL;
            rd += 16;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (((rs1 << 16) + offset) & ((1 << 20) - 1)) << 12;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 6:
    {
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
        int imm = getSextBits(instr, 26, 11);
        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            if((int)reg[rs1] == (int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 1:
            if((int)reg[rs1] != (int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 2:
            if((int)reg[rs1] < (int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 3:
            if((int)reg[rs1] >= (int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 4:
            if((unsigned int)reg[rs1] < (unsigned int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 5:
            if((unsigned int)reg[rs1] >= (unsigned int)reg[rs2]){
                pc += imm;
                isFlush = true;
            }else{
                pc++;
            }
            reg[0] = 0; break;
        case 6:
            mem->write((int)reg[rs1]+imm, (int)reg[rs2]);
            numstall = (mem->checkCacheHit()) ? DATAHAZARD : CACHESTALL;
            pc++; reg[0] = 0; break;
        case 7:
            mem->write((int)reg[rs1]+imm, (int)freg[rs2]);
            numstall = (mem->checkCacheHit()) ? DATAHAZARD : CACHESTALL;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 7:
    {
        int addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int imm = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc += addr;
            //isFlush = true;
            reg[0] = 0; break;
        case 1:
            reg[rd] = pc + 1;
            //isFlush = true;
            pc += imm;
            reg[0] = 0; break;
        case 2:
            reg[rd] = pc + 1;
            pc = reg[rs1] + imm;
            //isFlush = true;
            reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    default:
        throw_err(instr); return;
        break;
    }

    int numStall = p.checkstall(numstall, rs1, rs2);
    p.update_pipeline(former_pc, rd, rs1, rs2, numStall, isFlush, clk);
    return;
}


extern map<int, string> xregName;
extern map<int, string> fregName; 
