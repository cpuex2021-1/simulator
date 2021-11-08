#include "fpu.hpp"

void FPU::initdiv(){
    FILE *fp;
    fp = fopen("invparam.txt", "r");
    if(fp == NULL){
        std::cout << "invparam.txt not found" << std::endl;
        exit(1);
    }
    for(int i=0; i<1024; i++){
        if(fscanf(fp, "%lx", &div_grad[i]) < 0) perror("error occured in initdiv()");
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
        if(fscanf(fp, "%lx", &sqrt_grad[i]) < 0) perror("error occured in initsqr()");
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
