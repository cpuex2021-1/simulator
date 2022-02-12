#ifndef CPU_H_INCLUDED
#define CPU_H_INCLUDED
#include "Memory.hpp"
#include "fpu.hpp"
#include "../lib/util.hpp"
#include "Profiler.hpp"
#include "../lib/DisAssembler.hpp"
#include <string>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>

#define REGNUM 64

#define CACHEMISSSTALL 30
#define CACHEHITSTALL 1
#define BRANCH 2

#define PIPELINE_STAGES 4
#define LOG_SIZE 1000

#define RASTACKSIZE 1024

using std::exception;
using std::cout;
using std::cerr;
using std::endl;
using std::stringstream;

#ifdef STDFPU
#define FPU StdFPU
#endif
#ifndef STDFPU
#define FPU OrenoFPU
#endif

typedef struct Pinfo {int32_t pc; bool flushed;} pinfo;

class Log
{
protected:
public:
    class LogData{
    public:
        int32_t pc;
        int32_t rd;
        int32_t memAddr;
        int32_t former_val;
        bool dorapush;
        int32_t dorapop;
        
        LogData()
        :pc(0), rd(-1), memAddr(-1), former_val(0), dorapush(false), dorapop(-1)
        {};
    };
    LogData log[LOG_SIZE];
    uint32_t logHead;
    uint64_t logSize;
    inline void push(int32_t pc, int32_t rd, int32_t memAddr, int32_t former_val, bool rapush, int32_t rapop){
        log[logHead].pc = pc;
        log[logHead].rd = rd;
        log[logHead].memAddr = memAddr;
        log[logHead].former_val = former_val;
        log[logHead].dorapop = rapop;
        log[logHead].dorapush = rapush;
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
        for(int32_t i = 0; i < LOG_SIZE; i++){
            log[i].pc = 0;
            log[i].rd = -1;
            log[i].memAddr = -1;
            log[i].former_val = 0;
        }
        logHead=0; logSize=0;
    }
    Log()
    :logHead(0), logSize(0)
    {}
};

class CPU : public Profiler
{
protected:
    void throw_err(int32_t instr);
    Log log;
    int32_t memDestRd;


    uint32_t* rastack;
    uint32_t rastackIdx;

public:
    inline static int32_t* reg;

    uint64_t pc;

    Memory mem;
    CPU();
    ~CPU();
    inline void simulate_acc();
    static void print_register();
    void reset();
    void revert();

    inline int checkDataHazard(int memDestRd, int rs1, int rs2);
    inline void setMemDestRd();

    void update_clkcount();
};

