#include <stdio.h>

// 声明MIPS汇编函数原型
extern void print_uint32(unsigned int num);

int main() {
    printf("Test 1 (0x9812abcd): ");
    fflush(stdout);
    print_uint32(0x9812abcd);
    puts("");

    printf("Test 2 (0x0fff):     ");
    fflush(stdout);
    print_uint32(0x0fff);
    puts("");

    printf("Test 3 (0):          ");
    fflush(stdout);
    print_uint32(0);
    puts("");

    return 0;
}