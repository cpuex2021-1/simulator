#include "CPU.hpp"
#include "../lib/util.hpp"
using namespace std;

CPU::CPU()
: Profiler(), memDestRd(-2), rastackIdx(0), mem()
{
    pc = 0;
    clk = 0;
    numInstruction = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    numDataHazard = 0;

    //setup register
    reg = new int32_t[REGNUM];
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0;
    }
    reg[2] = MAXMEMINDEX - 1;
    reg[3] = MAXMEMINDEX / 2;

    //setup rastack
    rastack = new uint32_t[RASTACKSIZE];
}

CPU::~CPU(){
    delete reg;
}

void CPU::print_register(){
    cerr << " ";
    for(int i=0; i<REGNUM; i++){
    if(i % 8 == 0 && i > 0) cerr << endl << " ";
        cerr << left << setw(6) << regName[i] + ":" << right << setw(8) << reg[i] << " " << dec;
    }
    cerr << endl;
}

void CPU::reset(){
    Profiler::reset();
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0;
    }
    reg[2] = MAXMEMINDEX - 1;
    reg[3] = MAXMEMINDEX / 2;
    pc = 0;
    clk = 0;
    numInstruction = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    numDataHazard = 0;
    memDestRd = -2;

    mem.reset();
    log.reset();
}


void CPU::throw_err(int instr){
    stringstream sserr;
    sserr << "[ERROR] Invalid_instruction: " << disassemble(instr);
    throw invalid_argument(sserr.str());
}


void CPU::revert_one(){
    if(log.logSize <= 0) return;
    auto logd = log.pop();
    if(logd.rd > 0){
        reg[logd.rd] = logd.former_val;
        if(logd.memAddr == 0){
            mem.uart.revertPop();
        }
    }else{
        if(logd.memAddr > 0){
            mem.write_without_cache(logd.memAddr, logd.former_val);
        }
        else if(logd.memAddr == 0){
            mem.uart.revertPush();
        }
    }

    if(logd.dorapush){
        rastackIdx--;
    }
    if(logd.dorapop > 0){
        rastack[rastackIdx++] = logd.dorapop;
    }

    pc = logd.pc;
}

void CPU::revert(){
    for(int i=0; i<VLIW_SIZE; i++){
        revert_one();
    }
}

void CPU::update_clkcount(){
    clk = 0;
    clk += numInstruction;
    clk += num2stall;
    clk += 2 * num3stall;
    clk += 3 * num4stall;
    clk += numDataHazard;
    clk += 2 * numFlush;
    clk += 35 * mem.totalstall();
}
