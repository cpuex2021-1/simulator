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
        
        LogData()
        :pc(0), rd(-1), memAddr(-1), former_val(0) 
        {};
    };
    LogData log[LOG_SIZE];
    uint32_t logHead;
    uint64_t logSize;
    inline void push(int32_t pc, int32_t rd, int32_t memAddr, int32_t former_val){
        log[logHead].pc = pc;
        log[logHead].rd = rd;
        log[logHead].memAddr = memAddr;
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

public:
    inline static int32_t* reg;
    inline static int32_t* freg;

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

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
        uint32_t funct11 = getBits(instr, 21, 11);
        
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d funct11:%d\n", op, funct3, rd, rs1, rs2, funct11);
        #endif

        switch (funct3)
        {
        case 0:
            switch (funct11)
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
        case 1:
            reg[rd] = (int32_t)reg[rs1] << (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 2:
            switch (funct11)
            {
            case 0:
                reg[rd] = ((uint32_t)reg[rs1]) >> ((uint32_t)reg[rs2]);
                pc++; reg[0] = 0; break;
            case 1:
                reg[rd] = ((int32_t)reg[rs1]) >> ((int32_t)reg[rs2]);
                pc++; reg[0] = 0; break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 3:
            reg[rd] = ((int32_t)reg[rs1] < (int32_t)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((uint32_t)reg[rs1] < (uint32_t)reg[rs2])? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int32_t)reg[rs1] ^ (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int32_t)reg[rs1] | (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int32_t)reg[rs1] & (int32_t)reg[rs2];
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
            reg[rd] = (int32_t)reg[rs1] * (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (int64_t)((int64_t)reg[rs1] * (int64_t)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (int64_t)((int64_t)reg[rs1] * (uint64_t)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = (uint64_t)((uint64_t)reg[rs1] * (uint64_t)reg[rs2]) >> 32;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = (int32_t)reg[rs1] / (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (uint32_t)reg[rs1] / (uint32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int32_t)reg[rs1] % (int32_t)reg[rs2];
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (uint32_t)reg[rs1] % (uint32_t)reg[rs2];
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
            rd += REGNUM;
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 1:
            former_val = freg[rd];
            freg[rd] = FPU::fsub(freg[rs1], freg[rs2]);
            rd += REGNUM;
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 2:
            former_val = freg[rd];
            freg[rd] = FPU::fmul(freg[rs1], freg[rs2]);
            rd += REGNUM;
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 3:
            former_val = freg[rd];
            freg[rd] = FPU::fdiv(freg[rs1], freg[rs2]);
            rd += REGNUM;
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 4:
            former_val = freg[rd];
            freg[rd] = FPU::fsqrt(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 5:
            former_val = freg[rd];
            freg[rd] = FPU::fneg(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 6:
            former_val = freg[rd];
            freg[rd] = FPU::fabs(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 7:
            former_val = freg[rd];
            freg[rd] = FPU::floor(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
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
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = FPU::flt(freg[rs1], freg[rs2]);
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = FPU::fle(freg[rs1], freg[rs2]);
            rs1 += REGNUM;
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = freg[rs1];
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 4:
            former_val = freg[rd];
            freg[rd] = (int32_t)reg[rs1];
            rd += REGNUM;
            pc++; reg[0] = 0; break;
        case 5:
            former_val = freg[rd];
            freg[rd] = freg[rs1];
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 6:
            former_val = freg[rd];
            freg[rd] = FPU::itof(reg[rs1]);
            rd += REGNUM;
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = FPU::ftoi(freg[rs1]);
            rs1 += REGNUM;
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
        int32_t imm = getSextBits(instr, 21, 6);
        int32_t shamt = getSextBits(instr, 10, 6);
        uint32_t judge = getBits(instr, 11, 11);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            reg[rd] = (int32_t)reg[rs1] + imm;
            pc++; reg[0] = 0; break;
        case 1:
            reg[rd] = (int32_t)reg[rs1] << shamt;
            pc++; reg[0] = 0; break;
        case 2:
            if(judge){
                reg[rd] = (int32_t)reg[rs1] >> shamt;
            }else{
                reg[rd] = (uint32_t)reg[rs1] >> shamt;
            }
            pc++; reg[0] = 0; break;
        case 3:
            reg[rd] = ((int32_t)reg[rs1] < imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 4:
            reg[rd] = ((uint32_t)reg[rs1] < (uint32_t)imm)? 1 : 0;
            pc++; reg[0] = 0; break;
        case 5:
            reg[rd] = (int32_t)reg[rs1] ^ imm;
            pc++; reg[0] = 0; break;
        case 6:
            reg[rd] = (int32_t)reg[rs1] | imm;
            pc++; reg[0] = 0; break;
        case 7:
            reg[rd] = (int32_t)reg[rs1] & imm;
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
        int32_t offset = getSextBits(instr, 21, 6);
        uint32_t luioffset = getBits(instr, 21, 6);

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
            memAddr = (int32_t)reg[rs1] + offset;
            former_val = freg[rd];
            memdestRd = rd + REGNUM;
            freg[rd] = mem.read(memAddr);
            rd += REGNUM;
            pc++; reg[0] = 0; break;
        case 2:
            reg[rd] = (((rs1 << 16) + luioffset) & ((1 << 20) - 1)) << 12;
            pc++; reg[0] = 0; break;

        #ifdef STDFPU
        case 5:
            former_val = freg[rd];
            freg[rd] = FPU::fsin(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 6:
            former_val = freg[rd];
            freg[rd] = FPU::fcos(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
            pc++; reg[0] = 0; break;
        case 7:
            former_val = freg[rd];
            freg[rd] = FPU::atan(freg[rs1]);
            rd += REGNUM;
            rs1 += REGNUM;
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
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
        int32_t imm = getSextBits(instr, 26, 11);
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
        case 4:
            if((uint32_t)reg[rs1] < (uint32_t)reg[rs2]){
                pc += imm;
            }else{
                numBranchUnTaken[pc]++;
                pc++;
            }
            reg[0] = 0; break;
        case 5:
            if((uint32_t)reg[rs1] >= (uint32_t)reg[rs2]){
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
            memAddr = reg[rs1]+imm;
            former_val = mem.read_without_cache(memAddr);
            mem.write((int32_t)memAddr, (int32_t)freg[rs2]);
            rs2 += REGNUM;
            pc++; reg[0] = 0; break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 7:
    {
        int32_t addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        former_val = reg[rd];
        int32_t imm = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            pc = addr;
            //numFlush++;
            reg[0] = 0; break;
        case 1:
            reg[rd] = pc + 1;
            //numFlush++;
            pc = imm;
            reg[0] = 0; break;
        case 2:
            reg[rd] = pc + 1;
            pc = reg[rs1] + imm;
            //numFlush++;
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

    log.push(former_pc, rd, memAddr, former_val);
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
