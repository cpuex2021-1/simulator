#include "Profiler.hpp"
#include "../lib/util.hpp"
#include <fstream>

Profiler::Profiler()
:profready(false), numEachInstrExecuted(60,0), labelIdx(0)
{}

void Profiler::reset(){
    for(size_t i=0; i<instructions.size(); i++){
        numExecuted[i] = 0;
        numBranchUnTaken[i] = 0;
        numCacheMiss[i] = 0;
    }
}

void Profiler::initProfiler(){
    if(profready) return;

    numExecuted = vector<uint64_t> (instructions.size(), 0);
    numBranchUnTaken = vector<uint64_t> (instructions.size(), 0);
    numCacheMiss = vector<uint64_t> (instructions.size(), 0);
    instructionTypes = vector<InstInfo> (instructions.size());

    for(size_t i=0; i<instructions.size(); i++){
        uint32_t instr = instructions[i];
        char op = getBits(instr, 2, 0);
        char funct3 = getBits(instr, 5, 3);
        instructionTypes[i].op = op;
        instructionTypes[i].funct3 = funct3;
        if(op == 0 && (funct3 == 0 || funct3 == 2)){
            instructionTypes[i].funct11 = getBits(instr, 21, 11);
        }
        if(op == 4 && funct3 == 2){
            instructionTypes[i].funct11 = getBits(instr, 11, 11);
        }
    }

    if(hasDebuggingInfo) initLabelStats();

    profready = true;
}

void Profiler::updateProfilerResult(){
    numInstruction = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    for(size_t i=0; i<instructions.size(); i++){
        int encoded = 0;
        string str;
        translateInstructionType(instructionTypes[i].op, instructionTypes[i].funct3, instructionTypes[i].funct11, encoded, str);
        
        numInstruction += numExecuted[i];
        int numStall = checkIfForceStall(instructionTypes[i].op, instructionTypes[i].funct3);
        if(numStall == 2){
            num2stall += numExecuted[i];
        }else if(numStall == 3){
            num3stall += numExecuted[i];
        }else if(numStall == 4){
            num4stall += numExecuted[i];
        }
        //assume always untaken
        if((instructionTypes[i].op == 6 && (instructionTypes[i].funct3 <= 5)) || instructionTypes[i].op == 7){
            numFlush += numExecuted[i] - numBranchUnTaken[i];
        }

        numEachInstrExecuted[encoded] += numExecuted[i];

        if(hasDebuggingInfo&&labellist.size()) updateLabelStats(numExecuted[i], i);
    }
}

void Profiler::exportToCsv(){
    fstream out;
    out.open("simulator_result.csv", ios::out);

    out << "Instruction, Times Executed\n";
    for(int i=0; i<60; i++){
        out << stringOfEachInstr[i] << ", " << numEachInstrExecuted[i] << "\n";
    }

    out << ",\nAddress, Instruction, Times Executed, Branch Taken Times, Branch Untaken Times\n";
    for(size_t i=0; i<str_instr.size(); i++){
        out << i << ", \"" << str_instr[i] << "\", ";
        auto p = line_to_pc(i);
        if(pc_to_line(line_to_pc(i)) == (int)i){
            out << numExecuted[p] << ", ";
            if((instructionTypes[p].op == 6 && (instructionTypes[p].funct3 >= 0 && instructionTypes[p].funct3 <= 5)) || instructionTypes[i].op == 7){
                out << (numExecuted[p] - numBranchUnTaken[p]) << ", " << numBranchUnTaken[p] << "\n";
            }else{
                out << "N/A, N/A\n";
            }
        }else{
            out << ", ,\n";
        }
    }

    if(hasDebuggingInfo){
        out << ",\nLabel, Times Executed (max), Times Executed (min)\n";
        for(size_t i=0; i<labelStats.size(); i++){
            out << labellist[i].label << ", " << labelStats[i].max << ", " << labelStats[i].min << "\n";
        }
    }

    out << flush;
    out.close();
    cerr << "Detailed statics written in simulator_result.csv." << endl;
}

int Profiler::checkIfForceStall(char op, char funct3){
    switch (op)
    {
    case 2:
        {
            switch (funct3)
            {
            case 0:
                return 3;
                break;
            case 1:
                return 3;
                break;
            case 2:
                return 3;
                break;
            case 3:
                return 4;
                break;
            case 4:
                return 3;
                break;
            case 6:
                return 2;
                break;
            case 7:
                return 2;
                break;
            
            default:
                return 1;
                break;
            }
        }
        break;
    
    case 3:
        {
            switch (funct3)
            {
            case 1:
                return 2;
                break;
            case 2:
                return 2;
                break;
            case 6:
                return 2;
                break;
            case 7:
                return 2;
                break;
            
            default:
                return 1;
                break;
            }
        }
        break;
    default:
        return 1;
        break;
    }
    return 1;
}

void Profiler::initLabelStats(){
    if(hasDebuggingInfo) labelStats = vector<lstats>(labellist.size());
}

