.section .data 

testdata:
    .byte 'A', '0', 'z', 'P', '8', 'r', 'Z', '2', 'f', 'H'

.section .text
.globl _start
_start:
    movl $testdata, %edi
    movl $10, %ecx

    pushl %ecx
    pushl %edi
    call insert_sort
    addl $8, %esp

    pushl %ecx
    pushl %edi
    call as_puts
    addl $8, %esp

    call as_exit


insert_sort:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %ecx
    pushl %esi
    pushl %ebx

    # %edi a 
    # %ecx n
    movl 12(%ebp), %ecx
    movl 8(%ebp), %edi

    # %esi i 
    # %ebx j
    # %al tmp

    movl $1, %esi
Loop1:
    cmpl %ecx, %esi
    jge Loop1_end
    movb (%edi,%esi), %al
    movl %esi, %ebx
    decl %ebx

Loop2:
    cmpl $0, %ebx
    jl Loop2_end
    cmpb (%edi,%ebx), %al
    jge Loop2_end
    movb (%edi,%ebx), %dl
    movb %dl, 1(%edi,%ebx)
    decl %ebx
    jmp Loop2

Loop2_end:
    movb %al, 1(%edi,%ebx)
    incl %esi
    jmp Loop1

Loop1_end:
    popl %ebx
    popl %esi
    popl %ecx
    popl %edi
    popl %ebp
    ret

as_puts:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl $4, %eax
    movl $1, %ebx
    movl 8(%ebp), %ecx
    movl 12(%ebp), %edx
    int $0x80

    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

as_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
    ret