#ifndef FPU_H_INCLUDED
#define FPU_H_INCLUDED
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cmath>
#include <iostream>

namespace StdFPU
{
inline int32_t finv(int32_t x);
inline int32_t fadd(int32_t f1, int32_t f2);
inline int32_t fsub(int32_t f1, int32_t f2); inline int32_t fmul(int32_t f1, int32_t f2); inline int32_t fdiv(int32_t f1, int32_t f2);
inline int32_t fsqrt(int32_t f1);
inline int32_t fneg(int32_t f1);
inline int32_t fabs(int32_t f1);
inline int32_t floor(int32_t f1);
inline int32_t feq(int32_t f1, int32_t f2);
inline int32_t flt(int32_t f1, int32_t f2);
inline int32_t fle(int32_t f1, int32_t f2);
inline int32_t itof(int32_t f1);
inline int32_t ftoi(int32_t f2);
inline int32_t fsin(int32_t f1);
inline int32_t fcos(int32_t f1);
inline int32_t atan(int32_t f1);

int32_t fadd(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f += *g;

    int32_t* res = (int32_t*) f;
    return *res;
}

int32_t fsub(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f -= *g;

    int32_t* res = (int32_t*) f;
    return *res;
}
int32_t fmul(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f *= *g;

    int32_t* res = (int32_t*) f;
    return *res;
}
int32_t fdiv(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f /= *g;

    int32_t* res = (int32_t*) f;
    return *res;
}
int32_t fsqrt(int32_t f1){
    float* f = (float*) &f1;
    float fres = sqrt(*f);
    int32_t *res = (int32_t *)&fres;

    return *res;
}
int32_t fneg(int32_t f1){
    float* f = (float*) &f1;
    float fres = -(*f);
    int32_t *res = (int32_t *)&fres;

    return *res;
}
int32_t fabs(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::fabs(*f);
    int32_t* res = (int32_t *)&fres;

    return *res;
}

int32_t floor(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::floor(*f);
    int32_t* res = (int32_t *)&fres;
    
    return *res;
}

int32_t feq(int32_t f1, int32_t f2){
    return (f1 == f2);
}

int32_t flt(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f < *g){
        return 1;
    }else{
        return 0;
    }
}

int32_t fle(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;
    if(*f <= *g){
        return 1;
    }else{
        return 0;
    }
}

int32_t itof(int32_t i1){
    float f = (float)i1;
    int32_t* res = (int32_t *)&f;
    return *res;
}

int32_t ftoi(int32_t f1){
    float* f = (float *)&f1;
    int32_t res = (int32_t)(*f);
    return res;
}

int32_t fsin(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::sin(*f);
    int32_t *res = (int32_t *)&fres;

    return *res;
}

int32_t fcos(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::cos(*f);
    int32_t *res = (int32_t *)&fres;

    return *res;
}

int32_t atan(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::atan(*f);
    int32_t *res = (int32_t *)&fres;

    return *res;
}

}