inline void CPU::simulate_acc()
{
    /*
    // for jit compiler debugging
    cout << "PC: " << pc;
    cout << " LINE: " << pc_to_line(pc);
    cout << " CLK: " << numInstruction << "\n";
    cout << " Instruction: " << str_instr[pc_to_line(pc)] << "\n";
    for(int i=0; i<32; i++){
        cout << i << " " << reg[i] << "\t";
    }
    cout << "\n";
    for(int i=32; i<64; i++){
        cout << i << " " << convert_to_float(reg[i]) << "\t";
    }
    cout << "\n";
    if(numInstruction == 3999572){
        exit(0);
    }*/
    
    uint32_t instr = instructions[pc];
    uint32_t op = getBits(instr, 2, 0);
    uint32_t funct3 = getBits(instr, 5, 3);

    int32_t former_pc = pc;

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    int32_t rd = -1;
    int32_t rs1 = -1;
    int32_t rs2 = -1;

    int64_t memAddr = -1;
    int32_t former_val = 0;

    int32_t memdestRd = -2;
    numExecuted[pc]++;

    bool dorapush = false;
    int32_t dorapop = -1;

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 25, 20);
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);
        
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d funct11:%d\n", op, funct3, rd, rs1, rs2, funct11);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int32_t)reg[rs1] + (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (int32_t)reg[rs1] - (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 1:
    {
        break;
    }
    case 2:
    {
        rd = getBits(instr, 25, 20);
        former_val = reg[rd];
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            former_val = reg[rd];
            reg[rd] = FPU::fadd(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            former_val = reg[rd];
            reg[rd] = FPU::fsub(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            former_val = reg[rd];
            reg[rd] = FPU::fmul(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 3:
            former_val = reg[rd];
            reg[rd] = FPU::fdiv(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 4:
            former_val = reg[rd];
            reg[rd] = FPU::fsqrt(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 5:
            former_val = reg[rd];
            reg[rd] = FPU::fneg(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 6:
            former_val = reg[rd];
            reg[rd] = FPU::fabs(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 7:
            former_val = reg[rd];
            reg[rd] = FPU::floor(reg[rs1]);
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 3:
    {
        rd = getBits(instr, 25, 20);
        former_val = reg[rd];
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = FPU::feq(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = FPU::flt(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = FPU::fle(reg[rs1], reg[rs2]);
            pc++; reg[0] = 0; break;
            
        case 6:
            former_val = reg[rd];
            reg[rd] = FPU::itof(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = FPU::ftoi(reg[rs1]);
            pc++; reg[0] = 0; break;
        
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 4:
    {
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        former_val = reg[rd];
        int32_t imm = getSextBits(instr, 19, 6);
        int32_t shamt = getSextBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int32_t)reg[rs1] + imm;
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (uint32_t)reg[rs1] << shamt;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (int32_t)reg[rs1] >> shamt;
            break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 5:
    {
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        former_val = reg[rd];
        int32_t offset = getSextBits(instr, 19, 6);
        uint32_t luioffset = getBits(instr, 19, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            memAddr = (int32_t)reg[rs1] + offset;
            former_val = reg[rd];
            memdestRd = rd;
            reg[rd] = mem.read(memAddr);
            pc++; reg[0] = 0; break;
        case 1:
            //tbd
        case 2:
            reg[rd] = (((rs1 << 16) + luioffset) & ((1 << 20) - 1)) << 12;
            pc++; reg[0] = 0; break;

        #ifdef STDFPU
        case 5:
            former_val = reg[rd];
            reg[rd] = FPU::fsin(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 6:
            former_val = reg[rd];
            reg[rd] = FPU::fcos(reg[rs1]);
            pc++; reg[0] = 0; break;
        case 7:
            former_val = reg[rd];
            reg[rd] = FPU::atan(reg[rs1]);
            pc++; reg[0] = 0; break;
        #endif

        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 6:
    {
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);
        int32_t imm = getSextBits(instr, 25, 12);
        int32_t rs2imm = getSextBits(instr, 11, 6);
        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            if((int32_t)reg[rs1] == (int32_t)reg[rs2]){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;
        case 1:
            if((int32_t)reg[rs1] != (int32_t)reg[rs2]){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;
        case 2:
            if((int32_t)reg[rs1] < (int32_t)reg[rs2]){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;
        case 3:
            if((int32_t)reg[rs1] >= (int32_t)reg[rs2]){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;

        case 5:
            if((int32_t)reg[rs1] != rs2imm){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;
        case 6:
            memAddr = reg[rs1]+imm;
            former_val = mem.read_without_cache(memAddr);
            mem.write((int32_t)memAddr, (int32_t)reg[rs2]);
            pc++; reg[0] = 0; break;
        case 7:
            //tbd
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 7:
    {
        int32_t addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 26);
        former_val = reg[rd];

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc = addr;
            rs1 = -1;
            break;
        case 1:
            pc = reg[rs1];
            break;
        case 2:
            if(rastackIdx >= RASTACKSIZE - 1){
                throw out_of_range("ra stack overflow");
            }
            rastack[rastackIdx++] = pc + 1;
            dorapush = true;
            rs1 = -1;
            pc = addr;
            break;
        case 3:
            if(rastackIdx >= RASTACKSIZE - 1){
                throw out_of_range("ra stack overflow");
            }
            rastack[rastackIdx++] = pc + 1;
            dorapush = true;
            pc = reg[rs1];
            break;
        case 4:
            if(--rastackIdx < 0){
                throw out_of_range("Nothing to pop from ra stack");
            }
            dorapop = rastack[rastackIdx];
            pc = dorapop;
            rs1 = -1;
            break;
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

    log.push(former_pc, rd, memAddr, former_val, dorapush, dorapop);
    numDataHazard += checkDataHazard(memdestRd, rs1, rs2);

    return;
}

inline int CPU::checkDataHazard(int memdestRd, int rs1, int rs2){
    if((memDestRd == rs1 || memDestRd == rs2)){
        memDestRd = memdestRd;
        return 1;
    }else{
        memDestRd = memdestRd;
        return 0;
    }
}

#undef FPU
#endif
