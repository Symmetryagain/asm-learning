#include "mymemset.h"
#include <sys/types.h>
#include <stdio.h>

void *my_memset(void *s, int c, size_t n) {
  unsigned char *schar = s;
  unsigned char cbyte = c & 0xff;

  size_t align = (size_t)schar & 0x7;
  if (align) {
    align = 8 - align;
    if (n < align) align = n;
    puts("--");
    for (int i = 0; i < align; ++i)
      *schar++ = cbyte;
    n -= align;
  }

  u_int64_t cull = 0x0101010101010101ull * cbyte;
  u_int64_t *sull = (u_int64_t *)schar;
  size_t qword = n >> 3, tail = n & 0x7;

  for (; qword >= 8; qword -= 8) {
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
    *sull++ = cull;
  }
  for (; qword; --qword)
    *sull++ = cull;

  schar = (unsigned char *)sull;
  for (; tail; --tail)
    *schar++ = cbyte;
  
  return s;
}

