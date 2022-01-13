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
map<string, unsigned int> xregs = {
    {"zero", 0},
    {"ra", 1},
    {"sp", 2},
    {"hp", 3},
    {"cl", 4},
    {"swp", 5},
    {"a0", 6},
    {"a1", 7},
    {"a2", 8},
    {"a3", 9},
    {"a4", 10},
    {"a5", 11},
    {"a6", 12},
    {"a7", 13},
    {"a8", 14},
    {"a9", 15},
    {"a10", 16},
    {"a11", 17},
    {"a12", 18},
    {"a13", 19},
    {"a14", 20},
    {"a15", 21},
    {"a16", 22},
    {"a17", 23},
    {"a18", 24},
    {"a19", 25},
    {"a20", 26},
    {"a21", 27},
    {"a22", 28},
    {"r0", 29},
    {"r1", 30},
    {"r2", 31}
};

map<string, unsigned int> fregs = {
    {"fzero", 0},
    {"fsw", 1},
    {"f0", 2},
    {"f1", 3},
    {"f2", 4},
    {"f3", 5},
    {"f4", 6},
    {"f5", 7},
    {"f6", 8},
    {"f7", 9},
    {"f8", 10},
    {"f9", 11},
    {"f10", 12},
    {"f11", 13},
    {"f12", 14},
    {"f13", 15},
    {"f14", 16},
    {"f15", 17},
    {"f16", 18},
    {"f17", 19},
    {"f18", 20},
    {"f19", 21},
    {"f20", 22},
    {"f21", 23},
    {"f22", 24},
    {"f23", 25},
    {"f24", 26},
    {"f25", 27},
    {"f26", 28},
    {"fr0", 29},
    {"fr1", 30},
    {"fr2", 31}    
};
map<string, unsigned int> labels;