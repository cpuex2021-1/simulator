#pragma once
#include "Simulator.hpp"

class Profiler : public Simulator
{
private:
    int sectid;
    int genSectid();

    vector<int> funcid_list;
    vector<int> sectid_list;
    vector<bool> label_list;

    int getFuncid(int pc){
        return funcid_list[pc];
    }
    int getSectid(int pc){
        return sectid_list[pc];
    }

    void initLabellist(int p);
    void initSectId(int p);
    void initProfiler();

public:
    Profiler(/* args */);
    ~Profiler();
};