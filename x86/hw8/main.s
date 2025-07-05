.section .data
output_str:     .space  15
output_buf:     .space  8
table:          .ascii  "0123456789ABCDEF"
.section .text
.globl print
print:
    pushl       %ebp
    movl        %esp,               %ebp
    movl        8(%ebp),            %eax
    pushl       %ebx
    pushl       %esi
    pushl       %edi

    xorl        %esi,               %esi
    xorl        %edi,               %edi
    cmpl        $0,                 %eax
    jge         printabs
    xorl        %ebx,               %ebx
    subl        %eax,               %ebx
    movl        %ebx,               %eax
    movb        $'-',               output_str(%esi)
    incl        %esi

printabs:
    xorl        %ebx,               %ebx
    xorl        %edx,               %edx
    movb        $'0',               output_str(%esi)
    incl        %esi
    movb        $'x',               output_str(%esi)
    incl        %esi

    movl        $8,                 %ecx
printLoop:
    test        %ecx,               %ecx
    jz          pLoop_done
    movb        %al,                %bl
    and         $0xf,               %bl
    movb        table(%ebx),        %bl
    movb        %bl,                output_buf(%edi)
    incl        %edi
    shrl        $4,                 %eax
    decl        %ecx
    jmp         printLoop

pLoop_done:
    decl        %edi
    movb        output_buf(%edi),   %bl
    cmpb        $'0',               %bl
    jne         print_res
    test        %edi,               %edi
    jz          p_allzero
    jmp         pLoop_done

print_res:
    movb        output_buf(%edi),   %bl
    movb        %bl,                output_str(%esi)
    incl        %esi
    test        %edi,               %edi
    jz          p_sysprint
    decl        %edi
    jmp         print_res

p_allzero:
    movb        $'0',               output_str(%esi)
    incl        %esi

p_sysprint:
    movl        $0,                 output_str(%esi)
    movl        $4,                 %eax
    movl        $1,                 %ebx
    movl        $output_str,        %ecx
    movl        %esi,               %edx
    int         $0x80

    popl        %edi
    popl        %esi
    popl        %ebx
    popl        %ebp
    ret