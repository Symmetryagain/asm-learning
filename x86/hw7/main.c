#include <stdio.h>

typedef struct Data {
    int v;
    double re, im;
    float c;
    long long mul, add;
    char str[11];
    int len;
} Data;

Data calc(Data a, Data b) {
    Data res;
    res.v = a.v + b.v;

    res.re = a.re * b.re - a.im * b.im;
    res.im = a.re * b.im + a.im * b.re;

    res.c = (a.c + b.c) / 2;

    res.mul = a.mul * b.mul;
    res.add = a.add + a.mul * b.add;

    res.len = a.len + b.len;
    if(res.len > 10) res.len = 10;
    for(int i = 0; i < res.len; ++i)
        res.str[i] = (i < a.len) ? a.str[i] : b.str[i - a.len];
    res.str[res.len] = 0;
    return res;
}

Data foo(Data a, Data b, Data c) {
    Data d = calc(a, b);
    d = calc(c, d);
    return d;
}

int main() {
    
    return 0;
}