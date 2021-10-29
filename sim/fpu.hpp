#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>

class FPU
{
private:
    void initdiv();
    void initsqr();
    long init_grad[1024];
    inline int finv(int x);
public:
    FPU();
    ~FPU();
    inline int fadd(int f1, int f2);
    inline int fsub(int f1, int f2);
    inline int fmul(int f1, int f2);
    inline int fdiv(int f1, int f2);
    inline int fsqrt(int f1);
    inline int fneg(int f1);
    inline int fmin(int f1, int f2);
    inline int fmax(int f1, int f2);
    inline int feq(int f1, int f2);
    inline int flt(int f1, int f2);
    inline int fle(int f1, int f2);
};

inline int FPU::fadd(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f += *g;

    int* res = (int*) f;
    return *res;
}

inline int FPU::fsub(int f1, int f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f -= *g;

    int* res = (int*) f;
    return *res;
}

inline int FPU::fneg(int f1){
    float* f = (float*) &f1;
    float fres = -(*f);
    int *res = (int *)&fres;

    return *res;
}

inline int FPU::feq(int x, int y){
    return x==y;
}

inline int FPU::finv(int x){
    long key = (x >> 13) & ((1ll<<10) - 1);
    long diff= x & ((1<<13) -1);
    int ae = (x >>23) & ((1<<8)-1);
    int as = x >> 31;
    int e;
    // e >= 253のときは結果が非正規化数になるので考えなくていっちゃいい
    if(ae >253 ) e = 0; else  e = 253- ae;

    long a,b;
    a = init_grad[key] &  ((1ll<<13)-1);
    b = (init_grad[key]>>13) << 13 ; 
    long m_ =  b -  2 * a * diff;
    int m = m_ >> 13;
    x = (as<<31) | (e<<23) | m;
    return x;
}

inline int FPU::fdiv(int x, int y){
    int xs = x>>31;
    int ys = y>>31;
    int xe = (x>>23) & 0xff;
    int ye = (y>>23) & 0xff;
    long xm = (1 << 23) | (x & 0x7fffff);
    long key = (y>>13) & 0x3ff;
    long diff = y & 0x1fff;
    long init = (init_grad[key] & 0xfffffe000);
    long grad = init_grad[key] & 0x1fff;
    long ym_ = init - 2 * diff * grad;
    //long ym =  (1<<23) | (ym>>13);
    long ym = (1l << 23) + (finv(y) & 0x7fffff);
    long m_ = xm * ym;
    long m;
    int e_ = xe - ye + 126;
    if (m_ >>47) {
        m = (m_ >> 24) & 0x7fffff;
        e_++;
    }else{
        m = (m_ >> 23) & 0x7fffff;
    }
    int e = e_ & 0xff;
    int s = xs ^ ys;
    return (s << 31 ) | (e<<23) | m;
}

inline int FPU::fsqrt(int a){
    int s = a>>31;
    int e = (a>>23 ) & 0xff;
    long key = (a>>14) & 0x3ff;
    long diff = a & 0x3fff;
    long init = (init_grad[key] >> 13) << 13;
    long grad = init_grad[key] & 0x1fff;
    /*if(diff==1023){
        printf("key:%ld", key);
        printf("diff:%ld\n", diff);
        printf("init:%ld\n", init);
        printf("grad:%ld\n", grad);
    }*/
    long m_ = init  + grad * diff;
    int m = m_>>13;
    //printf("%d\n", m);
    a = (s<<31) + ((((e+127)/2) << 23)) + m;
    //printf("%d\n", a);
    //print_bit(a);
    return a;
}

inline int FPU::fmin(int x, int y){
    int xs = (x>>31) & 1;
    int ys = (y>>31) & 1;
    int xe = (x>>23) & 0xff;
    int ye = (y>>23) & 0xff;
    int xm = x & 0x7fffff;
    int ym = y & 0x7fffff;
    int el = xe < ye;
    int eeq = xe == ye;
    int ml = xm < ym;
    int absl = el | (eeq & ml);

    int pp = 1- (xs & ys);
    int np = xs && ~ys;
    int nn = xs & ys;

    int emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //printf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //printf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //printf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    int lt = (pp&&absl) || np || (nn && ~absl && ~emeq);
    if(lt){
        return x;
    }else {
        return y;
    }
}

inline int FPU::fmax(int x, int y){
    int xs = (x>>31) & 1;
    int ys = (y>>31) & 1;
    int xe = (x>>23) & 0xff;
    int ye = (y>>23) & 0xff;
    int xm = x & 0x7fffff;
    int ym = y & 0x7fffff;
    int el = xe < ye;
    int eeq = xe == ye;
    int ml = xm < ym;
    int absl = el | (eeq & ml);

    int pp = 1- (xs & ys);
    int np = xs && ~ys;
    int nn = xs & ys;

    int emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //printf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //printf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //printf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    int lt = (pp&&absl) || np || (nn && ~absl && ~emeq);
    if(lt){
        return y;
    }else {
        return x;
    }
}

inline int FPU::flt(int x, int y){
    int xs = (x>>31) & 1;
    int ys = (y>>31) & 1;
    int xe = (x>>23) & 0xff;
    int ye = (y>>23) & 0xff;
    int xm = x & 0x7fffff;
    int ym = y & 0x7fffff;
    int el = xe < ye;
    int eeq = xe == ye;
    int ml = xm < ym;
    int absl = el | (eeq & ml);

    int pp = 1- (xs & ys);
    int np = xs && ~ys;
    int nn = xs & ys;

    int emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //printf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //printf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //printf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp&&absl) || np || (nn && ~absl && ~emeq);
}

inline int FPU::fle(int x, int y){
    int xs = (x>>31) & 1;
    int ys = (y>>31) & 1;
    int xe = (x>>23) & 0xff;
    int ye = (y>>23) & 0xff;
    int xm = x & 0x7fffff;
    int ym = y & 0x7fffff;
    int el = xe < ye;
    int eeq = xe == ye;
    int ml = xm < ym;
    int absl = el | (eeq & ml);

    int pp = 1- (xs & ys);
    int np = xs && ~ys;
    int nn = xs & ys;

    int emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //printf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //printf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //printf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp&&absl) || np || (nn && ~absl && ~emeq) || x==y;
}

inline int FPU::fmul(int a,int b){
    int s1,s2, s;
    s1 = a>>31;
    s2 = b>>31;
    s  = s1 ^ s2;


    int e1, e2, eadd, en,ep, e;
    e1 = (a>>23) & 0xff;
    e2 = (b>>23) & 0xff;
    eadd = e1 + e2;
    en = eadd - 127;
    ep = eadd - 126;

    long m1,m2;
    m1 = (a & 0x7fffff) + 0x800000;
    m2 = (b & 0x7fffff) + 0x800000;
    long mul = m1 * m2;
    int m;
    if(mul>>47) {
        if (((ep>>8) & 3) == 3) {
            e = 0;
        }else if((ep>>8) == 0) {
            e = ep;
        }else {
            e = 255;
        }
        m = (mul>>24) & 0x7fffff;
    } else {
        if (((en>>8) & 3) == 3) {
            e = 0;
        }else if((en>>8) == 0) {
            e = en;
        }else {
            e = 255;
        }
        m = (mul>>23) & 0x7fffff;
    }
    return (s<<31) + (e<<23) + m;
}