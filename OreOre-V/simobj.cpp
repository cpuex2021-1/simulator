#include "simobj.h"

simObj::simObj(QObject *parent) : QObject(parent)
{
    needReset = false;
}

void simObj::run(){
    if(needReset) sim.reset();
    int ret = sim.run();
    needReset = (ret == 0) ? true : false;
    Q_EMIT finished();
}

void simObj::read(){
    sim.read_asm(filename);
    Q_EMIT finished();
}

/*
void simObj::run(){
    if(needReset) sim.reset();
    sim.runFunc();
    needReset = true;
    Q_EMIT finished();
}

void simObj::read(){
    sim.read_asm(filename);
    sim.compileAll();
    Q_EMIT finished();
}*/