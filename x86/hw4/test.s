.text
.global _start
_start:
    addl $0xdeadbeef, -0x3f(%eax,%esi,4)
    cmpxchg %eax, 0xface(%edx,%edi,2)
    movl 0xcafe(%ebx,%esi,4), %eax