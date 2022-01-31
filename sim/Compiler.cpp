#include "Compiler.hpp"
#include "../lib/util.hpp"

#define SLIDE 10

#ifdef STDFPU
#define FPU StdFPU
#else
#define FPU OrenoFPU
#endif

Compiler::Compiler()
: regAllocList(REGNUM+FREGNUM), memDestRd(-2)
{
}

Compiler::~Compiler(){
    for(unsigned int i=0; i<nodes.size(); i++){
        free(nodes[i]);
    }
}

x86::Gp Compiler::getRegGp(int i, x86::Compiler& cc){
    return getGp(i, false, cc);
}

x86::Gp Compiler::getFregGp(int i, x86::Compiler& cc){
    return getGp(i + 32, false, cc);
}

x86::Gp Compiler::getRdRegGp(int i, x86::Compiler& cc){
    return getGp(i, true, cc);
}

x86::Gp Compiler::getRdFregGp(int i, x86::Compiler& cc){
    return getGp(i + 32, true, cc);
}

x86::Gp Compiler::getGp(int i, bool isrd, x86::Compiler& cc){
    if(i != 0 && i != 32)
    {
        if(!regAllocList[i].valid){
            regAllocList[i].valid = true;
            regAllocList[i].gp = cc.newGpd();
        }        
        return regAllocList[i].gp;
    }else{
        if(isrd) return tmpReg;
        else return zero;
    }
}

void Compiler::bindLabel(int pc, x86::Compiler& cc){
    cc.bind(pctolabel(pc));
} 

void Compiler::setUpLabel(x86::Compiler& cc){
    *endLabel = cc.newLabel();
    ann = cc.newJumpAnnotation();
    for(uint64_t i=0; i<instructions.size(); i++){
        Label* l = new Label;
        (*l) = cc.newLabel();
        pctolabelptr[i] = l;
        cc.embedLabel(*l, sizeof(uint64_t));
        /*
        cc.lea(qtmpReg, x86::ptr(*l));
        cc.mov(x86::qword_ptr((uint64_t)&(pctoaddr[i])), qtmpReg);
        */
        ann->addLabel(*l);
    }

    pctolabelptr[instructions.size()] = endLabel;

    //cc.lea(qtmpReg, x86::ptr(*endLabel));
    for(int i=0; i<SLIDE; i++){
        cc.embedLabel(*endLabel);
        //cc.mov(x86::qword_ptr((uint64_t)&(pctoaddr[i+instructions.size()])), qtmpReg);
    }
}

void Compiler::LoadAllRegs(x86::Compiler& cc){
    for(unsigned int i=0; i<regAllocList.size(); i++){
        if(regAllocList[i].valid){
            cc.mov(regAllocList[i].gp, x86::dword_ptr((uint64_t)&reg[i]));
        }        
    }    
}

void Compiler::StoreAllRegs(x86::Compiler& cc){
    for(unsigned int i=0; i<regAllocList.size(); i++){
        if(regAllocList[i].valid){
            cc.mov(x86::dword_ptr((uint64_t)&reg[i]), regAllocList[i].gp);
        }       
    }
}

