#include <stdio.h>
extern void print(int num);
int main() {
    print(0x0812abcd), puts("");
    print(0xcfcfcfcf), puts("");
    print(0x3f3f3f3f), puts("");
    print(0), puts("");
    return 0;
}