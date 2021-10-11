#include "Instructions.hpp"
using namespace std;

Rtype :: Rtype(unsigned int op_, unsigned int funct3_, unsigned int rd_, unsigned int rs1_, unsigned int rs2_, unsigned int funct10_)
: opcode(op_), funct3(funct3_), rd(rd_), rs1(rs1_), rs2(rs2_), funct10(funct10_)
{}

unsigned int Rtype :: assemble(){
    opcode &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    rs2 &= ((1 << 5) - 1);
    funct10 &= ((1 << 10) - 1);
    rs1 &= ((1 << 5) - 1);
    rd &= ((1 << 5) - 1);
    
    return (rs1 << 27) | (rd << 22) | (funct10 << 11) | (rs2 << 6) | (funct3 << 3) | opcode;
}

I_Ltype :: I_Ltype(unsigned int op_,unsigned int funct3_,unsigned int rd_,unsigned int rs1_,int imm_)
: opcode(op_), funct3(funct3_), rd(rd_), rs1(rs1_), imm(imm_)
{}

unsigned int I_Ltype :: assemble(){
    opcode &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    imm &= ((1 << 16) - 1);    
    rs1 &= ((1 << 5) - 1);
    rd &= ((1 << 5) - 1);

    return (rs1 << 27) | (rd << 22) | (imm << 6) | (funct3 << 3) | opcode; 
}

S_Btype :: S_Btype(unsigned int op_,unsigned int funct3_,unsigned int rs1_,unsigned int rs2_,int imm_)
: opcode(op_), funct3(funct3_), rs1(rs1_), rs2(rs2_), imm(imm_)
{}

unsigned int S_Btype :: assemble(){
    opcode &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    imm &= ((1 << 16) - 1);    
    rs1 &= ((1 << 5) - 1);
    rs2 &= ((1 << 5) - 1);

    return (rs1 << 27) | (imm << 11) | (rs2 << 6) | (funct3 << 3) | opcode;
}

Jtype :: Jtype(unsigned int op_, unsigned int funct3_, unsigned int addr_)
: opcode(op_), funct3(funct3_), addr(addr_)
{}

unsigned int Jtype :: assemble(){
    opcode &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    addr &= ((1 << 25) - 1);

    return (addr << 6) | (funct3 << 3) | opcode;
}
map<string, unsigned int> regs = {
    {"zero", 0},
    {"ra", 1},
    {"sp", 2},
    {"gp", 3},
    {"tp", 4},
    {"t0", 5},
    {"t1", 6},
    {"t2", 7},
    {"s0", 8},
    {"s1", 9},
    {"a0", 10},
    {"a1", 11},
    {"a2", 12},
    {"a3", 13},
    {"a4", 14},
    {"a5", 15},
    {"a6", 16},
    {"a7", 17},
    {"r0", 10},
    {"r1", 11},
    {"r2", 12},
    {"r3", 13},
    {"r4", 14},
    {"r5", 15},
    {"r6", 16},
    {"r7", 17},
    {"s2", 18},
    {"s3", 19},
    {"s4", 20},
    {"s5", 21},
    {"s6", 22},
    {"s7", 23},
    {"s8", 24},
    {"s9", 25},
    {"s10", 26},
    {"s11", 27},
    {"t3", 28},
    {"t4", 29},
    {"t5", 30},
    {"t6", 31},
    {"ft0", 0},
    {"ft1", 1},
    {"ft2", 2},
    {"ft3", 3},
    {"ft4", 4},
    {"ft5", 5},
    {"ft6", 6},
    {"ft7", 7},
    {"fs0", 8},
    {"fs1", 9},
    {"fa0", 10},
    {"fa1", 11},
    {"fa2", 12},
    {"fa3", 13},
    {"fa4", 14},
    {"fa5", 15},
    {"fa6", 16},
    {"fa7", 17},
    {"fs2", 18},
    {"fs3", 19},
    {"fs4", 20},
    {"fs5", 21},
    {"fs6", 22},
    {"fs7", 23},
    {"fs8", 24},
    {"fs9", 25},
    {"fs10", 26},
    {"fs11", 27},
    {"ft8", 28},
    {"ft9", 29},
    {"ft10", 30},
    {"ft11", 31}
};
map<string, unsigned int> labels;