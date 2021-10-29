#include "fpu.hpp"

void FPU::initdiv(){
    FILE *fp;
    fp = fopen("invparam.txt", "r");
    for(int i=0; i<1024; i++){
        fscanf(fp, "%lx", &init_grad[i]);
    }
    fclose(fp);
}

void FPU::initsqr(){
    FILE *fp;
    fp = fopen("sqrparam.txt", "r");
    for(int i=0; i<1024; i++){
        fscanf(fp, "%lx", &init_grad[i]);
    }
    fclose(fp);
}


FPU::FPU()
{
    //initdiv();
    //initsqr();
}

FPU::~FPU()
{
}
