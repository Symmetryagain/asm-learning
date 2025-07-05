.section .data
buffer: .space 16

.section .text
.global _start

_start:
    movl $100, %ecx
    movl $1, %ebx
    xorl %eax, %eax

loop1:
    addl %ebx, %eax
    addl $2, %ebx
    loop loop1

    leal buffer+15, %edi
    movb $0x0A, (%edi)
    decl %edi
    movl $10, %ebx

loop2:
    xorl %edx, %edx
    divl %ebx
    addb $'0', %dl
    movb %dl, (%edi)
    decl %edi
    testl %eax, %eax
    jnz loop2

    incl %edi
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $buffer+16, %edx
    subl %ecx, %edx
    int $0x80

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80