#ifndef PROFILER_H_INCLUDED
#define PROFILER_H_INCLUDED
#include "../asm/Reader.hpp"
#include <iostream>
#include <string>

class Profiler : public Reader
{
private:
    bool profready;
protected:
    vector<uint64_t> numExecuted;
    vector<uint64_t> numBranchUnTaken;
    vector<uint64_t> numCacheMiss;
    static vector<string> stringOfEachInstr;
    vector<uint64_t> numEachInstrExecuted;
    class InstInfo
    {
    public:
        char op;
        char funct3;
        char funct11;
        InstInfo()
        :op(0), funct3(0), funct11(0)
        {}
    };
    vector<InstInfo> instructionTypes;

    int checkIfForceStall(char op, char funct3);
    void translateInstructionType(char op, char funct3, char funct11, int& encoded);


    class lstats
    {
    public:
        uint64_t max;
        uint64_t min;
    };
    vector<lstats> labelStats;
    int labelIdx;
    void initLabelStats();
    void updateLabelStats(uint64_t numexec, uint64_t addr);


public:
    Profiler();
    void initProfiler();
    void updateProfilerResult();

    void exportToCsv();
    void reset();

    //statistics
    inline static uint64_t clk;
    inline static uint64_t numInstruction;
    inline static uint64_t num2stall;
    inline static uint64_t num3stall;
    inline static uint64_t num4stall;
    inline static uint64_t numFlush;
    inline static uint64_t numDataHazard;

};

#endif