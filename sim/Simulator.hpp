#include "Memory.hpp"
#include "FPU.hpp"
#define REGNUM 32
#define FREGNUM 32

class Simulator
{
public:
    Memory* mem;
    int* reg;
    int* freg;
    int pc;
    Simulator(unsigned int memsize, unsigned int cachesize, int pc);
    ~Simulator();
    void simulate(unsigned int instr);
};