void Compiler::JitBreakPoint(int pc){
    cout << "PC: " << pc;
    cout << " LINE: " << pc_to_line(pc);
    cout << " CLK: " << numInstruction << "\n";
    cout << " Instruction: " << str_instr[pc_to_line(pc)] << "\n";/*
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
}


void Compiler::compileSingleInstruction(int pc, x86::Compiler& cc){
    int memdestRd = -2;

    unsigned int instr = instructions[pc];
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    int rd = -1;
    int rs1 = -1;
    int rs2 = -1;

    switch (op)
    {
    case 0:
    {
        rd = getBits(instr, 26, 22);
        rs1 = getBits(instr, 31, 27);
        rs2 = getBits(instr, 10, 6);
        unsigned int funct11 = getBits(instr, 21, 11);
        
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d funct11:%d\n", op, funct3, rd, rs1, rs2, funct11);
        #endif

        switch (funct3)
        {
        case 0:
            switch (funct11)
            {
            case 0:
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.add(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }else if(rd == rs2){
                    cc.add(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.add(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }
                break;
            case 1:
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.sub(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }else if(rd == rs2){
                    cc.sub(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.neg(getRdRegGp(rd,cc));
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.sub(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }
                break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 1:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.sal(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1,cc));
                cc.sal(tmpReg, getRegGp(rs2,cc));
                cc.mov(getRdRegGp(rd,cc), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.sal(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 2:
            switch (funct11)
            {
            case 0:
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }else if(rd == rs2){
                    cc.mov(tmpReg, getRegGp(rs1,cc));
                    cc.shr(tmpReg, getRegGp(rs2,cc));
                    cc.mov(getRdRegGp(rd,cc), tmpReg);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.shr(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }
                break;
            case 1:
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }else if(rd == rs2){
                    cc.mov(tmpReg, getRegGp(rs1,cc));
                    cc.sar(tmpReg, getRegGp(rs2,cc));
                    cc.mov(getRdRegGp(rd,cc), tmpReg);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.sar(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                }
                break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 3:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.sets(getRdRegGp(rd,cc));
            break;
        case 4:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.setb(getRdRegGp(rd,cc));
            break;
        case 5:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.xor_(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.xor_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 6:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.or_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.or_(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.or_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 7:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.and_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.and_(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.and_(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 1:
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
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 1:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                cc.sar(getRdRegGp(rd,cc), 32);
            }
            break;
        case 2:
            //Not supported
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.imul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                cc.sar(getRdRegGp(rd,cc), 32);
            }
            break;
        case 3:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.mul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.mul(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.mul(getRdRegGp(rd,cc), getRegGp(rs2,cc));
                cc.shr(getRdRegGp(rd,cc), 32);
            }
            break;
        case 4:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.idiv(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1,cc));
                cc.idiv(tmpReg, getRegGp(rs2,cc));
                cc.mov(getRdRegGp(rd,cc), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.idiv(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 5:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.div(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1,cc));
                cc.div(tmpReg, getRegGp(rs2,cc));
                cc.mov(getRdRegGp(rd,cc), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.div(getRdRegGp(rd,cc), getRegGp(rs2,cc));
            }
            break;
        case 6:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.mov(tmpReg, getRegGp(rs1,cc));
            cc.idiv(tmpReg, getRegGp(rs2,cc));
            cc.imul(tmpReg, getRegGp(rs2,cc));
            cc.sub(getRdRegGp(rs1,cc), tmpReg);
            cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            break;
        case 7:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.mov(tmpReg, getRegGp(rs1,cc));
            cc.div(tmpReg, getRegGp(rs2,cc));
            cc.mul(tmpReg, getRegGp(rs2,cc));
            cc.sub(getRdRegGp(rs1,cc), tmpReg);
            cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            break;
        default:
            throw_err(instr); return;
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

        InvokeNode* fpuInvokeNode; getNewInvokeNode(fpuInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fadd, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 1:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fsub, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 2:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fmul, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 3:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fdiv, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 4:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::fsqrt, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 5:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::fneg, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 6:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fabs, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 7:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::floor, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        default:
            throw_err(instr); return;
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
        
        InvokeNode* fpuInvokeNode; getNewInvokeNode(fpuInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::feq, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 1:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::flt, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 2:
            preProcs(pc, memdestRd, rs1+REGNUM, rs2+REGNUM, cc);
            cc.invoke(&fpuInvokeNode, FPU::fle, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 3:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.mov(getRdRegGp(rd,cc), getFregGp(rs1,cc));
            break;
        case 4:
            preProcs(pc, memdestRd, rs1, -1, cc);
            cc.mov(getRdFregGp(rd,cc), getRegGp(rs1,cc));
            break;
        case 5:            
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.mov(getRdFregGp(rd,cc), getFregGp(rs1,cc));
            break;
        case 6:
            preProcs(pc, memdestRd, rs1, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 7:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::ftoi, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        
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
        int imm = getSextBits(instr, 21, 6);
        int shamt = getSextBits(instr, 10, 6);
        unsigned int judge = getBits(instr, 11, 11);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.add(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.add(getRdRegGp(rd,cc), imm);
            }
            break;
        case 1:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.sal(getRdRegGp(rd,cc), shamt);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.sal(getRdRegGp(rd,cc), shamt);
            }
            break;
        case 2:
            if(judge){
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd,cc), shamt);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.sar(getRdRegGp(rd,cc), shamt);
                }
            }else{
                preProcs(pc, memdestRd, rs1, rs2, cc);
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd,cc), shamt);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.shr(getRdRegGp(rd,cc), shamt);
                }
            }
            break;
        case 3:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), imm);
            cc.sets(getRdRegGp(rd,cc));
            break;
        case 4:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), imm);
            cc.setb(getRdRegGp(rd,cc));
            break;
        case 5:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.xor_(getRdRegGp(rd,cc), imm);
            }
            break;
        case 6:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.or_(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.or_(getRdRegGp(rd,cc), imm);
            }
            break;
        case 7:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rd == rs1){
                cc.and_(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.and_(getRdRegGp(rd,cc), imm);
            }
            break;
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
        int offset = getSextBits(instr, 21, 6);
        unsigned int luioffset = getBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        InvokeNode* cacheInvokeNode; getNewInvokeNode(cacheInvokeNode);
        InvokeNode* uartInvokeNode; getNewInvokeNode(uartInvokeNode);
        InvokeNode* fpuInvokeNode; getNewInvokeNode(fpuInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(pc, rd, rs1, rs2, cc);
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<int, void>());
                uartInvokeNode->setRet(0, getRdRegGp(rd,cc));
            }else{
                cc.mov(tmpReg, getRegGp(rs1, cc));
                cc.add(tmpReg, offset);
                cc.invoke(&cacheInvokeNode, Memory::readJit, FuncSignatureT<int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setRet(0, getRdRegGp(rd, cc));
            }                        
            break;
        case 1:
            preProcs(pc, rd+REGNUM, rs1, rs2, cc);
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<int, void>());
                uartInvokeNode->setRet(0, getRdFregGp(rd,cc));
            }else{
                cc.mov(tmpReg, getRegGp(rs1, cc));
                cc.add(tmpReg, offset);
                cc.invoke(&cacheInvokeNode, Memory::readJit, FuncSignatureT<int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setRet(0, getRdFregGp(rd, cc));
            }                        
            break;
        case 2:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.mov(getRdRegGp(rd,cc), ((rs1 << 16) + luioffset) << 12);
            break;

        #ifdef STDFPU
        case 5:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::fsin, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 6:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::fcos, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 7:
            preProcs(pc, memdestRd, rs1+REGNUM, -1, cc);
            cc.invoke(&fpuInvokeNode, FPU::atan, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
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
        int imm = getSextBits(instr, 26, 11);
        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        InvokeNode* cacheInvokeNode; getNewInvokeNode(cacheInvokeNode);
        InvokeNode* uartInvokeNode; getNewInvokeNode(uartInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.je(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 1:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jne(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);

            break;
        case 2:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jl(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 3:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jge(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 4:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jb(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
            
        case 5:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jae(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 6:
            preProcs(pc, memdestRd, rs1, rs2, cc);
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<void, int>());
                uartInvokeNode->setArg(0, getRegGp(rs2,cc));
            }else{
                cc.mov(tmpReg, getRegGp(rs1, cc));
                cc.add(tmpReg, imm);
                cc.invoke(&cacheInvokeNode, Memory::writeJit, FuncSignatureT<void, int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setArg(1, getRegGp(rs2, cc));
            }
            break;

        case 7:
            preProcs(pc, memdestRd, rs1, rs2+REGNUM, cc);
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<void, int>());
                uartInvokeNode->setArg(0, getFregGp(rs2,cc));
            }else{
                cc.mov(tmpReg, getRegGp(rs1, cc));
                cc.add(tmpReg, imm);
                cc.invoke(&cacheInvokeNode, Memory::writeJit, FuncSignatureT<void, int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setArg(1, getFregGp(rs2, cc));
            }                        
            break;
        default:
            throw_err(instr); return;
            break;
        }
        break;
    }
    case 7:
    {
        int addr = getSextBits(instr, 30, 6);
        rs1 = getBits(instr, 31, 27);
        rd = getBits(instr, 26, 22);
        int imm = getSextBits(instr, 21, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif
        
        switch (funct3)
        {
        case 0:
            preProcs(pc, memdestRd, -1, -1, cc);
            cc.jmp(pctolabel(addr));
            break;
        case 1:
            preProcs(pc, memdestRd, -1, -1, cc);
            cc.mov(getRdRegGp(rd,cc), pc+1);
            cc.jmp(pctolabel(imm));
            break;
        case 2:
            preProcs(pc, memdestRd, rs1, -1, cc);
            cc.mov(getRdRegGp(rd,cc), pc+1);
            cc.mov(qtmpReg, x86::qword_ptr(jumpBase, getRegGp(rs1, cc), 3, imm * 8));
            cc.jmp(qtmpReg);
            break;
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
    return;
}

void Compiler::compileAll(){
    cerr << "Started AOT Compilation..." << flush; 
    pctolabelptr = new Label*[instructions.size()+1];
    pctoaddr = new uint64_t[instructions.size()+SLIDE];
    endLabel = new Label;

    JitRuntime rt;
    
    CodeHolder code;
    code.init(rt.environment());

    #ifdef JITDEBUG 
    FileLogger logger(stderr);
    code.setLogger(&logger);
    #endif
    
    x86::Compiler cc(&code);
    
    cc.addFunc(FuncSignatureT<void>());
    
    //statistics setup
    numDataHazardptr = cc.newGpq();
    cc.mov(numDataHazardptr, numDataHazard);
    
    //tmporary register setup
    qtmpReg = cc.newGpq();
    cc.mov(qtmpReg, 0);
    tmpReg = cc.newGpd();
    cc.mov(tmpReg, 0);

    //zero register setup
    zero = cc.newGpd();
    cc.mov(zero, 0);

    RunLabel = cc.newLabel();
    LoadLabel = cc.newLabel();

    //jump to load register
    cc.jmp(LoadLabel);

    //Label initialization
    Label jTableLabel = cc.newLabel();
    cc.bind(jTableLabel);
    setUpLabel(cc);

    //function body
    cc.bind(RunLabel);

    //jump table setup
    jumpBase = cc.newGpq();
    cc.lea(jumpBase, x86::ptr(jTableLabel));

    for(unsigned int i=0; i<instructions.size(); i++){
        compileSingleInstruction(i, cc);
    }

    cc.jmp(*endLabel);
    
    //Load register
    cc.bind(LoadLabel);
    LoadAllRegs(cc);
    cc.jmp(RunLabel);
    
    //end
    cc.bind(*endLabel);
    ann->addLabel(*endLabel);

    //Store register
    StoreAllRegs(cc);

    cc.mov(x86::qword_ptr((uint64_t)&numDataHazard), numDataHazardptr);
    
    cc.ret();
    cc.endFunc();
    cc.finalize();

    Error err = rt.add(&fn, &code);

    if (err) {
        printf("\nAsmJit failed: %s\n", DebugUtils::errorAsString(err));
        exit(1);
    }

    cerr << " complete!\nRunning" << endl;
    
    fn();
    rt.release(fn);

    updateProfilerResult();
    update_clkcount();
}

void Compiler::getNewInvokeNode(InvokeNode*& ptr){
    ptr = (InvokeNode*)malloc(sizeof(InvokeNode));
    nodes.push_back(ptr);
}

int Compiler::run(){
    initProfiler();
    if(mode == accurate) return Simulator::run();
    else if(mode == fast){
        compileAll();
        return 0;
    }
    else return -1;
}

void Compiler::preProcs(int pc, int memdestRd, int rs1, int rs2, x86::Compiler& cc){
    if((memDestRd == rs1 || memDestRd == rs2)){
        memDestRd = memdestRd;
        cc.inc(numDataHazardptr);
    }else{
        memDestRd = memdestRd;
    }

    bindLabel(pc, cc);
    
    /*
    //for_debugging
    //StoreAllRegs(cc);
    cc.mov(x86::qword_ptr((uint64_t)&numInstruction), clkptr);

    InvokeNode* printInvNode;
    cc.invoke(&printInvNode, JitBreakPoint, FuncSignatureT<void, int>());
    printInvNode->setArg(0, pc);
    */

    cc.mov(qtmpReg, x86::qword_ptr((uint64_t) &(numExecuted[pc])));
    cc.inc(qtmpReg);
    cc.mov(x86::qword_ptr((uint64_t) &(numExecuted[pc])), qtmpReg);
}

void Compiler::reset(){
    Simulator::reset();
    regAllocList = vector<regAlloc> (REGNUM+FREGNUM);
}

#undef FPU