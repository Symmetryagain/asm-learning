.globl findfirst1
findfirst1:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    xorl %ecx, %ecx
.Lstart:
    testl %eax, %eax
    jz .Lstop
    incl %ecx
    shrl $1, %eax
    jmp .Lstart

.Lstop:
    movl $32, %eax
    subl %ecx, %eax
    
    movl %ebp, %esp
    popl %ebp
    ret
