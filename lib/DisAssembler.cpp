#include "DisAssembler.hpp"
#include "util.hpp"
#include <sstream>

using namespace std;

string disassemble(uint32_t instr){

    if(instr == 0){
        return "NOP";
    }
    
    uint32_t op = getBits(instr, 2, 0);
    uint32_t funct3 = getBits(instr, 5, 3);

    int32_t rd;
    int32_t rs1;
    int32_t rs2;

    stringstream ss;

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 25, 20);
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        switch (funct3)
        {
        case 0:
            ss << "ADD " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 1:
            ss << "SUB " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;            
        default:
            return "Unknown Instruction";
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
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "FADD " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 1:
            ss << "FSUB " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 2:
            ss << "FMUL " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 3:
            ss << "FDIV " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 4:
            ss << "FSQRT " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        case 5:
            ss << "FNEG " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        case 6:
            ss << "FABS " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 7:
            ss << "FLOOR " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 3:
    {
        rd = getBits(instr, 25, 20);
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "FEQ " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 1:
            ss << "FLT " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        case 2:
            ss << "FLE " << regName.at(rd) << ", " << regName.at(rs1) << ", " << regName.at(rs2); 
            break;
        
        case 6:
            ss << "ITOF " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        case 7:
            ss << "FTOI " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 4:
    {
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        int32_t imm = getSextBits(instr, 19, 6);
        int32_t shamt = getSextBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "ADDI " << regName.at(rd) << ", " << regName.at(rs1) << ", " << imm; 
            break;
        case 1:
            ss << "SLLI " << regName.at(rd) << ", " << regName.at(rs1) << ", " << shamt; 
            break;
        case 2:
            ss << "SRAI " << regName.at(rd) << ", " << regName.at(rs1) << ", " << shamt; 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 5:
    {
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        int32_t offset = getSextBits(instr, 19, 6);
        uint32_t luioffset = getBits(instr, 19, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "LW " << regName.at(rd) << ", " << offset << "(" << regName.at(rs1) << ")"; 
            break;
        /*
        case 1:
            ss << "VLW " << regName.at(rd) << ", " << offset << "(" << regName.at(rs1) << ")"; 
            break;
        */
        case 2:
            ss << "LUI " << regName.at(rd) << ", " << (((rs1 << 16) + luioffset) << 12);
            break;

        case 5:
            ss << "FSIN " << regName.at(rd) << ", " << regName.at(rs1); 
            break;
        case 6:
            ss << "FCOS " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        case 7:
            ss << "ATAN " << regName.at(rd) << ", " << regName.at(rs1);
            break;
        default:
            return "Unknown Instruction";
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
            ss << "BEQ " << regName.at(rs1) << ", " << regName.at(rs2) << ", " << imm; 
            break;
        case 1:
            ss << "BNE " << regName.at(rs1) << ", " << regName.at(rs2) << ", " << imm; 
            break;
        case 2:
            ss << "BLT " << regName.at(rs1) << ", " << regName.at(rs2) << ", " << imm; 
            break;
        case 3:
            ss << "BGE " << regName.at(rs1) << ", " << regName.at(rs2) << ", " << imm; 
            break;
            
        case 5:
            ss << "BNEI " << regName.at(rs1) << ", " << rs2imm << ", " << imm; 
            break;
        case 6:
            ss << "SW " << regName.at(rs2) << ", " << imm << "(" << regName.at(rs1) << ")";
            break;
        case 7:
            ss << "FSW " << regName.at(rs2) << ", " << imm << "(" << regName.at(rs1) << ")";
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 7:
    {
        int32_t addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 26);
        
        switch (funct3)
        {
        case 0:
            ss << "JUMP " << addr;
            break;
        case 1:
            ss << "JUMPR " << regName.at(rs1);
            break;
        case 2:
            ss << "CALL " << addr;
            break;
        case 3:
            ss << "CALLR " << regName.at(rs1);
            break;        
        case 4:
            ss << "RET ";
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    default:
        return "Unknown Instruction";
        break;
    }
    return ss.str();
}


map<int, string> regName{
    {0, "zero"},
    {1, "ra"},
    {2, "sp"},
    {3, "hp"},
    {4, "cl"},
    {5, "swp"},
    {6, "a0"},
    {7, "a1"},
    {8, "a2"},
    {9, "a3"},
    {10, "a4"},
    {11, "a5"},
    {12, "a6"},
    {13, "a7"},
    {14, "a8"},
    {15, "a9"},
    {16, "a10"},
    {17, "a11"},
    {18, "a12"},
    {19, "a13"},
    {20, "a14"},
    {21, "a15"},
    {22, "a16"},
    {23, "a17"},
    {24, "a18"},
    {25, "a19"},
    {26, "a20"},
    {27, "a21"},
    {28, "a22"},
    {29, "r0"},
    {30, "r1"},
    {31, "r2"},
    {32, "fzero"},
    {33, "fsw"},
    {34, "f0"},
    {35, "f1"},
    {36, "f2"},
    {37, "f3"},
    {38, "f4"},
    {39, "f5"},
    {40, "f6"},
    {41, "f7"},
    {42, "f8"},
    {43, "f9"},
    {44, "f10"},
    {45, "f11"},
    {46, "f12"},
    {47, "f13"},
    {48, "f14"},
    {49, "f15"},
    {50, "f16"},
    {51, "f17"},
    {52, "f18"},
    {53, "f19"},
    {54, "f20"},
    {55, "f21"},
    {56, "f22"},
    {57, "f23"},
    {58, "f24"},
    {59, "f25"},
    {60, "f26"},
    {61, "fr0"},
    {62, "fr1"},
    {63, "fr2"}
};