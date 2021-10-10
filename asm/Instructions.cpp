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
    {"r0", 0},
    {"r1", 1}
};
map<string, unsigned int> labels;