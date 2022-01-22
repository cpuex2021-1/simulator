#include "DisAssembler.hpp"
#include "util.hpp"
#include <sstream>

using namespace std;

string disassemble(uint32_t instr){
    
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
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
        uint32_t funct11 = getBits(instr, 21, 11);

        switch (funct3)
        {
        case 0:
            switch (funct11)
            {
            case 0:
                ss << "ADD " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
                break;
            case 1:
                ss << "SUB " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
                break;            
            default:
                return "Unknown Instruction";
                break;
            }
            break;
        case 1:
            ss << "SLL " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 2:
            switch (funct11)
            {
            case 0:
                ss << "SRL " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
                break;
            case 1:
                ss << "SRA " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
                break;
            default:
                return "Unknown Instruction";
                break;
            }
            break;
        case 3:
            ss << "SLT " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 4:
            ss << "SLTU " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 5:
            ss << "XOR " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 6:
            ss << "OR " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 7:
            ss << "AND " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 1:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        switch (funct3)
        {
        case 0:
            ss << "MUL " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 1:
            ss << "MULH " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 2:
            ss << "MULHSU " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 3:
            ss << "MULHU " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 4:
            ss << "DIV " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 5:
            ss << "DIVU " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 6:
            ss << "REM " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        case 7:
            ss << "REMU " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << xregName.at(rs2); 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 2:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "FADD " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 1:
            ss << "FSUB " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 2:
            ss << "FMUL " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 3:
            ss << "FDIV " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 4:
            ss << "FSQRT " << fregName.at(rd) << ", " << fregName.at(rs1);
            break;
        case 5:
            ss << "FNEG " << fregName.at(rd) << ", " << fregName.at(rs1);
            break;
        case 6:
            ss << "FMIN " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 7:
            ss << "FMAX " << fregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 3:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "FEQ " << xregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 1:
            ss << "FLT " << xregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 2:
            ss << "FLE " << xregName.at(rd) << ", " << fregName.at(rs1) << ", " << fregName.at(rs2); 
            break;
        case 3:
            ss << "FMV.X.W " << xregName.at(rd) << ", " << fregName.at(rs1); 
            break;            
        case 4:
            ss << "FMV.W.X " << fregName.at(rd) << ", " << xregName.at(rs1); 
            break;
        case 5:
            ss << "FMV " << fregName.at(rd) << ", " << fregName.at(rs1); 
            break;
        case 6:
            ss << "ITOF " << xregName.at(rd) << ", " << fregName.at(rs1);
            break;
        case 7:
            ss << "FTOI " << fregName.at(rd) << ", " << xregName.at(rs1);
            break;
        
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 4:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int32_t imm = getSextBits(instr, 21, 6);
        int32_t shamt = getSextBits(instr, 10, 6);
        uint32_t judge = getBits(instr, 11, 11);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "ADDI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        case 1:
            ss << "SLLI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << shamt; 
            break;
        case 2:
            if(judge){
                ss << "SRLI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << shamt; 
                break;
            }else{
                ss << "SRAI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << shamt; 
                break;
            }
        case 3:
            ss << "SLTI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        case 4:
            ss << "SLTUI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        case 5:
            ss << "XORI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        case 6:
            ss << "ORI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        case 7:
            ss << "ANDI " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm; 
            break;
        default:
            return "Unknown Instruction";
            break;
        }
        break;
    }
    case 5:
    {
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int32_t offset = getSextBits(instr, 21, 6);
        uint32_t luioffset = getBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            ss << "LW " << xregName.at(rd) << ", " << offset << "(" << xregName.at(rs1) << ")"; 
            break;
        case 1:
            ss << "FLW " << fregName.at(rd) << ", " << offset << "(" << xregName.at(rs1) << ")"; 
            break;
        case 2:
            ss << "LUI " << xregName.at(rd) << ", " << (((rs1 << 16) + luioffset) << 12);
            break;

        case 5:
            ss << "FSIN " << xregName.at(rd) << ", " << xregName.at(rs1); 
            break;
        case 6:
            ss << "FCOS " << fregName.at(rd) << ", " << xregName.at(rs1);
            break;
        case 7:
            ss << "ATAN " << xregName.at(rd) << ", " << xregName.at(rs1);
            break;
        default:
            return "Unknown Instruction";
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
            ss << "BEQ " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 1:
            ss << "BNE " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 2:
            ss << "BLT " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 3:
            ss << "BGE " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 4:
            ss << "BLTU " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 5:
            ss << "BGEU " << xregName.at(rs1) << ", " << xregName.at(rs2) << ", " << imm; 
            break;
        case 6:
            ss << "SW " << xregName.at(rs2) << ", " << imm << "(" << xregName.at(rs1) << ")";
            break;
        case 7:
            ss << "FSW " << fregName.at(rs2) << ", " << imm << "(" << xregName.at(rs1) << ")";
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
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int32_t imm = getSextBits(instr, 21, 6);
        
        switch (funct3)
        {
        case 0:
            ss << "JUMP " << addr;
            break;
        case 1:
            ss << "JAL " << xregName.at(rd) << ", " << imm;
            break;
        case 2:
            ss << "JALR " << xregName.at(rd) << ", " << xregName.at(rs1) << ", " << imm;
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


map<int, string> xregName{
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
    {31, "r2"}
};

map<int, string> fregName {
    {0, "fzero"},
    {1, "fsw"},
    {2, "f0"},
    {3, "f1"},
    {4, "f2"},
    {5, "f3"},
    {6, "f4"},
    {7, "f5"},
    {8, "f6"},
    {9, "f7"},
    {10, "f8"},
    {11, "f9"},
    {12, "f10"},
    {13, "f11"},
    {14, "f12"},
    {15, "f13"},
    {16, "f14"},
    {17, "f15"},
    {18, "f16"},
    {19, "f17"},
    {20, "f18"},
    {21, "f19"},
    {22, "f20"},
    {23, "f21"},
    {24, "f22"},
    {25, "f23"},
    {26, "f24"},
    {27, "f25"},
    {28, "f26"},
    {29, "fr0"},
    {30, "fr1"},
    {31, "fr2"}
};