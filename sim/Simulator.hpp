#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include <vector>
#include "CPU.hpp"
#include "util.hpp"
#include "../asm/Instructions.hpp"

#define MEMSIZE (1 << 25)
#define CACHESIZE (1 << 12)

class Simulator
{
private:
    map<int,bool> break_pc;
    vector<unsigned long long> break_clk;
    vector<int> instructions;
public:
    vector<string> str_instr;
    vector<int> line_to_pc;
    vector<int> pc_to_line;

    CPU* cpu;
    bool isasm;
    void reset();
    int read_asm(string filename);
    int eat_bin(string filename);
    int set_brk(string bp);
    int del_brk(string bp);
    int brk_unified(int bp);
    void clk_set_brk(int new_br);
    void clk_del_brk(int new_br);
    int rerun();
    int run();
    int cont();
    int step();
    void show_reg();
    void dump(string filename);
    void show_mem(int index);
    void show_pc();
    void show_clock();
    void show_instruction();
    int get_pc();
    int get_clock();
    void show_cache();
    void show_result();
    Simulator();
    ~Simulator();
};
