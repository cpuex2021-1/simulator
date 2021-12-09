#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>

class FPU
{
private:
    long long *div_grad;
    long long *sqrt_grad;
    inline long long finv(long long x);
public:
    FPU();
    ~FPU();
    inline long long fadd(long long f1, long long f2);
    inline long long fsub(long long f1, long long f2);
    inline long long fmul(long long f1, long long f2);
    inline long long fdiv(long long f1, long long f2);
    inline long long fsqrt(long long f1);
    inline long long fneg(long long f1);
    inline long long fmin(long long f1, long long f2);
    inline long long fmax(long long f1, long long f2);
    inline long long feq(long long f1, long long f2);
    inline long long flt(long long f1, long long f2);
    inline long long fle(long long f1, long long f2);
    inline long long itof(long long f1);
    inline long long ftoi(long long f2);
};

inline long long FPU::fadd(long long f1, long long f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f += *g;

    long long* res = (long long*) f;
    return *res;
}

inline long long FPU::fsub(long long f1, long long f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f -= *g;

    long long* res = (long long*) f;
    return *res;
}

inline long long FPU::fneg(long long f1){
    float* f = (float*) &f1;
    float fres = -(*f);
    long long *res = (long long *)&fres;

    return *res;
}

inline long long FPU::feq(long long x, long long y){
    return x==y;
}

inline long long FPU::finv(long long x){
    long key = (x >> 13) & ((1ll<<10) - 1);
    long diff= x & ((1<<13) -1);
    long long ae = (x >>23) & ((1<<8)-1);
    long long as = x >> 31;
    long long e;
    // e >= 253のときは結果が非正規化数になるので考えなくていっちゃいい
    if(ae >253 ) e = 0; else  e = 253- ae;

    long a,b;
    a = div_grad[key] &  ((1ll<<13)-1);
    b = (div_grad[key]>>13) << 13 ; 
    long m_ =  b -  2 * a * diff;
    long long m = m_ >> 13;
    x = (as<<31) | (e<<23) | m;
    return x;
}

inline long long FPU::fdiv(long long x, long long y){
    long long xs = x>>31;
    long long ys = y>>31;
    long long xe = (x>>23) & 0xff;
    long long zero = xe == 0;
    long long ye = (y>>23) & 0xff;
    long xm = (1 << 23) | (x & 0x7fffff);
    //long key = (y>>13) & 0x3ff;
    //long diff = y & 0x1fff;
    //long init = (div_grad[key] & 0xfffffe000);
    //long grad = div_grad[key] & 0x1fff;
    //long ym_ = init - 2 * diff * grad;
    //long ym =  (1<<23) | (ym>>13);
    long ym = (1l << 23) + (finv(y) & 0x7fffff);
    long m_ = xm * ym;
    long m;
    long long e_ = xe - ye + 126;
    if (m_ >>47) {
        m = (m_ >> 24) & 0x7fffff;
        e_++;
    }else{
        m = (m_ >> 23) & 0x7fffff;
    }
    long long e = e_ & 0xff;
    long long s = xs ^ ys;
    if(zero){
        return 0;
    }else{
        return (s << 31 ) | (e<<23) | m;
    }
}

inline long long FPU::fsqrt(long long a){
    long long s = a>>31;
    long long e = (a>>23 ) & 0xff;
    long key = (a>>14) & 0x3ff;
    long diff = a & 0x3fff;
    long init = (sqrt_grad[key] >> 13) << 13;
    long grad = sqrt_grad[key] & 0x1fff;
    /*if(diff==1023){
        prlong longf("key:%ld", key);
        prlong longf("diff:%ld\n", diff);
        prlong longf("init:%ld\n", init);
        prlong longf("grad:%ld\n", grad);
    }*/
    long m_ = init  + grad * diff;
    long long m = m_>>13;
    //prlong longf("%d\n", m);
    a = (s<<31) + ((((e+127)/2) << 23)) + m;
    //prlong longf("%d\n", a);
    //prlong long_bit(a);
    return a;
}

