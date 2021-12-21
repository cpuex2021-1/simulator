#ifndef SIMULATOR_H_INCLUDED
#define SIMULATOR_H_INCLUDED
#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include <vector>
#include "CPU.hpp"
#include "util.hpp"
#include "../asm/Instructions.hpp"

typedef enum {accurate, fast} Mode;

class Simulator: public CPU
{
private:
    map<int,bool> break_pc;
    vector<unsigned long long> break_clk;
    inline static vector<int> l_to_p; //line_to_pc
    inline static vector<int> p_to_l; //pc_to_line

    //vars and functions for profiling
    int sectionid;
    int funcid;
    int getNewSectionId();
    int getNewFuncId();
    vector<int> pc_to_sectionid;

    
    int mode;
    void setup(string filename, bool isasm);
    int cont_fast();
    int cont_acc();
public:
    inline static vector<string> str_instr;

    bool ready;
    bool isasm;
    bool uart_ready;
    void full_reset();
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
    static int pc_to_line(int);
    static int line_to_pc(int);
    bool isbrk(int);
    bool getPipelineInfoByLineNum(int, string&, bool&);
    void setMode(int);
    Simulator();
    ~Simulator();
};
#endif