#include "Compiler.hpp"

Compiler::Compiler()
: cc(&code), regAllocList(REGNUM+FREGNUM)
{
    cc.addFunc(FuncSignatureT<void>());
    tmpReg = cc.newGpd();
}

x86::Gp Compiler::getRegGp(int i){
    return getGp(i, false);
}

x86::Gp Compiler::getFregGp(int i){
    return getGp(i + 16, false);
}

x86::Gp Compiler::getRdRegGp(int i){
    return getGp(i, true);
}

x86::Gp Compiler::getRdFregGp(int i){
    return getGp(i + 16, true);
}

x86::Gp Compiler::getGp(int i, bool isrd){
    if(i != 0 && i != 16)
    {
        if(regAllocList[i].valid){
            return regAllocList[i].gp;
        }else{
            auto& item = regAllocList[i];
            item.valid = true;
            item.gp = cc.newInt64();
            cc.mov(item.gp, x86::dword_ptr((uint64_t)&reg[i]));
        }
    }else{
        if(isrd) return tmpReg;
        else return zero;
    }
}

void Compiler::bindLabel(int pc){
    cc.bind(pctolabel[pc]);
}

void Compiler::setUpLabel(){
    for(int i=0; i<label_list.size(); i++){
        if(label_list[pc] == 1){
            pctolabel[pc] = cc.newLabel();
        }
    }
}

