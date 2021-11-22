#include "simobj.h"

simObj::simObj(QObject *parent) : QObject(parent)
{
    needReset = false;
}

void simObj::run(){
    if(needReset) sim.reset();
    int ret = sim.run();
    needReset = (ret == 0) ? true : false;
    emit finished();
}

void simObj::read(){
    sim.read_asm(filename);
    emit finished();
}
