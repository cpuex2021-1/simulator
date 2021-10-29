#include "fpu.hpp"

void FPU::initdiv(){
    FILE *fp;
    fp = fopen("invparam.txt", "r");
    if(fp == NULL){
        std::cout << "invparam.txt not found" << std::endl;
        exit(1);
    }
    for(int i=0; i<1024; i++){
        fscanf(fp, "%lx", &init_grad[i]);
    }
    fclose(fp);
}

void FPU::initsqr(){
    FILE *fp;
    fp = fopen("sqrparam.txt", "r");
    if(fp == NULL){
        std::cout << "sqrparam.txt not found" << std::endl;
        exit(1);
    }
    for(int i=0; i<1024; i++){
        fscanf(fp, "%lx", &init_grad[i]);
    }
    fclose(fp);
}


FPU::FPU()
{
    initdiv();
    initsqr();
}

FPU::~FPU()
{
}
