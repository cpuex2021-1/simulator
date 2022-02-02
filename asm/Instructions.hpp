#pragma once
#include <string>
#include <regex>
#include <map>
using namespace std;

inline uint32_t Rtype(uint32_t op, uint32_t funct3, uint32_t rd, uint32_t rs1, uint32_t rs2, uint32_t funct10){
    op &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    rs2 &= ((1 << 6) - 1);
    funct10 &= ((1 << 4) - 1);
    rs1 &= ((1 << 6) - 1);
    rd &= ((1 << 6) - 1);
    
    return (rs1 << 26) | (rd << 20) | (funct10 << 16) | (rs2 << 6) | (funct3 << 3) | op;
}

inline uint32_t ILtype(uint32_t op, uint32_t funct3, uint32_t rd, uint32_t rs1, int32_t imm){
    op &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    imm &= ((1 << 14) - 1);    
    rs1 &= ((1 << 6) - 1);
    rd &= ((1 << 6) - 1);

    return (rs1 << 26) | (rd << 20) | (imm << 6) | (funct3 << 3) | op; 
}

inline uint32_t SBtype(uint32_t op, uint32_t funct3, uint32_t rs1, uint32_t rs2,int32_t imm){
    op &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    imm &= ((1 << 14) - 1);    
    rs1 &= ((1 << 6) - 1);
    rs2 &= ((1 << 6) - 1);

    return (rs1 << 26) | (imm << 12) | (rs2 << 6) | (funct3 << 3) | op;
}

inline uint32_t Jtype(uint32_t op, uint32_t funct3, uint32_t addr){
    op &= ((1 << 3) - 1);
    funct3 &= ((1 << 3) - 1);
    addr &= ((1 << 25) - 1);

    return (addr << 6) | (funct3 << 3) | op;
}

extern map<string, uint32_t> xregs;
extern map<string, uint32_t> fregs;
extern map<string, uint32_t> labels;