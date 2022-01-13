#ifndef FPU_H_INCLUDED
#define FPU_H_INCLUDED
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>

namespace FPU
{
inline int finv(int x);
inline int fadd(int f1, int f2);
inline int fsub(int f1, int f2); inline int fmul(int f1, int f2); inline int fdiv(int f1, int f2);
inline int fsqrt(int f1);
inline int fneg(int f1);
inline int fmin(int f1, int f2);
inline int fmax(int f1, int f2);
inline int feq(int f1, int f2);
inline int flt(int f1, int f2);
inline int fle(int f1, int f2);
inline int itof(int f1);
inline int ftoi(int f2);
inline int fsin(int f1);
inline int fcos(int f1);
inline int atan(int f1);

int fadd(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f += *g;

    int* res = (int*) f;
    return *res;
}

int fsub(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f -= *g;

    int* res = (int*) f;
    return *res;
}
int fmul(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f *= *g;

    int* res = (int*) f;
    return *res;
}
int fdiv(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f /= *g;

    int* res = (int*) f;
    return *res;
}
int fsqrt(int f1){
    float* f = (float*) &f1;
    float fres = sqrt(*f);
    int *res = (int *)&fres;

    return *res;
}
int fneg(int f1){
    float* f = (float*) &f1;
    float fres = -(*f);
    int *res = (int *)&fres;

    return *res;
}
int fmin(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f > *g){
        return f2;
    }else{
        return f1;
    }
}
int fmax(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f > *g){
        return f1;
    }else{
        return f2;
    }
}

int feq(int f1, int f2){
    return (f1 == f2);
}

int flt(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f < *g){
        return 1;
    }else{
        return 0;
    }
}

int fle(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f <= *g){
        return 1;
    }else{
        return 0;
    }
}

int itof(int i1){
    float f = (float)i1;
    int* res = (int *)&f;
    return *res;
}

int ftoi(int f1){
    float* f = (float *)&f1;
    int res = (int)(*f);
    return res;
}

int fsin(int f1){
    float* f = (float*) &f1;
    float fres = std::sin(*f);
    int *res = (int *)&fres;

    return *res;
}

int fcos(int f1){
    float* f = (float*) &f1;
    float fres = std::cos(*f);
    int *res = (int *)&fres;

    return *res;
}

int atan(int f1){
    float* f = (float*) &f1;
    float fres = std::atan(*f);
    int *res = (int *)&fres;

    return *res;
}

}


#endif
