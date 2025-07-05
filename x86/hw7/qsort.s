.section .text
.globl qsort
.type qsort, @function
qsort:
    # 函数序言
    pushq   %rbp
    movq    %rsp, %rbp
    
    # 保存被调用者保存寄存器
    pushq   %rbx      # 保存i
    pushq   %r12      # 保存数组基地址
    pushq   %r13      # 保存sd值
    pushq   %r14      # 保存l
    pushq   %r15      # 保存r

    # 参数寄存器分配
    # rdi = a[]指针, rsi = l, rdx = r
    movq    %rdi, %r12     # r12 = 数组基地址
    movl    %esi, %r14d    # r14d = l
    movl    %edx, %r15d    # r15d = r

    # 计算中间索引 mid = (l + r)/2
    movl    %r14d, %eax
    addl    %r15d, %eax
    sarl    $1, %eax       # 算术右移实现除法

    # 获取枢轴值 sd = a[mid]
    movl    (%r12,%rax,4), %r13d  # r13d = sd

    # 初始化i = l, j = r
    movl    %r14d, %ebx    # ebx = i = l
    movl    %r15d, %ecx    # ecx = j = r

partition_loop:
    # while(a[i] < sd) i++
i_inner_loop:
    cmpl    %r13d, (%r12,%rbx,4)  # 比较a[i]与sd
    jge     end_i_loop
    incl    %ebx                   # i++
    jmp     i_inner_loop

end_i_loop:

    # while(a[j] > sd) j--
j_inner_loop:
    cmpl    %r13d, (%r12,%rcx,4)  # 比较a[j]与sd
    jle     end_j_loop
    decl    %ecx                   # j--
    jmp     j_inner_loop

end_j_loop:

    # 检查交换条件 if(i <= j)
    cmpl    %ecx, %ebx
    jg      end_swap

    # 交换a[i]和a[j]
    movl    (%r12,%rbx,4), %eax    # eax = a[i]
    movl    (%r12,%rcx,4), %edx    # edx = a[j]
    movl    %edx, (%r12,%rbx,4)    # a[i] = edx
    movl    %eax, (%r12,%rcx,4)    # a[j] = eax

    # 移动指针
    incl    %ebx                   # i++
    decl    %ecx                   # j--

end_swap:

    # 主循环条件检查
    cmpl    %ecx, %ebx
    jle     partition_loop

    # 递归左半部分 if(l < j)
    movl    %r14d, %eax           # eax = l
    cmpl    %ecx, %eax            # 比较l与j
    jge     check_right

    # 准备参数调用 qsort(a, l, j)
    movq    %r12, %rdi            # 参数1: 数组指针
    movl    %eax, %esi            # 参数2: l
    movl    %ecx, %edx            # 参数3: j
    call    qsort

check_right:
    # 递归右半部分 if(i < r)
    movl    %r15d, %eax           # eax = r
    cmpl    %eax, %ebx            # 比较i与r
    jge     end_recursion

    # 准备参数调用 qsort(a, i, r)
    movq    %r12, %rdi            # 参数1: 数组指针
    movl    %ebx, %esi            # 参数2: i
    movl    %eax, %edx            # 参数3: r
    call    qsort

end_recursion:
    # 恢复寄存器
    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbx

    # 函数结语
    leave
    ret