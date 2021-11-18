#pragma once
#include <iostream>
#include <fstream>
#include <iomanip>
#include <map>
#include <vector>
#include "CPU.hpp"
#include "util.hpp"
#include "../asm/Instructions.hpp"

class Simulator
{
private:
    map<int,bool> break_pc;
    vector<unsigned long long> break_clk;
    vector<int> instructions;
    vector<int> l_to_p;
    vector<int> p_to_l;
public:
    vector<string> str_instr;

    bool ready;

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
    int pc_to_line(int);
    int line_to_pc(int);
    bool isbrk(int);
    void getPipelineInfo(vector<int>& P);
    Simulator();
    ~Simulator();
};
