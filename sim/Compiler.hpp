#ifndef COMPILER_H_INCLUDED
#define COMPILER_H_INCLUDED
#include "Profiler.hpp"
#include <asmjit/asmjit.h>

using namespace std;
using namespace asmjit;

typedef int (*Func)(void);

class Compiler : public Profiler
{
private:

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

    x86::Gp getRegGp(int i, x86::Compiler&);
    x86::Gp getFregGp(int i, x86::Compiler&);
    x86::Gp getGp(int i, bool isrd, x86::Compiler&);
    x86::Gp getRdRegGp(int i, x86::Compiler&);
    x86::Gp getRdFregGp(int i, x86::Compiler&);

    x86::Gp tmpReg;
    x86::Gp zero;

    x86::Gp clkptr;

    map<int, Label*> pctolabelptr;

    Label pctolabel(int pc){
        return *(pctolabelptr[pc]);
    }

    void compileSingleInstruction(int pc, x86::Compiler&);
    void bindLabel(int pc, x86::Compiler&);
    void setUpLabel(x86::Compiler&);

    inline static vector<InvokeNode*> nodes;
    void getNewInvokeNode(InvokeNode*& ptr);

public:
    Func fn;
    Compiler();
    ~Compiler();
    void compileAll();

    void runFunc();
};

#endif