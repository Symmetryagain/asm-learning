.text
.global _start
_start:
    movq 0x100(%rsp, %rbx, 8), %rax
    addq %rax, 0x100(%rsp, %rbx, 8)