.section .data
stringvar:
.ascii "0123456789abcdef"
.section .text

.globl _start
_start:
    movl $8, %ecx
    movl $stringvar, %esi
    swap_loop:
        movb (%esi), %al
        movb 1(%esi), %bl
        movb %al, 1(%esi)
        movb %bl, (%esi)
        inc %esi
        inc %esi
        loop swap_loop

    movl $4, %eax
    movl $1, %ebx
    movl $stringvar, %ecx
    movl $16, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80