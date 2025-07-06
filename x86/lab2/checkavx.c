#include <stdio.h>
#include <cpuid.h>
#include <unistd.h>
#include <math.h>

int main() {
    unsigned int eax, ebx, ecx, edx;
    __cpuid(1, eax, ebx, ecx, edx);
    if (ecx & bit_AVX) 
        printf("AVX supported\n");
    else 
        printf("AVX NOT supported\n");


    long cache_line_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
    long l1_cache_size = sysconf(_SC_LEVEL1_DCACHE_SIZE);
    long l2_cache_size = sysconf(_SC_LEVEL2_CACHE_SIZE);
    printf("%ld\n", l1_cache_size >> 10);
    printf("cache block size: %d\n", (int)sqrt(l1_cache_size / (3 * sizeof(double))));
    return 0;
}
