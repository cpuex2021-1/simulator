#ifndef COMPILER_H_INCLUDED
#define COMPILER_H_INCLUDED
#include "Simulator.hpp"
#include <asmjit/asmjit.h>
#include <string>

using namespace std;
using namespace asmjit;

typedef int (*Func)(void);

class Compiler : public Simulator
{
private:
    CodeHolder* initCode(CodeHolder* cd){
        cd->init(rt.environment());
        return cd;
    }
    bool compiled;
    
protected:
    class regAlloc{
    public:
        bool valid;
        x86::Gp gp;
        regAlloc()
        :valid(false)
        {
        }
    };

    //compiler
    JitRuntime rt;
    CodeHolder code;
    x86::Compiler cc;

    //simulator register <-> vReg
    vector<regAlloc> regAllocList;

    x86::Gp tmpregs[VLIW_SIZE];

    int8_t slot;

    x86::Gp getRegGp(int i);
    x86::Gp getGp(int i, bool isrd);
    x86::Gp getRdRegGp(int i);

    x86::Gp tmpReg;
    x86::Gp qtmpReg;
    x86::Gp zero;
    x86::Gp jumpBase;
    x86::Gp rastackBase;
    x86::Gp rastackIdxReg;

    x86::Gp tmpReg1;
    x86::Gp tmpReg2;

    //stats
    x86::Gp numDataHazardptr;

    Label** pctolabelptr;

    inline static uint64_t* pctoaddr;

    Label pctolabel(int pc){
        return *(pctolabelptr[pc]);
    }

    Label endLabel;
    
    void compileSingleInstruction(int pc);
    void bindLabel(int pc);

    void LoadAllRegs();

    void StoreAllRegs();

    void setUpLabel();

    void preProcs(int pc);
    void updateReg();
    
    JumpAnnotation* callann;
    JumpAnnotation* retann;

    Label RunLabel, LoadLabel;

    static void JitBreakPoint(int, int);

    inline static vector<InvokeNode*> nodes;
    void getNewInvokeNode(InvokeNode*& ptr);

    int labellistIdx;

    Func fn;

public:
    Compiler();
    ~Compiler();
    void compileAll();
    int run();
    void reset();
};

#endif
