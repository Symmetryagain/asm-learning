#include <stdio.h>
#include "mymemset.h"

#define N 1001

int a[N];
void set(char s) {
  my_memset(a, s, sizeof a);
}
void test(char s) {
  unsigned us = ((unsigned)s & 0xff);
  unsigned value = 0x01010101 * us;
  printf("%d\n", s);
  for (int i = 0; i < N; ++i)
    if (a[i] != value) {
      printf("%x FAILED at %d: got %x, expected %x\n", s, i, a[i], value);
      return;
    }
  printf("%x PASSED!\n", s);
}
int main() {
  
  set(-1);
  test(-1);

  set(0);
  test(0);

  set(0xff);
  test(0xff);

  set(0xcf);
  test(0xcf);

  
  return 0;
}
