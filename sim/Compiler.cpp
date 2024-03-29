#include "Compiler.hpp"
#include "../lib/util.hpp"

#define SLIDE 10

#ifdef STDFPU
#define FPU StdFPU
#else
#define FPU OrenoFPU
#endif

Compiler::Compiler()
: compiled(false), rt(), code(), cc(initCode(&code)), regAllocList(REGNUM), memDestRd(-2), labellistIdx(0)
{
}

Compiler::~Compiler(){
    for(size_t i=0; i<nodes.size(); i++){
        free(nodes[i]);
    }
    rt.release(fn);
}

x86::Gp Compiler::getRegGp(int i){
    return getGp(i, false);
}

x86::Gp Compiler::getRdRegGp(int i){
    return getGp(i, true);
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
    callann = cc.newJumpAnnotation();
    retann = cc.newJumpAnnotation();
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
    for(size_t i=0; i<regAllocList.size(); i++){
        if(regAllocList[i].valid){
            cc.mov(regAllocList[i].gp, x86::dword_ptr((uint64_t)&reg[i]));
        }        
    }    
}

void Compiler::StoreAllRegs(){
    for(size_t i=0; i<regAllocList.size(); i++){
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
        rd = getBits(instr, 25, 20);
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);

        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d funct11:%d\n", op, funct3, rd, rs1, rs2, funct11);
        #endif

        switch (funct3)
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

        InvokeNode* fpuInvokeNode; getNewInvokeNode(fpuInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fadd, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fsub, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fmul, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fdiv, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 4:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::fsqrt, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 5:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::fneg, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fabs, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::floor, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        default:
            throw_err(instr); return;
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
        
        InvokeNode* fpuInvokeNode; getNewInvokeNode(fpuInvokeNode);

        switch (funct3)
        {
        case 0:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::feq, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::flt, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.invoke(&fpuInvokeNode, FPU::fle, FuncSignatureT<int,int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setArg(1, getRegGp(rs2));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;

        case 6:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::itof, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::ftoi, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
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
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        int imm = getSextBits(instr, 19, 6);
        int shamt = getSextBits(instr, 11, 6);

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
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rd == rs1){
                cc.sar(getRdRegGp(rd), shamt);
            }else{
                cc.mov(getRdRegGp(rd), getRegGp(rs1));
                cc.sar(getRdRegGp(rd), shamt);
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
        rs1 = getBits(instr, 31, 26);
        rd = getBits(instr, 25, 20);
        int offset = getSextBits(instr, 19, 6);
        unsigned int luioffset = getBits(instr, 19, 6);

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
            //tbd
            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.mov(getRdRegGp(rd), ((rs1 << 14) + luioffset) << 12);
            break;

        #ifdef STDFPU
        case 5:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::fsin, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 6:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::fcos, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
            break;
        case 7:
            preProcs(false, pc, memdestRd, rs1, -1);
            cc.invoke(&fpuInvokeNode, FPU::atan, FuncSignatureT<int,int>());
            fpuInvokeNode->setArg(0, getRegGp(rs1));
            fpuInvokeNode->setRet(0, getRdRegGp(rd));
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
        rs1 = getBits(instr, 31, 26);
        rs2 = getBits(instr, 11, 6);
        uint32_t imm = getBits(instr, 25, 12);
        int32_t memimm = getSextBits(instr, 25, 12);
        int rs2imm = getSextBits(instr, 11, 6);
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
            cc.je(pctolabel(imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 1:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jne(pctolabel(imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);

            break;
        case 2:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jl(pctolabel(imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
        case 3:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), getRegGp(rs2));
            cc.jge(pctolabel(imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;
            
        case 5:
            preProcs(false, pc, memdestRd, rs1, rs2);
            cc.cmp(getRegGp(rs1), rs2imm);
            cc.jne(pctolabel(imm));
            
            //postproc for branch
            cc.mov(qtmpReg, x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])));
            cc.inc(qtmpReg);
            cc.mov(x86::qword_ptr((uint64_t)&(numBranchUnTaken[pc])), qtmpReg);
            
            break;

        case 6:
            preProcs(false, pc, memdestRd, rs1, rs2);
            if(rs1 == 0 && memimm == 0){
                cc.invoke(&uartInvokeNode, UART::push, FuncSignatureT<void, int>());
                uartInvokeNode->setArg(0, getRegGp(rs2));
            }else{
                cc.mov(tmpReg, getRegGp(rs1));
                cc.add(tmpReg, memimm);
                cc.invoke(&cacheInvokeNode, Memory::writeJit, FuncSignatureT<void, int, int>());
                cacheInvokeNode->setArg(0, tmpReg);
                cacheInvokeNode->setArg(1, getRegGp(rs2));
            }
            break;
        case 7:
            //tbd            
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
        rs1 = getBits(instr, 31, 26);

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
            preProcs(true, pc, memdestRd, rs1, -1);
            cc.mov(qtmpReg, x86::qword_ptr(jumpBase, getRegGp(rs1), 3));
            cc.jmp(qtmpReg, callann);
            break;
        case 2:
            preProcs(true, pc, memdestRd, -1, -1);
            cc.mov(x86::dword_ptr(rastackBase, rastackIdxReg, 2, 0), pc+1);
            cc.inc(rastackIdxReg);
            cc.jmp(pctolabel(addr));
            break;
        case 3:
            preProcs(true, pc, memdestRd, rs1, -1);
            cc.mov(x86::dword_ptr(rastackBase, rastackIdxReg, 2, 0), pc+1);
            cc.inc(rastackIdxReg);
            cc.mov(qtmpReg, x86::qword_ptr(jumpBase, getRegGp(rs1), 3));
            cc.jmp(qtmpReg);
            break;
        case 4:
            preProcs(true, pc, memdestRd, -1, -1);
            cc.dec(rastackIdxReg);
            cc.mov(tmpReg, x86::dword_ptr(rastackBase, rastackIdxReg, 2, 0));
            cc.mov(qtmpReg, x86::qword_ptr(jumpBase, tmpReg, 3));
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

    /*
    //Logging
    FileLogger logger(stderr);
    code.setLogger(&logger);
    */

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

    //rastack setup;
    rastackIdxReg = cc.newGpd();
    cc.mov(rastackIdxReg, x86::dword_ptr((uint64_t)&rastackIdx));
    rastackBase = cc.newGpq();
    cc.mov(rastackBase, ((uint64_t)rastack));

    for(size_t i=0; i<instructions.size(); i++){
        compileSingleInstruction(i);
    }

    cc.jmp(endLabel);
    
    //Load register
    cc.bind(LoadLabel);
    LoadAllRegs();
    cc.jmp(RunLabel);
    
    //end
    cc.bind(endLabel);

    //Store register
    StoreAllRegs();

    cc.mov(x86::qword_ptr((uint64_t)&numDataHazard), numDataHazardptr);
    
    cc.ret();
    cc.endFunc();
    cc.finalize();

    Error err = rt.add(&fn, &code);

    if (err) {
        fprintf(stderr, "\nAsmJit failed: %s\n", DebugUtils::errorAsString(err));
        exit(1);
    }

    compiled = true;
    
    cerr << " complete!" << endl;
}

void Compiler::getNewInvokeNode(InvokeNode*& ptr){
    ptr = (InvokeNode*)malloc(sizeof(InvokeNode));
    nodes.push_back(ptr);
}

int Compiler::run(){
    initProfiler();
    if(mode == accurate) return Simulator::run();
    else if(mode == fast){
        if(!compiled){
            compileAll();
        }
        cerr << "Running..." << flush;
        fn();
        cerr << " complete!" << endl;
        updateProfilerResult();
        update_clkcount();
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
            callann->addLabel(pctolabel(pc));
            while(labellist[labellistIdx].pc == (uint32_t)pc){
                labellistIdx++;
            }
        }
        if(usera) retann->addLabel(pctolabel(pc+1));
    }else{
        callann->addLabel(pctolabel(pc));
        retann->addLabel(pctolabel(pc));
    }
    
    /*
    InvokeNode* printinvnode;

    cc.mov(tmpReg, pc);
    cc.invoke(&printinvnode, JitBreakPoint, FuncSignatureT<void, int>());
    printinvnode->setArg(0, tmpReg);
    */
   
    //incriment counter
    cc.mov(qtmpReg, x86::qword_ptr((uint64_t) &(numExecuted[pc])));
    cc.inc(qtmpReg);
    cc.mov(x86::qword_ptr((uint64_t) &(numExecuted[pc])), qtmpReg);
}

void Compiler::reset(){
    Simulator::reset();
    regAllocList = vector<regAlloc> (REGNUM);
}

#undef FPU