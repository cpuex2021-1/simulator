#ifndef COMPILER_H_INCLUDED
#define COMPILER_H_INCLUDED

#include "Profiler.hpp"
#include "../include/asmjit/src/asmjit/x86.h"

using namespace std;
using namespace asmjit;

typedef void (*Func)(void);

class Compiler : public Profiler
{
private:
    JitRuntime rt;
    
    CodeHolder code;

    x86::Compiler cc;

    Func fn;

    class regAlloc{
    public:
        bool valid;
        x86::Gp gp;
        regAlloc()
        :valid(false)
        {
        }
    };

    vector<regAlloc> regAllocList;

    x86::Gp getRegGp(int i);
    x86::Gp getFregGp(int i);
    x86::Gp getGp(int i, bool isrd);
    x86::Gp getRdRegGp(int i);
    x86::Gp getRdFregGp(int i);

    x86::Gp tmpReg;
    x86::Gp zero;

    map<int, Label> pctolabel;

    void compileSingleInstruction(int pc);
    void bindLabel(int pc);
    void setUpLabel();

public:
    Compiler();
    void compileAll();

    void runFunc();
};

#endif