namespace OrenoFPU
{
extern int64_t div_grad[1024];
extern int64_t sqrt_grad[1024];
inline int32_t finv(int64_t x);
inline int32_t fadd(int32_t f1, int32_t f2);
inline int32_t fsub(int32_t f1, int32_t f2);
inline int32_t fmul(int32_t f1, int32_t f2);
inline int32_t fdiv(int32_t f1, int32_t f2);
inline int32_t fsqrt(int32_t f1);
inline int32_t fneg(int32_t f1);
inline int32_t fabs(int32_t f1);
inline int32_t floor(int32_t f1);
inline int32_t feq(int32_t f1, int32_t f2);
inline int32_t flt(int32_t f1, int32_t f2);
inline int32_t fle(int32_t f1, int32_t f2);
inline int32_t itof(int32_t f1);
inline int32_t ftoi(int32_t f2);

inline int32_t fadd(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f += *g;

    int64_t* res = (int64_t*) f;
    return *res;
}

inline int32_t fsub(int32_t f1, int32_t f2){
    float* f = (float*) &f1;
    float* g = (float*) &f2;

    *f -= *g;

    int64_t* res = (int64_t*) f;
    return *res;
}

inline int32_t fneg(int32_t f1){
    float* f = (float*) &f1;
    float fres = -(*f);
    int64_t *res = (int64_t *)&fres;

    return *res;
}

inline int32_t feq(int32_t x, int32_t y){
    return x==y;
}

inline int32_t finv(int32_t x){
    int64_t key = (x >> 13) & ((1ll<<10) - 1);
    int64_t diff= x & ((1<<13) -1);
    int64_t ae = (x >>23) & ((1<<8)-1);
    int64_t as = x >> 31;
    int64_t e;
    // e >= 253のときは結果が非正規化数になるので考えなくていっちゃいい
    if(ae >253 ) e = 0; else  e = 253- ae;

    int64_t a,b;
    a = div_grad[key] &  ((1ll<<13)-1);
    b = (div_grad[key]>>13) << 13 ; 
    int64_t m_ =  b -  2 * a * diff;
    int64_t m = m_ >> 13;
    x = (as<<31) | (e<<23) | m;
    return x;
}

inline int32_t fdiv(int32_t x, int32_t y){
    int64_t xs = x>>31;
    int64_t ys = y>>31;
    int64_t xe = (x>>23) & 0xff;
    int64_t zero = xe == 0;
    int64_t ye = (y>>23) & 0xff;
    int64_t xm = (1 << 23) | (x & 0x7fffff);
    //int64_t key = (y>>13) & 0x3ff;
    //int64_t diff = y & 0x1fff;
    //int64_t init = (div_grad[key] & 0xfffffe000);
    //int64_t grad = div_grad[key] & 0x1fff;
    //int64_t ym_ = init - 2 * diff * grad;
    //int64_t ym =  (1<<23) | (ym>>13);
    int64_t ym = (1l << 23) + (finv(y) & 0x7fffff);
    int64_t m_ = xm * ym;
    int64_t m;
    int64_t e_ = xe - ye + 126;
    if (m_ >>47) {
        m = (m_ >> 24) & 0x7fffff;
        e_++;
    }else{
        m = (m_ >> 23) & 0x7fffff;
    }
    int64_t e = e_ & 0xff;
    int64_t s = xs ^ ys;
    if(zero){
        return 0;
    }else{
        return (s << 31 ) | (e<<23) | m;
    }
}

inline int32_t fsqrt(int32_t a){
    int64_t s = a>>31;
    int64_t e = (a>>23 ) & 0xff;
    int64_t key = (a>>14) & 0x3ff;
    int64_t diff = a & 0x3fff;
    int64_t init = (sqrt_grad[key] >> 13) << 13;
    int64_t grad = sqrt_grad[key] & 0x1fff;
    /*if(diff==1023){
        print64_tf("key:%ld", key);
        print64_tf("diff:%ld\n", diff);
        print64_tf("init:%ld\n", init);
        print64_tf("grad:%ld\n", grad);
    }*/
    int64_t m_ = init  + grad * diff;
    int64_t m = m_>>13;
    //print64_tf("%d\n", m);
    a = (s<<31) + ((((e+127)/2) << 23)) + m;
    //print64_tf("%d\n", a);
    //print64_t_bit(a);
    return a;
}

int32_t fabs(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::fabs(*f);
    int32_t* res = (int32_t *)&fres;

    return *res;
}

int32_t floor(int32_t f1){
    float* f = (float*) &f1;
    float fres = std::floor(*f);
    int32_t* res = (int32_t *)&fres;
    
    return *res;
}

inline int32_t flt(int32_t x, int32_t y){
    int64_t xs = (x>>31) & 1;
    int64_t ys = (y>>31) & 1;
    int64_t xe = (x>>23) & 0xff;
    int64_t ye = (y>>23) & 0xff;
    int64_t xm = x & 0x7fffff;
    int64_t ym = y & 0x7fffff;
    int64_t el = xe < ye;
    int64_t eeq = xe == ye;
    int64_t ml = xm < ym;
    int64_t absl = el | (eeq & ml);

    int64_t pp = xs==0 && ys==0;
    int64_t np = xs==1 && ys==0;
    int64_t nn = xs==1 && ys==1;

    int64_t emeq = (x & 0x7fffffff) == (y& 0x7fffffff);
    //print64_tf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //print64_tf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //print64_tf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp==1&&absl==1) || np || (nn==1 && absl==0 && emeq==0);
}

inline int32_t fle(int32_t x, int32_t y){
    int64_t xs = (x>>31) & 1;
    int64_t ys = (y>>31) & 1;
    int64_t xe = (x>>23) & 0xff;
    int64_t ye = (y>>23) & 0xff;
    int64_t xm = x & 0x7fffff;
    int64_t ym = y & 0x7fffff;
    int64_t el = xe < ye;
    int64_t eeq = xe == ye;
    int64_t ml = xm < ym;
    int64_t absl = el | (eeq & ml);

    int64_t pp = xs==0 && ys==0;
    int64_t np = xs==1 && ys==0;
    int64_t nn = xs==1 && ys==1;

    int64_t emeq = (x & 0x7fffffff) == (y& 0x7fffffff);
    //print64_tf("x:%d xs:%d xe:%d xm:%d\n", x,xs,xe,xm);
    //print64_tf("y:%d ys:%d ye:%d ym:%d\n", y,ys,ye,ym);
    //print64_tf("el:%d eeq:%d mL:%d absl:%d pp:%d np:%d nn:%d\n", el,eeq,ml,absl,pp,np,nn);
    return (pp==1&&absl==1) || np || (nn==1 && absl==0 && emeq==0) || x==y;
}

inline int32_t fmul(int32_t a, int32_t b){
    int64_t s1,s2,s;
    s1 = a>>31;
    s2 = b>>31;
    s  = s1 ^ s2;


    int64_t e1, e2, eadd, en,ep, e,zero;
    e1 = (a>>23) & 0xff;
    e2 = (b>>23) & 0xff;
    zero = e1 == 0 || e2==0;
    eadd = e1 + e2;
    en = eadd - 127;
    ep = eadd - 126;

    int64_t m1,m2;
    m1 = (a & 0x7fffff) + 0x800000;
    m2 = (b & 0x7fffff) + 0x800000;
    int64_t mul = m1 * m2;
    int64_t m;
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

inline int32_t ftoi(int32_t f1){
    float* f = (float*) &f1;
    int64_t res = (int64_t)round(*f);
    return res;
}

inline int32_t itof(int32_t f1){
    float f = (float) f1;
    int64_t* res = (int64_t *) &f;
    return (*res);
}
}

#endif
