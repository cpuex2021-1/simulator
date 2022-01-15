#include "Compiler.hpp"

#define SLIDE 10

Compiler::Compiler()
: regAllocList(REGNUM+FREGNUM)
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
    for(uint64_t i=0; i<instructions.size(); i++){
        Label* l = new Label;
        (*l) = cc.newLabel();
        pctolabelptr[i] = l;
        cc.lea(qtmpReg, x86::ptr(*l));
        cc.mov(x86::qword_ptr((uint64_t)&(pctoaddr[i])), qtmpReg);
    }

    pctolabelptr[instructions.size()] = endLabel;

    cc.lea(qtmpReg, x86::ptr(*endLabel));
    for(int i=0; i<SLIDE; i++){
        cc.mov(x86::qword_ptr((uint64_t)&(pctoaddr[i+instructions.size()])), qtmpReg);
    }
}

void Compiler::setUpRegs(x86::Compiler& cc){    
    for(unsigned int i=0; i<regAllocList.size(); i++){
        regAllocList[i].gp = cc.newGpd();
        regAllocList[i].valid = true;
    }
}

void Compiler::LoadAllRegs(x86::Compiler& cc){
    for(unsigned int i=0; i<regAllocList.size(); i++){
        cc.mov(regAllocList[i].gp, x86::dword_ptr((uint64_t)&reg[i]));
    }    
}

void Compiler::StoreAllRegs(x86::Compiler& cc){
    for(unsigned int i=0; i<regAllocList.size(); i++){
        cc.mov(x86::dword_ptr((uint64_t)&reg[i]), regAllocList[i].gp);
    }
}

void Compiler::JitBreakPoint(int pc){
    cout << "PC: " << pc << endl;
    cout << "Instruction: " << str_instr[pc_to_line(pc)] << endl;

    print_register();

    cout << endl;
}