void Compiler::compileSingleInstruction(int pc){
    if(label_list[pc] == 1){
        bindLabel(pc);
    }

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
                    cc.add(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.add(getRdRegGp(rd), getRegGp(rs1));
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.add(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            case 1:
                if(rd == rs1){
                    cc.sub(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.sub(getRdRegGp(rd), getRegGp(rs1));
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
            if(rd == rs1){
                cc.sal(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.sal(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.sal(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 2:
            switch (funct11)
            {
            case 0:
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.shr(getRdRegGp(rd), getRegGp(rs1));
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.shr(getRdRegGp(rd), getRegGp(rs2));
                }
                break;
            case 1:
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd), getRegGp(rs2));
                }else if(rd == rs2){
                    cc.sar(getRdRegGp(rd), getRegGp(rs1));
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
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.sets(getRdRegGp(rd));
            break;
        case 4:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.setb(getRdRegGp(rd));
            break;
        case 5:
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
            if(rd == rs1){
                cc.idiv(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.idiv(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.idiv(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 5:
            if(rd == rs1){
                cc.div(getRdRegGp(rd), getRegGp(rs2));
            }else if(rd == rs2){
                cc.div(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.div(getRdRegGp(rd), getRegGp(rs2));
            }
            break;
        case 6:
            cc.mov(tmpReg, getRegGp(rs1));
            cc.idiv(tmpReg, getRegGp(rs2));
            cc.imul(tmpReg, getRegGp(rs2));
            cc.sub(getRdRegGp(rs1), tmpReg);
            cc.mov(getRdRegGp(rd), getRegGp(rs1));
            break;
        case 7:
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

        InvokeNode* fpuInvokeNode;

        switch (funct3)
        {
        case 0:
            cc.invoke(&fpuInvokeNode, FPU::fadd, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 1:
            cc.invoke(&fpuInvokeNode, FPU::fsub, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 2:
            cc.invoke(&fpuInvokeNode, FPU::fmul, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 3:
            cc.invoke(&fpuInvokeNode, FPU::fdiv, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 4:
            cc.invoke(&fpuInvokeNode, FPU::fsqrt, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 5:
            cc.invoke(&fpuInvokeNode, FPU::fneg, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 6:
            cc.invoke(&fpuInvokeNode, FPU::fmin, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 7:
            cc.invoke(&fpuInvokeNode, FPU::fmax, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
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
        
        InvokeNode* fpuInvokeNode;

        switch (funct3)
        {
        case 0:
            cc.invoke(&fpuInvokeNode, FPU::feq, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
        case 1:
            cc.invoke(&fpuInvokeNode, FPU::flt, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
        case 2:
            cc.invoke(&fpuInvokeNode, FPU::fle, FuncSignatureT<long long,long long,long long>());
            fpuInvokeNode->setArg(0, getFregGp(rs1));
            fpuInvokeNode->setArg(1, getFregGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
        case 3:
            cc.mov(getRdRegGp(rd), getFregGp(rs1));
            break;
        case 4:
            cc.mov(getRdFregGp(rd), getRegGp(rs1));
            break;
        case 5:            
            cc.mov(getRdFregGp(rd), getFregGp(rs1));
            break;
        case 6:
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<long long,long long>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdFregGp(rd));
            break;
        case 7:
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<long long,long long>());
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
            if(rd == rs1){
                cc.add(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.add(getRdRegGp(rd), imm);
            }
            break;
        case 1:
            if(rd == rs1){
                cc.sal(getRdRegGp(rd), imm);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.sal(getRdRegGp(rd), imm);
            }
            break;
        case 2:
            if(judge){
                if(rd == rs1){
                    cc.sar(getRdRegGp(rd), imm);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.sar(getRdRegGp(rd), imm);
                }
                break;
            }else{
                if(rd == rs1){
                    cc.shr(getRdRegGp(rd), imm);
                }else{
                    cc.mov(getRdRegGp(rd), getRegGp(rs1));
                    cc.shr(getRdRegGp(rd), imm);
                }
                break;
            }
        case 3:
            cc.cmp(getRegGp(rs1), imm);
            cc.sets(getRdRegGp(rd));
            break;
        case 4:
            cc.cmp(getRegGp(rs1), imm);
            cc.setb(getRdRegGp(rd));
            break;
        case 5:
            if(rd == rs1){
                cc.xor_(getRdRegGp(rd), imm);
            }else if(rd == rs2){
                cc.xor_(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.xor_(getRdRegGp(rd), imm);
            }
            break;
        case 6:
            if(rd == rs1){
                cc.or_(getRdRegGp(rd), imm);
            }else if(rd == rs2){
                cc.or_(getRdRegGp(rd), getRegGp(rs1));
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.or_(getRdRegGp(rd), imm);
            }
            break;
        case 7:
            if(rd == rs1){
                cc.and_(getRdRegGp(rd), imm);
            }else if(rd == rs2){
                cc.and_(getRdRegGp(rd), getRegGp(rs1));
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

        InvokeNode* cacheInvokeNode;
        InvokeNode* uartInvokeNode;

        switch (funct3)
        {
        case 0:
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<void,int>());
                uartInvokeNode->setRet(0, getRdRegGp(rd));
            }else{
                uint64_t memaddr = mem->getMemAddr(offset);
                cc.mov(tmpReg, getRegGp(rs1));
                cc.imul(tmpReg, mem->getContentSize());
                cc.add(tmpReg, memaddr);
                cc.mov(getRdRegGp(rd), dword_ptr(tmpReg));

                cc.invoke(&cacheInvokeNode, Memory::update_cache_wrap, FuncSignatureT<int, void>());
                cacheInvokeNode->setArg(0, tmpReg);
            }                        
            break;
        case 1:
            if(rs1 == 0 && offset == 0){
                cc.invoke(&uartInvokeNode, UART::pop, FuncSignatureT<void,int>());
                uartInvokeNode->setRet(0, getRdFregGp(rd));
            }else{
                uint64_t memaddr = mem->getMemAddr(offset);
                cc.mov(tmpReg, getRegGp(rs1));
                cc.imul(tmpReg, mem->getContentSize());
                cc.mov(getRdFregGp(rd), dword_ptr(tmpReg, memaddr));
                
                cc.invoke(&cacheInvokeNode, Memory::update_cache_wrap, FuncSignatureT<int, void>());
                cacheInvokeNode->setArg(0, tmpReg);
            }                        
            break;
        case 2:
            cc.mov(getRdRegGp(rd), ((rs1 << 16) + luioffset) << 12);
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

        InvokeNode* cacheInvokeNode;
        InvokeNode* uartInvokeNode;

        switch (funct3)
        {
        case 0:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.je(pctolabel[pc+imm]);
            break;
        case 1:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jne(pctolabel[pc+imm]);
            break;
        case 2:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jl(pctolabel[pc+imm]);
            break;
        case 3:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jge(pctolabel[pc+imm]);
            break;
        case 4:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jb(pctolabel[pc+imm]);
            break;
        case 5:
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jae(pctolabel[pc+imm]);
            break;
        case 6:
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<int,void>());
                uartInvokeNode->setArg(0, getRegGp(rs2));
            }else{
                uint64_t memaddr = mem->getMemAddr(imm);
                cc.mov(tmpReg, getRegGp(rs1));
                cc.imul(tmpReg, mem->getContentSize());
                cc.add(tmpReg, memaddr);
                cc.mov(dword_ptr(tmpReg), getRegGp(rs2));

                cc.invoke(&cacheInvokeNode, Memory::update_cache_wrap, FuncSignatureT<int, void>());
                cacheInvokeNode->setArg(0, tmpReg);
            }                        
            break;

        case 7:
            if(rs1 == 0 && imm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<int,void>());
                uartInvokeNode->setArg(0, getFregGp(rs2));
            }else{
                uint64_t memaddr = mem->getMemAddr(imm);
                cc.mov(tmpReg, getRegGp(rs1));
                cc.imul(tmpReg, mem->getContentSize());
                cc.add(tmpReg, memaddr);
                cc.mov(dword_ptr(tmpReg), getFregGp(rs2));

                cc.invoke(&cacheInvokeNode, Memory::update_cache_wrap, FuncSignatureT<int, void>());
                cacheInvokeNode->setArg(0, tmpReg);
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
            cc.jmp(pctolabel[pc+addr]);
            break;
        case 1:
            cc.mov(getRdRegGp(rd), pc+1);
            cc.call(pctolabel[pc+imm]);
            break;
        case 2:
            cc.ret();
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

    clk++;
    return;
}

void Compiler::compileAll(){
    initProfiler();
    setUpLabel();
    for(unsigned int i=0; i<instructions.size(); i++){
        compileSingleInstruction(i);
    }

    for(unsigned int i=0; i<regAllocList.size(); i++){
        if(regAllocList[i].valid){
            cc.mov(x86::dword_ptr((uint64_t)&reg[i]), regAllocList[i].gp);
        }
    }
    cc.ret();
    cc.endFunc();
    cc.finalize();

    Error err = rt.add(&fn, &code);
    if (err) {
        printf("AsmJit failed: %s\n", DebugUtils::errorAsString(err));
    }
}

void Compiler::runFunc(){
    fn();
}