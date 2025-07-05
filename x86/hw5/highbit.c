#include <stdio.h>
extern unsigned findfirst1(unsigned x);
int main() {
    unsigned int test_cases[] = {0, 1, 2, 5, 0xFF, 0x80000000};

    for(int i = 0; i < 6; i++)
        printf("findfirst1(0x%08x) = %u\n", test_cases[i], findfirst1(test_cases[i]));

    return 0;
}