inline long long FPU::fmin(long long x, long long y){
    long long xs = (x>>31) & 1;
    long long ys = (y>>31) & 1;
    long long xe = (x>>23) & 0xff;
    long long ye = (y>>23) & 0xff;
    long long xm = x & 0x7fffff;
    long long ym = y & 0x7fffff;
    long long el = xe < ye;
    long long eeq = xe == ye;
    long long ml = xm < ym;
    long long absl = el | (eeq & ml);

    long long pp = 1- (xs & ys);
    long long np = xs && ~ys;
    long long nn = xs & ys;

    long long emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //prlong longf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //prlong longf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //prlong longf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    long long lt = (pp&&absl) || np || (nn && ~absl && ~emeq);
    if(lt){
        return x;
    }else {
        return y;
    }
}

inline long long FPU::fmax(long long x, long long y){
    long long xs = (x>>31) & 1;
    long long ys = (y>>31) & 1;
    long long xe = (x>>23) & 0xff;
    long long ye = (y>>23) & 0xff;
    long long xm = x & 0x7fffff;
    long long ym = y & 0x7fffff;
    long long el = xe < ye;
    long long eeq = xe == ye;
    long long ml = xm < ym;
    long long absl = el | (eeq & ml);

    long long pp = 1- (xs & ys);
    long long np = xs && ~ys;
    long long nn = xs & ys;

    long long emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //prlong longf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //prlong longf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //prlong longf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    long long lt = (pp&&absl) || np || (nn && ~absl && ~emeq);
    if(lt){
        return y;
    }else {
        return x;
    }
}

inline long long FPU::flt(long long x, long long y){
    long long xs = (x>>31) & 1;
    long long ys = (y>>31) & 1;
    long long xe = (x>>23) & 0xff;
    long long ye = (y>>23) & 0xff;
    long long xm = x & 0x7fffff;
    long long ym = y & 0x7fffff;
    long long el = xe < ye;
    long long eeq = xe == ye;
    long long ml = xm < ym;
    long long absl = el | (eeq & ml);

    long long pp = 1- (xs & ys);
    long long np = xs && ~ys;
    long long nn = xs & ys;

    long long emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //prlong longf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //prlong longf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //prlong longf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp&&absl) || np || (nn && ~absl && ~emeq);
}

inline long long FPU::fle(long long x, long long y){
    long long xs = (x>>31) & 1;
    long long ys = (y>>31) & 1;
    long long xe = (x>>23) & 0xff;
    long long ye = (y>>23) & 0xff;
    long long xm = x & 0x7fffff;
    long long ym = y & 0x7fffff;
    long long el = xe < ye;
    long long eeq = xe == ye;
    long long ml = xm < ym;
    long long absl = el | (eeq & ml);

    long long pp = 1- (xs & ys);
    long long np = xs && ~ys;
    long long nn = xs & ys;

    long long emeq = (x & 0x3fffffff) == (y& 0x3fffffff);
    //prlong longf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //prlong longf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //prlong longf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp&&absl) || np || (nn && ~absl && ~emeq) || x==y;
}

inline long long FPU::fmul(long long a,long long b){
    long long s1,s2, s;
    s1 = a>>31;
    s2 = b>>31;
    s  = s1 ^ s2;


    long long e1, e2, eadd, en,ep, e,zero;
    e1 = (a>>23) & 0xff;
    e2 = (b>>23) & 0xff;
    zero = e1 == 0 || e2==0;
    eadd = e1 + e2;
    en = eadd - 127;
    ep = eadd - 126;

    long m1,m2;
    m1 = (a & 0x7fffff) + 0x800000;
    m2 = (b & 0x7fffff) + 0x800000;
    long mul = m1 * m2;
    long long m;
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
    if(zero){
        return 0;
    }else{
        return (s<<31) + (e<<23) + m;
    }
}

inline long long FPU::ftoi(long long f1){
    float* f = (float*) &f1;
    long long res = (long long)(*f);
    return res;
}

inline long long FPU::itof(long long f1){
    float f = (float) f1;
    long long* res = (long long *) &f;
    return (*res);
}