void Profiler::updateLabelStats(uint64_t numexec, uint64_t addr){
    if(labellist.size() == 0) return;
    if(labellist[labelIdx].pc == addr){
        while(labellist[labelIdx].pc <= addr){
            labelIdx++;
        }
        if((uint64_t)labelIdx < labelStats.size()){
            labelStats[labelIdx].max = numexec;
            labelStats[labelIdx].min = numexec;
            return;
        }
        return;
    }
    if((uint64_t)labelIdx < labelStats.size()){
        if (labelStats[labelIdx].max < numexec) labelStats[labelIdx].max = numexec;
        if (labelStats[labelIdx].min > numexec) labelStats[labelIdx].min = numexec;
    }
    return;
}

void Profiler::translateInstructionType(char op, char funct3, char funct11, int& encoded, string& str){
    
    switch (op)
    {
    case 0:
    {
        switch (funct3)
        {
        case 0:
            switch (funct11)
            {
            case 0:
                encoded = 0;
                break;
            case 1:
                encoded = 1;
                break;            
            default:
                break;
            }
            break;
        case 1:
            encoded = 2;
            break;
        case 2:
            switch (funct11)
            {
            case 0:
                encoded = 3;
                break;
            case 1:
                encoded = 4;
                break;
            default:
                break;
            }
            break;
        case 3:
            encoded = 5;
            break;
        case 4:
            encoded = 6;
            break;
        case 5:
            encoded = 7;
            break;
        case 6:
            encoded = 8;
            break;
        case 7:
            encoded = 9;
            break;
        default:
            break;
        }
        break;
    }
    case 1:
    {
        switch (funct3)
        {
        case 0:
            encoded = 10;
            break;
        case 1:
            encoded = 11;
            break;
        case 2:
            encoded = 12;
            break;
        case 3:
            encoded = 13;
            break;
        case 4:
            encoded = 14;
            break;
        case 5:
            encoded = 15;
            break;
        case 6:
            encoded = 16;
            break;
        case 7:
            encoded = 17;
            break;
        default:
            break;
        }
        break;
    }
    case 2:
    {   
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 18;
            break;
        case 1:
            encoded = 19;
            break;
        case 2:
            encoded = 20;
            break;
        case 3:
            encoded = 21;
            break;
        case 4:
            encoded = 22;
            break;
        case 5:
            encoded = 23;
            break;
        case 6:
            encoded = 24;
            break;
        case 7:
            encoded = 25;
            break;
        default:
            break;
        }
        break;
    }
    case 3:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 26;
            break;
        case 1:
            encoded = 27;
            break;
        case 2:
            encoded = 28;
            break;
        case 3:
            encoded = 29;
            break;            
        case 4:
            encoded = 30;
            break;
        case 5:
            encoded = 31;
            break;
        case 6:
            encoded = 32;
            break;
        case 7:
            encoded = 33;
            break;
        
        default:
            break;
        }
        break;
    }
    case 4:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, imm);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 34;
            break;
        case 1:
            encoded = 35;
            break;
        case 2:
            if(funct11){
                encoded = 36;
                break;
            }else{
                encoded = 37;
                break;
            }
        case 3:
            encoded = 38;
            break;
        case 4:
            encoded = 39;
            break;
        case 5:
            encoded = 40;
            break;
        case 6:
            encoded = 41;
            break;
        case 7:
            encoded = 42;
            break;
        default:
            break;
        }
        break;
    }
    case 5:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d imm:%d\n", op, funct3, rd, rs1, offset);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 43;
            break;
        case 1:
            encoded = 44;
            break;
        case 2:
            encoded = 45;
            break;

        case 5:
            encoded = 57;
            break;
        case 6:
            encoded = 58;
            break;
        case 7:
            encoded = 59;
            break;
        default:
            break;
        }
        break;
    }
    case 6:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 46;
            break;
        case 1:
            encoded = 47;
            break;
        case 2:
            encoded = 48;
            break;
        case 3:
            encoded = 49;
            break;
        case 4:
            encoded = 50;
            break;
        case 5:
            encoded = 51;
            break;
        case 6:
            encoded = 52;
            break;
        case 7:
            encoded = 53;
            break;
        default:
            
            break;
        }
        break;
    }
    case 7:
    {
        switch (funct3)
        {
        case 0:
            encoded = 54;
            break;
        case 1:
            encoded = 55;
            break;
        case 2:
            encoded = 56;
            break;
        default:
            
            break;
        }
        break;
    }
    default:
        break;
    }
}

vector<string> Profiler::stringOfEachInstr = {
"ADD",
"SUB",
"SLL",
"SRL",
"SRA",
"SLT",
"SLTU",
"XOR",
"OR",
"AND",
"MUL",
"MULH",
"MULHSU",
"MULHU",
"DIV",
"DIVU",
"REM",
"REMU",
"FADD",
"FSUB",
"FMUL",
"FDIV",
"FSQRT",
"FNEG",
"FABS",
"FLOOR",
"FEQ",
"FLT",
"FLE",
"FMV.X.W",
"FMV.W.X",
"FMV",
"ITOF",
"FTOI",
"ADDI",
"SLLI",
"SRLI",
"SRAI",
"SLTI",
"SLTUI",
"XORI",
"ORI",
"ANDI",
"LW",
"FLW",
"LUI",
"BEQ",
"BNE",
"BLT",
"BGE",
"BLTU",
"BGEU",
"SW",
"FSW",
"JUMP",
"JAL",
"JALR",
"(FSIN)",
"(FCOS)",
"(ATAN)"};