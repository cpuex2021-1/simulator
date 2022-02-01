#include "Compiler.hpp"
#include "../lib/util.hpp"

#define SLIDE 10

#ifdef STDFPU
#define FPU StdFPU
#else
#define FPU OrenoFPU
#endif

Compiler::Compiler()
: rt(), code(), cc(initCode(&code)), regAllocList(REGNUM+FREGNUM), memDestRd(-2), labellistIdx(0)
{
}

Compiler::~Compiler(){
    for(unsigned int i=0; i<nodes.size(); i++){
        free(nodes[i]);
    }
}

x86::Gp Compiler::getRegGp(int i){
    return getGp(i, false);
}

x86::Gp Compiler::getFregGp(int i){
    return getGp(i + 32, false);
}

x86::Gp Compiler::getRdRegGp(int i){
    return getGp(i, true);
}

x86::Gp Compiler::getRdFregGp(int i){
    return getGp(i + 32, true);
}

x86::Gp Compiler::getGp(int i, bool isrd){
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

void Compiler::bindLabel(int pc){
    cc.bind(pctolabel(pc));
} 

void Compiler::setUpLabel(){
    endLabel = cc.newLabel();
    ann = cc.newJumpAnnotation();
    for(uint64_t i=0; i<instructions.size(); i++){
        Label* l = new Label;
        (*l) = cc.newLabel();
        pctolabelptr[i] = l;
        cc.embedLabel(*l, sizeof(uint64_t));
    }

    pctolabelptr[instructions.size()] = &endLabel;

    for(int i=0; i<SLIDE; i++){
        cc.embedLabel(endLabel);
    }
}

void Compiler::LoadAllRegs(){
    for(unsigned int i=0; i<regAllocList.size(); i++){
        if(regAllocList[i].valid){
            cc.mov(regAllocList[i].gp, x86::dword_ptr((uint64_t)&reg[i]));
        }        
    }    
}

void Compiler::StoreAllRegs(){
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
    cout << " Instruction: " << str_instr[pc_to_line(pc)] << endl;/*
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


void Compiler::compileSingleInstruction(int pc){

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
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.add(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.add(getRdRegGp(rd), getRegGp(rs1));
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.add(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            case 1:
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.sub(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.sub(getRdRegGp(rd), getRegGp(rs1));
                    cc.neg(getRdRegGp(rd));
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.sub(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.sal(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1));
                cc.sal(tmpReg, getRegGp(rs2));
                cc.mov(getRdRegGp(rd), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.sal(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 2:
            switch (funct11)
            {
            case 0:
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.mov(tmpReg, getRegGp(rs1));
                    cc.shr(tmpReg, getRegGp(rs2));
                    cc.mov(getRdRegGp(rd), tmpReg);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.shr(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            case 1:
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.mov(tmpReg, getRegGp(rs1));
                    cc.sar(tmpReg, getRegGp(rs2));
                    cc.mov(getRdRegGp(rd), tmpReg);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.sar(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            default:
                throw_err(instr); return;
                break;
            }
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.sets(getRdRegGp(rd));
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.setb(getRdRegGp(rd));
            break;
        case 5:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.xor_(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.xor_(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.or_(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.or_(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.or_(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.and_(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.and_(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.and_(getRdRegGp(rd), getRegGp(rs2));
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
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
                cc.sar(getRdRegGp(rd), 32);
            }
            break;
        case 2:
            //Not supported
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.imul(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.imul(getRdRegGp(rd), getRegGp(rs2));
                cc.sar(getRdRegGp(rd), 32);
            }
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.mul(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.mul(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.mul(getRdRegGp(rd), getRegGp(rs2));
                cc.shr(getRdRegGp(rd), 32);
            }
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.idiv(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1));
                cc.idiv(tmpReg, getRegGp(rs2));
                cc.mov(getRdRegGp(rd), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.idiv(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 5:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.div(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.mov(tmpReg, getRegGp(rs1));
                cc.div(tmpReg, getRegGp(rs2));
                cc.mov(getRdRegGp(rd), tmpReg);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.div(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.mov(tmpReg, getRegGp(rs1));
            cc.idiv(tmpReg, getRegGp(rs2));
            cc.imul(tmpReg, getRegGp(rs2));
            cc.sub(getRdRegGp(rs1), tmpReg);
            cc.mov(getRdRegGp(rd), getRegGp(rs1));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.mov(tmpReg, getRegGp(rs1));
            cc.div(tmpReg, getRegGp(rs2));
            cc.mul(tmpReg, getRegGp(rs2));
            cc.sub(getRdRegGp(rs1), tmpReg);
            cc.mov(getRdRegGp(rd), getRegGp(rs1));
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
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fadd, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fsub, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fmul, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fdiv, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::fsqrt, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 5:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::fneg, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fabs, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::floor, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
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
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::feq, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::flt, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1+REGNUM, rs2+REGNUM);
            cc.invoke(&fpuInvokeNode, FPU::fle, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.mov(getRdRegGp(rd), getFregGp(rs1));
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.mov(getRdFregGp(rd), getRegGp(rs1));
            break;
        case 5:            
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.mov(getRdFregGp(rd), getFregGp(rs1));
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::ftoi, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
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
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.add(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.add(getRdRegGp(rd), imm);
            }
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.sal(getRdRegGp(rd), shamt);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.sal(getRdRegGp(rd), shamt);
            }
            break;
        case 2:
            if(judge){
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd), shamt);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.sar(getRdRegGp(rd), shamt);
                }
            }else{
                preProcs(false, pc, memdestRd, rs1, rs2);
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd), shamt);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.shr(getRdRegGp(rd), shamt);
                }
            }
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), imm);
            cc.sets(getRdRegGp(rd));
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), imm);
            cc.setb(getRdRegGp(rd));
            break;
        case 5:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.xor_(getRdRegGp(rd), imm);
            }
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.or_(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.or_(getRdRegGp(rd), imm);
            }
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.and_(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.and_(getRdRegGp(rd), imm);
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
            preProcs(false, pc, rd, rs1, rs2);
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<int, void>());
                uartInvokeNode->setRet(0, getRdRegGp(rd));
            }else{
                cc.mov(tmpReg, getRegGp(rs1));
                cc.add(tmpReg, offset);
                cc.invoke(&cacheInvokeNode, Memory::readJit, FuncSignatureT<int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setRet(0, getRdRegGp(rd));
            }                        
            break;
        case 1:
            preProcs(false, pc, rd+REGNUM, rs1, rs2);
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<int, void>());
                uartInvokeNode->setRet(0, getRdFregGp(rd));
            }else{
                cc.mov(tmpReg, getRegGp(rs1));
                cc.add(tmpReg, offset);
                cc.invoke(&cacheInvokeNode, Memory::readJit, FuncSignatureT<int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setRet(0, getRdFregGp(rd));
            }                        
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.mov(getRdRegGp(rd), ((rs1 << 16) + luioffset) << 12);
            break;

        #ifdef STDFPU
        case 5:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::fsin, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::fcos, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1+REGNUM, -1);
            cc.invoke(&fpuInvokeNode, FPU::atan, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
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
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.je(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jne(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);

            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jl(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jge(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jb(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
            
        case 5:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jae(pctolabel(pc+imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<void, int>());
                uartInvokeNode->setArg(0, getRegGp(rs2));
            }else{
                cc.mov(tmpReg, getRegGp(rs1));
                cc.add(tmpReg, imm);
                cc.invoke(&cacheInvokeNode, Memory::writeJit, FuncSignatureT<void, int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setArg(1, getRegGp(rs2));
            }
            break;

        case 7:
            preProcs(false, pc, memdestRd, rs1, rs2+REGNUM);
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<void, int>());
                uartInvokeNode->setArg(0, getFregGp(rs2));
            }else{
                cc.mov(tmpReg, getRegGp(rs1));
                cc.add(tmpReg, imm);
                cc.invoke(&cacheInvokeNode, Memory::writeJit, FuncSignatureT<void, int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setArg(1, getFregGp(rs2));
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
            preProcs(false, pc, memdestRd, -1, -1);
            cc.jmp(pctolabel(addr));
            break;
        case 1:
            preProcs(true, pc, memdestRd, -1, -1);
            cc.mov(getRdRegGp(rd), pc+1);
            cc.jmp(pctolabel(imm));
            break;
        case 2:
            preProcs(true, pc, memdestRd, rs1, -1);
            cc.mov(getRdRegGp(rd), pc+1);
            cc.mov(qtmpReg, x86::qword_ptr(jumpBase, getRegGp(rs1), 3, imm * 8));
            cc.jmp(qtmpReg, ann);
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

    #ifdef JITDEBUG 
    FileLogger logger(stderr);
    code->setLogger(&logger);
    #endif
       
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
    setUpLabel();

    //function body
    cc.bind(RunLabel);

    //jump table setup
    jumpBase = cc.newGpq();
    cc.lea(jumpBase, x86::ptr(jTableLabel));

    for(unsigned int i=0; i<instructions.size(); i++){
        compileSingleInstruction(i);
    }

    cc.jmp(endLabel);
    
    //Load register
    cc.bind(LoadLabel);
    LoadAllRegs();
    cc.jmp(RunLabel);
    
    //end
    cc.bind(endLabel);
    ann->addLabel(endLabel);

    //Store register
    StoreAllRegs();

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

void Compiler::preProcs(bool usera, int pc, int memdestRd, int rs1, int rs2){
    

    if((memDestRd == rs1 || memDestRd == rs2)){
        memDestRd = memdestRd;
        cc.inc(numDataHazardptr);
    }else{
        memDestRd = memdestRd;
    }

    bindLabel(pc);
    
    if(hasDebuggingInfo){
        if(labellist[labellistIdx].pc == (uint32_t)pc){
            ann->addLabel(pctolabel(pc));
            while(labellist[labellistIdx].pc == (uint32_t)pc){
                labellistIdx++;
            }
        }
        else if(usera) ann->addLabel(pctolabel(pc+1));
    }else{
        ann->addLabel(pctolabel(pc));
    }

    cc.mov(qtmpReg, x86::qword_ptr((uint64_t) &(numExecuted[pc])));
    cc.inc(qtmpReg);
    cc.mov(x86::qword_ptr((uint64_t) &(numExecuted[pc])), qtmpReg);
}

void Compiler::reset(){
    Simulator::reset();
    regAllocList = vector<regAlloc> (REGNUM+FREGNUM);
}

#undef FPU