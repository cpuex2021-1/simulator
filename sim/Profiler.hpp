#ifndef PROFILER_H_INCLUDED
#define PROFILER_H_INCLUDED
#include "Simulator.hpp"

class Profiler : public Simulator
{
protected:
    int sectid;
    int genSectid(int p);

    vector<int> funcid_list;
    vector<int> sectid_list;
    vector<int> label_list;

    int getFuncid(int pc){
        return funcid_list[pc];
    }
    int getSectid(int pc){
        return sectid_list[pc];
    }

    void initLabellist(int p);
    void initSectId(int p, int sect);

public:
    Profiler();
    void initProfiler();
    void print_sectionid_summary();
};

#endif