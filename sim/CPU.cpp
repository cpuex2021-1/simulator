#include "CPU.hpp"

using namespace std;

CPU::CPU()
{
    pc = 0;
    clk = 0;
    numInstruction = 0;
    num1stall = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    numDataHazard = 0;

    memDestRd = -1;

    mem = new Memory();
    reg = new int32_t[REGNUM + FREGNUM];
    freg = &reg[REGNUM];
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0; freg[i] = 0;
    }
    reg[2] = MEMSIZE - 1;
    reg[3] = MEMSIZE / 2;
}

CPU::~CPU(){
    delete mem;
    delete reg;
}

void CPU::print_register(){
    cout << " ";
    for(int i=0; i<REGNUM; i++){
    if(i % 8 == 0 && i > 0) cout << endl << " ";
        cout << left << setw(6) << xregName[i] + ":" << right << setw(8) << reg[i] << " " << dec;
    }
    cout << endl << " ";
    for(int i=0; i<FREGNUM; i++){
        if(i % 8 == 0 && i>0) cout << endl << " ";
        cout << left << setw(6) << fregName[i] + ":" << right << setw(8) << freg[i] << " " << dec;
    }
    cout << endl;
}

void CPU::reset(){
    for(int i=0; i<REGNUM; i++){
        reg[i] = 0;
    }
    for(int i=0; i<FREGNUM; i++){
        freg[i] = 0;
    }
    reg[2] = MEMSIZE - 1;
    reg[3] = MEMSIZE / 2;
    pc = 0;
    clk = 0;
    numInstruction = 0;
    num1stall = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    numDataHazard = 0;
    mem->reset();
    p.reset();
    log.reset();
}


void CPU::throw_err(int instr){
    stringstream sserr;
    sserr << "Invalid_instruction: ";
    for(int i=31; i>=0; i--){
        sserr << (instr >> i & 1);
    }
    sserr << endl;
    throw invalid_argument(sserr.str());
}


void CPU::revert(){
    if(log.logSize <= 0) return;
    auto logd = log.pop();
    if(logd.rd > 0){
        reg[logd.rd] = logd.former_val;
        if(logd.memAddr == 0){
            mem->uart.revertPop();
        }
    }else{
        if(logd.memAddr > 0){
            mem->write_without_cache(logd.memAddr, logd.former_val);
        }
        else if(logd.memAddr == 0){
            mem->uart.revertPush();
        }
    }

    pc = logd.pc;

    //p.revert(pc, clk);
}

void CPU::update_clkcount(){
    clk = numInstruction + 1 * num2stall + 2 * num3stall + 3 * num4stall + 1 * numDataHazard + 2 * numFlush + mem->totalstall();
}