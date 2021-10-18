#include <math.h>
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