void Compiler::compileSingleInstruction(int pc, x86::Compiler& cc){
    bindLabel(pc, cc);
    cc.inc(clkptr);

    #ifdef JITDEBUG

    StoreAllRegs(cc);

    InvokeNode* printInvNode;
    cc.invoke(&printInvNode, JitBreakPoint, FuncSignatureT<void, int>());
    printInvNode->setArg(0, pc);

    #endif

    unsigned int instr = instructions[pc];
    unsigned int op = getBits(instr, 2, 0);
    unsigned int funct3 = getBits(instr, 5, 3);

    #ifdef DEBUG
    print_instruction(instr);
    #endif

    int rd;
    int rs1;
    int rs2;

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
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.sets(getRdRegGp(rd,cc));
            break;
        case 4:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.setb(getRdRegGp(rd,cc));
            break;
        case 5:
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
            cc.mov(tmpReg, getRegGp(rs1,cc));
            cc.idiv(tmpReg, getRegGp(rs2,cc));
            cc.imul(tmpReg, getRegGp(rs2,cc));
            cc.sub(getRdRegGp(rs1,cc), tmpReg);
            cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
            break;
        case 7:
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
            cc.invoke(&fpuInvokeNode, FPU::fadd, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 1:
            cc.invoke(&fpuInvokeNode, FPU::fsub, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 2:
            cc.invoke(&fpuInvokeNode, FPU::fmul, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 3:
            cc.invoke(&fpuInvokeNode, FPU::fdiv, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 4:
            cc.invoke(&fpuInvokeNode, FPU::fsqrt, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 5:
            cc.invoke(&fpuInvokeNode, FPU::fneg, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 6:
            cc.invoke(&fpuInvokeNode, FPU::fmin, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 7:
            cc.invoke(&fpuInvokeNode, FPU::fmax, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
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
            cc.invoke(&fpuInvokeNode, FPU::feq, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 1:
            cc.invoke(&fpuInvokeNode, FPU::flt, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 2:
            cc.invoke(&fpuInvokeNode, FPU::fle, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1,cc));
            fpuInvokeNode->setArg(1, getFregGp(rs2,cc));
            fpuInvokeNode->setRet(0, getRdRegGp(rd,cc));
            break;
        case 3:
            cc.mov(getRdRegGp(rd,cc), getFregGp(rs1,cc));
            break;
        case 4:
            cc.mov(getRdFregGp(rd,cc), getRegGp(rs1,cc));
            break;
        case 5:            
            cc.mov(getRdFregGp(rd,cc), getFregGp(rs1,cc));
            break;
        case 6:
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getRegGp(rs1,cc));
            fpuInvokeNode->setRet(0, getRdFregGp(rd,cc));
            break;
        case 7:
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<long long,long long>());
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
            if(rd == rs1){
                cc.add(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.add(getRdRegGp(rd,cc), imm);
            }
            break;
        case 1:
            if(rd == rs1){
                cc.sal(getRdRegGp(rd,cc), shamt);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.sal(getRdRegGp(rd,cc), shamt);
            }
            break;
        case 2:
            if(judge){
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd,cc), shamt);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.sar(getRdRegGp(rd,cc), shamt);
                }
            }else{
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd,cc), shamt);
                }else{
                    cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                    cc.shr(getRdRegGp(rd,cc), shamt);
                }
            }
            break;
        case 3:
            cc.cmp(getRegGp(rs1,cc), imm);
            cc.sets(getRdRegGp(rd,cc));
            break;
        case 4:
            cc.cmp(getRegGp(rs1,cc), imm);
            cc.setb(getRdRegGp(rd,cc));
            break;
        case 5:
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.xor_(getRdRegGp(rd,cc), imm);
            }
            break;
        case 6:
            if(rd == rs1){
                cc.or_(getRdRegGp(rd,cc), imm);
            }else{
                cc.mov(getRdRegGp(rd,cc), getRegGp(rs1,cc));
                cc.or_(getRdRegGp(rd,cc), imm);
            }
            break;
        case 7:
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

        switch (funct3)
        {
        case 0:
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
            cc.mov(getRdRegGp(rd,cc), ((rs1 << 16) + luioffset) << 12);
            break;
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
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.je(pctolabel(pc+imm));
            break;
        case 1:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jne(pctolabel(pc+imm));
            break;
        case 2:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jl(pctolabel(pc+imm));
            break;
        case 3:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jge(pctolabel(pc+imm));
            break;
        case 4:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jb(pctolabel(pc+imm));
            break;
        case 5:
            cc.cmp(getRegGp(rs1,cc), getRegGp(rs2,cc));
            cc.jae(pctolabel(pc+imm));
            break;
        case 6:
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
            cc.jmp(pctolabel(addr));
            break;
        case 1:
            cc.mov(getRdRegGp(rd,cc), pc+1);
            cc.jmp(pctolabel(imm));
            break;
        case 2:
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
    
    cc.addFunc(FuncSignatureT<int>());
    
    //clockcount setup
    clkptr = cc.newGpq();
    cc.mov(clkptr, clk);

    //tmporary register setup
    qtmpReg = cc.newGpq();
    tmpReg = cc.newGpd();

    //zero register setup
    zero = cc.newGpd();
    cc.mov(zero, 0);

    //jump table setup
    jumpBase = cc.newGpq();
    cc.mov(jumpBase, (uint64_t)pctoaddr);

    setUpLabel(cc);
    setUpRegs(cc);

    LoadAllRegs(cc);

    for(unsigned int i=0; i<instructions.size(); i++){
        compileSingleInstruction(i, cc);
    }
    cc.bind(*endLabel);

    StoreAllRegs(cc);
    
    cc.ret(clkptr);
    cc.endFunc();
    cc.finalize();

    Error err = rt.add(&fn, &code);

    if (err) {
        printf("AsmJit failed: %s\n", DebugUtils::errorAsString(err));
    }
    clk = fn();
    rt.release(fn);
}

void Compiler::getNewInvokeNode(InvokeNode*& ptr){
    ptr = (InvokeNode*)malloc(sizeof(InvokeNode));
    nodes.push_back(ptr);
}

int Compiler::run(){
    if(mode == accurate) return Simulator::run();
    else if(mode == fast){
        compileAll();
        return 0;
    }
    else return -1;
}