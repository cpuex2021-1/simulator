#ifndef CPU_H_INCLUDED
#define CPU_H_INCLUDED
#include "Memory.hpp"
#include "fpu.hpp"
#include "util.hpp"
#include <string>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>

#define REGNUM 32
#define FREGNUM 32

#define CACHEMISSSTALL 30
#define CACHEHITSTALL 1
#define BRANCH 2

#define PIPELINE_STAGES 4
#define LOG_SIZE 1000

using std::exception;
using std::cout;
using std::cerr;
using std::endl;
using std::stringstream;


typedef struct Pinfo {int pc; bool flushed;} pinfo;

class Pipeline
{
protected:
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
    Sinfo pipe[LOG_SIZE];
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
            int ans = 0;
            if(stallNum){
                bool checkstall = false;
                int i = 1;
                for(; i < LOG_SIZE && (!checkstall) && i <= stallNum; i++){
                    checkstall |= pipe[(ifidx + (LOG_SIZE - i)) % LOG_SIZE].rd != 0 \
                            && pipe[(ifidx + (LOG_SIZE - i)) % LOG_SIZE].valid \
                            && (pipe[(ifidx + (LOG_SIZE - i)) % LOG_SIZE].rd == rs1 || \
                            pipe[(ifidx + (LOG_SIZE - i)) % LOG_SIZE].rd == rs2);
                }
                ans = stallNum - i + 2;
            }
            stallNum = 0;
            return ans;
        }
    }

    inline void update_pipeline(int instr_idx, int rd, int rs1, int rs2, int numstall, bool flush, unsigned long long &clk){
        if(flush){
            pipe[ifidx].set(instr_idx, rd, rs1, rs2);
            ifidx++; ifidx %= LOG_SIZE;
            for(int i=0; i<BRANCH; i++){
                pipe[ifidx].flush(instr_idx + i + 1);
                ifidx++; ifidx %= LOG_SIZE;
            }
            clk += BRANCH;
        }else{
            for(int i=0; i<numstall; i++){
                pipe[ifidx].set_nop();
                ifidx++; ifidx %= LOG_SIZE;
            }
            pipe[ifidx].set(instr_idx, rd, rs1, rs2);
            ifidx++; ifidx %= LOG_SIZE;
            clk += numstall;
        }
    }

    inline void getPipelineInfo(vector<pinfo>& P){
        for(unsigned int i=0; i<P.size(); i++){
            P[i].pc = pipe[(ifidx - 1 - i + 2 * LOG_SIZE) % LOG_SIZE].instr_idx;
            P[i].flushed = pipe[(ifidx -1 - i + 2 * LOG_SIZE) % LOG_SIZE].flushed;
        }
    }

    void reset(){
        for(int i=0; i<LOG_SIZE; i++){
            pipe[i].set_nop();
        }
    }

    void revert(int pc, unsigned long long &clk){
        ifidx += LOG_SIZE - 1; ifidx %= LOG_SIZE; clk--;
        int cnt = 0;
        while((pipe[ifidx].instr_idx != pc && (!pipe[ifidx].flushed)) || cnt > LOG_SIZE){
            pipe[ifidx].set_nop();
            ifidx += LOG_SIZE - 1; ifidx %= LOG_SIZE; clk--; cnt++;
        }
    }
};

class Log
{
protected:
public:
    class LogData{
    public:
        int pc;
        bool isreg;
        int index;
        int former_val;
        LogData()
        :pc(0), isreg(false), index(0), former_val(0) 
        {};
    };
    LogData log[LOG_SIZE];
    unsigned int logHead;
    unsigned long long logSize;
    inline void push(int pc, bool isreg, int index, int former_val){
        log[logHead].pc = pc;
        log[logHead].isreg = isreg;
        log[logHead].index = index;
        log[logHead].former_val = former_val;
        logHead++; logHead %= LOG_SIZE;
        logSize += (logSize > LOG_SIZE)? 0 : 1;
    }
    inline LogData pop(){
        if(logHead){
            logHead += LOG_SIZE - 1;
            logHead %= LOG_SIZE;
        }
        logSize = (logSize <= 0)? 0 : logSize - 1;
        return log[logHead];
    }

    void reset(){
        for(int i = 0; i < LOG_SIZE; i++){
            log[i].pc = 0;
            log[i].isreg = false;
            log[i].index = 0;
            log[i].former_val = 0;
        }
        logHead=0; logSize=0;
    }
    Log()
    :logHead(0), logSize(0)
    {}
};

class CPU
{
protected:
    void throw_err(int instr);
    Pipeline p;
    Log log;
public:
    int* reg;
    int* freg;
    vector<int> instructions;

    unsigned long long pc;
    unsigned long long clk;
    Memory* mem;
    CPU();
    ~CPU();
    inline void simulate_fast();
    inline void simulate_acc();
    void print_register();
    void reset();
    void revert();
    inline void getPipelineInfo(vector<pinfo>& P){
        return p.getPipelineInfo(P);
    }    
};


