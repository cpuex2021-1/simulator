#pragma once
#include <string>
#include <regex>
#include <map>
using namespace std;

class Instruction
{
public:
    virtual unsigned int assemble()=0;
};

class Rtype : public Instruction
{
protected:
    unsigned int opcode;
    unsigned int funct3;
    unsigned int rd;
    unsigned int rs1;
    unsigned int rs2;
    unsigned int funct10;

public:
    Rtype(unsigned int op_, unsigned int funct3_, unsigned int rd_, unsigned int rs1_, unsigned int rs2_, unsigned int funct10_);
    unsigned int assemble() override;
};

class I_Ltype : public Instruction
{
protected:
    unsigned int opcode;
    unsigned int funct3;
    unsigned int rd;
    unsigned int rs1;
    int imm;

public:
    I_Ltype(unsigned int op_,unsigned int funct3_,unsigned int rd_,unsigned int rs1_,int imm_);
    unsigned int assemble() override;
};

class S_Btype : public Instruction
{
protected:
    unsigned int opcode;
    unsigned int funct3;
    unsigned int rs1;
    unsigned int rs2;
    int imm;

public:
    S_Btype(unsigned int op_,unsigned int funct3_,unsigned int rs1_,unsigned int rs2_,int imm_);
    unsigned int assemble() override;
};

class Jtype : public Instruction
{
protected:
    unsigned int opcode;
    unsigned int funct3;
    unsigned int addr;

public:
    Jtype(unsigned int op_, unsigned int funct3_, unsigned int addr_);
    unsigned int assemble() override;
};

extern map<string, unsigned int> xregs;
extern map<string, unsigned int> fregs;
extern map<string, unsigned int> labels;