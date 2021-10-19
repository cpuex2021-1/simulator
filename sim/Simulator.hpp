#include "Memory.hpp"
#include "FPU.hpp"
#define REGNUM 32
#define FREGNUM 32

class Simulator
{
private:
    int* reg;
    int* freg;
public:
    int pc;
    int clk;
    Memory* mem;
    Simulator(unsigned int memsize, unsigned int cachesize, int pc);
    ~Simulator();
    void simulate(unsigned int instr);
    void print_register();
};
