.section .data 
iostring:
    .asciz "ab1g2hA0H56po9wK78nB"
.section .text
.globl _start
_start:

    movl $iostring, %edi

convert_loop:
    cmpb $0, (%edi)
    je convert_break
    cmpb $'a', (%edi)
    jl convert_continue
    cmpb $'z', (%edi)
    jg convert_continue
    subb $32, (%edi)

convert_continue:
    incl %edi
    jmp convert_loop

convert_break:
    movl $4, %eax
    movl $1, %ebx
    movl $iostring, %ecx
    movl $20, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80