inline void CPU::simulate_fast()
{
    unsigned int instr = instructions[pc];
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
            freg[rd] = FPU::fadd(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            freg[rd] = FPU::fsub(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            freg[rd] = FPU::fmul(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 3:
            freg[rd] = FPU::fdiv(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = FPU::fsqrt(freg[rs1]);
            pc++; reg[0] = 0; break;
        case 5:
            freg[rd] = FPU::fneg(freg[rs1]);
            pc++; reg[0] = 0; break;
        case 6:
            freg[rd] = FPU::fmin(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 7:
            freg[rd] = FPU::fmax(freg[rs1], freg[rs2]);
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
            reg[rd] = FPU::feq(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = FPU::flt(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = FPU::fle(freg[rs1], freg[rs2]);
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = freg[rs1];
            pc++; reg[0] = 0; break;
        case 4:
            freg[rd] = (int)reg[rs1];
            pc++; reg[0] = 0; break;
        case 5:
            freg[rd] = freg[rs1];
            pc++; reg[0] = 0; break;
        case 6:
            freg[rd] = FPU::itof(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = FPU::ftoi(freg[rs1]);
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
        int offset = getSextBits(instr, 21, 6);
        unsigned int luioffset = getBits(instr, 21, 6);

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
            reg[rd] = ((rs1 << 16) + luioffset) << 12;
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

    clk++;
    return;
}

inline void CPU::simulate_acc()
{
    unsigned int instr = instructions[pc];
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

    long long memAddr = -1;
    int former_val = 0;

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
        former_val = reg[rd];
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
        former_val = reg[rd];
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            former_val = freg[rd];
            freg[rd] = FPU::fadd(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 1:
            former_val = freg[rd];
            freg[rd] = FPU::fsub(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 2:
            former_val = freg[rd];
            freg[rd] = FPU::fmul(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 3:
            former_val = freg[rd];
            freg[rd] = FPU::fdiv(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 4:
            former_val = freg[rd];
            freg[rd] = FPU::fsqrt(freg[rs1]);
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 5:
            former_val = freg[rd];
            freg[rd] = FPU::fneg(freg[rs1]);
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 6:
            former_val = freg[rd];
            freg[rd] = FPU::fmin(freg[rs1], freg[rs2]);
            rd += 16;
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 7:
            former_val = freg[rd];
            freg[rd] = FPU::fmax(freg[rs1], freg[rs2]);
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
        former_val = reg[rd];
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = FPU::feq(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = FPU::flt(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = FPU::fle(freg[rs1], freg[rs2]);
            rs1 += 16;
            rs2 += 16;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = freg[rs1];
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 4:
            former_val = freg[rd];
            freg[rd] = (int)reg[rs1];
            rd += 16;
            pc++; reg[0] = 0; break;
        case 5:
            former_val = freg[rd];
            freg[rd] = freg[rs1];
            rd += 16;
            rs1 += 16;
            pc++; reg[0] = 0; break;
        case 6:
            former_val = freg[rd];
            freg[rd] = FPU::itof(reg[rs1]);
            rd += 16;
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = FPU::ftoi(freg[rs1]);
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
        former_val = reg[rd];
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
        former_val = reg[rd];
        int offset = getSextBits(instr, 21, 6);
        unsigned int luioffset = getBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = mem->read((int)reg[rs1] + offset);
            numstall = (mem->checkCacheHit()) ? CACHEHITSTALL : CACHEMISSSTALL;
            pc++; reg[0] = 0; break;
        case 1:
            former_val = freg[rd];
            freg[rd] = mem->read((int)reg[rs1] + offset);
            numstall = (mem->checkCacheHit()) ? CACHEHITSTALL : CACHEMISSSTALL;
            rd += 16;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (((rs1 << 16) + luioffset) & ((1 << 20) - 1)) << 12;
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
            memAddr = reg[rs1]+imm;
            former_val = mem->read_without_cache(memAddr);
            mem->write((int)memAddr, (int)reg[rs2]);
            numstall = (mem->checkCacheHit()) ? CACHEHITSTALL : CACHEMISSSTALL;
            pc++; reg[0] = 0; break;
        case 7:
            memAddr = reg[rs1]+imm;
            former_val = mem->read_without_cache(memAddr);
            mem->write((int)memAddr, (int)freg[rs2]);
            numstall = (mem->checkCacheHit()) ? CACHEHITSTALL : CACHEMISSSTALL;
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
        former_val = reg[rd];
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

    if(memAddr > -1){
        log.push(former_pc, false, memAddr, former_val);
    }else{
        log.push(former_pc, true, rd, former_val);
    }

    int numStall = p.checkstall(numstall, rs1, rs2);
    p.update_pipeline(former_pc, rd, rs1, rs2, numStall, isFlush, clk);
    clk++;
    return;
}


extern map<int, string> xregName;
extern map<int, string> fregName; 

#endif