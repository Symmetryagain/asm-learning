#include "matrix.h"
#include <unistd.h>
#include <cpuid.h>

Matrix A, B, C_v[7];

int TestCase[] = {0};
int TestLen;
double st[7], ed[7];

typedef void (*MulFuncType)(Matrix *, Matrix *, Matrix *);
MulFuncType func[] = {
  py_numpy_mul,
  py_simple_mul, 
  c_simple_mul, 
  c_parallel_mul, 
  c_cache_mul, 
  c_SIMD_mul, 
  c_multi_optimized_mul
};

extern int block_size;
int checkEnv() {
    unsigned int eax, ebx, ecx, edx;
    __cpuid(1, eax, ebx, ecx, edx);
    if (ecx & bit_AVX) {
        printf("AVX supported\n");
    }
    else {
        printf("AVX NOT supported\n");
        return 0;
    }

    long cache_line_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
    long l1_cache_size = sysconf(_SC_LEVEL1_DCACHE_SIZE);
    long l2_cache_size = sysconf(_SC_LEVEL2_CACHE_SIZE);
    // block_size = (int)sqrt(1.0 * l1_cache_size / (3 * sizeof(double)));
    block_size = 64;
    printf("block size: %d\n", block_size);
    return 1;
}

void g_init() {
  TestLen = sizeof(TestCase) / sizeof(int);
  printf("g_init: len = %d\n", TestLen);
  if (!checkEnv()) {
    puts("g_init error");
    return;
  }
  A = createMatrix(M, N);
  B = createMatrix(N, P);
  for (int i = 0; i < TestLen; ++i)
      C_v[TestCase[i]] = createMatrix(M, P);

  srand(time(0));
  initMatrix(&A), initMatrix(&B);
}

void testAllCase() {
  for (int i = 0; i < TestLen; ++i) {
    st[TestCase[i]] = get_time();
    func[TestCase[i]](&A, &B, C_v + TestCase[i]);
    ed[TestCase[i]] = get_time();
    printf("TestCase %d: Using %.5lf ms\n", TestCase[i], ed[TestCase[i]] - st[TestCase[i]]);
  }

  puts("start verification:");
  for (int i = 1; i < TestLen; ++i) {
    printf("--- Verify output of TestCase #%d ---\n", TestCase[i]);
    if (verifyMatrix(C_v, C_v + TestCase[i]))
      printf("--- TestCase #%d Pass ---\n", TestCase[i]);
    else
      printf("XXX TestCase #%d Fail XXX\n", TestCase[i]); 
    puts("");
  }
}

void g_free() {
  freeMatrix(&A);
  freeMatrix(&B);
  for (int i = 0; i < TestLen; ++i)
    freeMatrix(C_v + TestCase[i]);
}

int main() {
  g_init();
  puts("init success");
  testAllCase();
  puts("test success");
  g_free();
  puts("free success");

  return 0;
}
