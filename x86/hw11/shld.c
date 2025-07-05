unsigned int shld5(unsigned int a, unsigned int b) {
  unsigned int result;
  asm volatile("movl %1, %0\n\t"
               "shll $5, %0\n\t"
               "shrl $27, %2 \n\t"
               "orl %2, %0\n\t"
               : "=&r"(result)
               : "r"(a), "r"(b)
               :);
  return result;
}
