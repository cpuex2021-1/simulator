#include "Profiler.hpp"
#include "../lib/util.hpp"
#include <fstream>

Profiler::Profiler()
:profready(false), memrdIdx(0), numEachInstrExecuted(34,0), labelIdx(0)
{
    memrd3[0] = -2;
    memrd3[1] = -2;
    memrd4[0] = -2;
    memrd4[1] = -2;
}

void Profiler::reset(){
    for(size_t i=0; i<instructions.size() / VLIW_SIZE; i++){
        numExecuted[i] = 0;
        numBranchUnTaken[i] = 0;
    }
}

void Profiler::initInstructionTypes(){
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
}

void Profiler::initProfiler(){
    if(profready) return;

    numExecuted = vector<uint64_t> (instructions.size() / VLIW_SIZE, 0);
    numBranchUnTaken = vector<uint64_t> (instructions.size() / VLIW_SIZE, 0);

    initInstructionTypes();
    initIsDataHazard();
    if(hasDebuggingInfo) initLabelStats();

    profready = true;
}

void Profiler::updateProfilerResult(){
    numInstruction = 0;
    num2stall = 0;
    num3stall = 0;
    num4stall = 0;
    numFlush = 0;
    for(size_t i=0; i<instructions.size() / VLIW_SIZE; i++){
        int encoded = 0;
        string str;
        int numStall = 0;
        for(size_t j=i*VLIW_SIZE; j<(i+1)*VLIW_SIZE; j++){
            translateInstructionType(instructionTypes[j].op, instructionTypes[j].funct3, instructionTypes[j].funct11, encoded);
            
            numStall = std::max(checkIfForceStall(instructionTypes[j].op, instructionTypes[j].funct3), numStall);
            
            //assume always untaken
            if((instructionTypes[j].op == 6 && (instructionTypes[j].funct3 <= 5)) || (instructionTypes[j].op == 7 && (instructionTypes[j].funct3 == 1 || instructionTypes[j].funct3 == 3))){
                numFlush += numExecuted[i] - numBranchUnTaken[i];
                numStall = std::max(numStall, 2);
            }

            numEachInstrExecuted[encoded] += numExecuted[i];

        }
        
        numInstruction += numExecuted[i];
        
        if(isDataHazard[i]){
            numDataHazard += numExecuted[i];
            numStall = std::max(numStall, 2);
        } 

        if(numStall == 2){
            num2stall += numExecuted[i];
        }else if(numStall == 3){
            num3stall += numExecuted[i];
        }else if(numStall == 4){
            num4stall += numExecuted[i];
        }

        if(hasDebuggingInfo&&labellist.size()) updateLabelStats(numExecuted[i], i);
    }
}

void Profiler::exportToCsv(){
    fstream out;
    out.open("simulator_result.csv", ios::out);

    out << "Instruction, Times Executed\n";
    for(size_t i=0; i<34; i++){
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

void Profiler::translateInstructionType(char op, char funct3, char funct11, int& encoded){
    
    switch (op)
    {
    case 0:
    {
        switch (funct3)
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
    }
    case 1:
    {
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
            encoded = 2;
            break;
        case 1:
            encoded = 3;
            break;
        case 2:
            encoded = 4;
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
    case 3:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rd:%d rs1:%d rs2:%d\n", op, funct3, rd, rs1, rs2);
        #endif

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

        case 6:
            encoded = 13;
            break;
        case 7:
            encoded = 14;
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
            encoded = 15;
            break;
        case 1:
            encoded = 16;
            break;
        case 2:
            encoded = 17;
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
            encoded = 18;
            break;
        case 2:
            encoded = 19;
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
    case 6:
    {
        #ifdef DEBUG
        printf("op:%d funct3:%d rs1:%d rs2:%d imm:%d\n", op, funct3, rs1, rs2, imm);
        #endif

        switch (funct3)
        {
        case 0:
            encoded = 20;
            break;
        case 1:
            encoded = 21;
            break;
        case 2:
            encoded = 22;
            break;
        case 3:
            encoded = 23;
            break;
        case 5:
            encoded = 24;
            break;
        case 6:
            encoded = 25;
            break;
        case 7:
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
        default:
            
            break;
        }
        break;
    }
    default:
        break;
    }
}


void Profiler::initIsDataHazard(){
    isDataHazard = vector<int8_t>(instructions.size() / VLIW_SIZE, 0);

    for(size_t i=0; i<instructions.size() / VLIW_SIZE; i++){
        for(int8_t j=0; j<VLIW_SIZE; j++){
            auto idx = i * VLIW_SIZE + j;
            isDataHazard[i] |= checkIsDataHazard(instructions[idx], j);
        }
        updateMemrd();
    }
}

int8_t Profiler::checkIsDataHazard(uint32_t instr, int8_t slot){
    
    uint32_t op = getBits(instr, 2, 0);
    uint32_t funct3 = getBits(instr, 5, 3);

    int32_t memrd = -2;
    int32_t rs1 = -1;
    int32_t rs2 = -1;  

    switch (op)
    {
    case 0:
    {
        if(funct3 >= 0 && funct3 <= 1){
            rs1 = getBits(instr, 31, 26);
            rs2 = getBits(instr, 11, 6);
        }
        break;
    }
    case 1:
    {
        break;
    }
    case 2:
    {
        if(funct3 >= 0 && funct3 <= 3)
        {
            rs1 = getBits(instr, 31, 26);
            rs2 = getBits(instr, 11, 6);
        }else if(funct3 >= 4 && funct3 <= 7){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    case 3:
    {
        if(funct3 >= 0 && funct3 <= 2)
        {
            rs1 = getBits(instr, 31, 26);
            rs2 = getBits(instr, 11, 6);
        }else if(funct3 >= 6 && funct3 <= 7){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    case 4:
    {
        if(funct3 >= 0 && funct3 <= 2){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    case 5:
    {
        if(funct3 == 0){
            rs1 = getBits(instr, 31, 26);
            memrd = getBits(instr, 25, 20);
        }else if(funct3 == 2){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    case 6:
    {
        if(funct3 >= 0 && funct3 <= 3){
            rs1 = getBits(instr, 31, 26);
            rs2 = getBits(instr, 11, 6);
        }else if(funct3 >= 5 && funct3 <=6){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    case 7:
    {
        if(funct3 == 1 && funct3 == 3){
            rs1 = getBits(instr, 31, 26);
        }
        break;
    }
    default:
        break;
    }

    int8_t ret = 0;

    if(getMemrd3() == rs1 || getMemrd3() == rs2 || getMemrd4() == rs1 || getMemrd4() == rs2){
        ret = 1;
    }
    
    if(slot == 2){
        storeNewMemrd3(memrd);
    }else if(slot == 3){
        storeNewMemrd4(memrd);
    }

    return ret;
}

vector<string> Profiler::stringOfEachInstr = {
"ADD",
"SUB",
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
"ITOF",
"FTOI",
"ADDI",
"SLLI",
"SRAI",
"LW",
"LUI",
"BEQ",
"BNE",
"BLT",
"BGE",
"BNEI",
"SW",
"JUMP",
"JUMPR",
"CALL",
"CALLR",
"RET",
"(FSIN)",
"(FCOS)",
"(ATAN)"};
