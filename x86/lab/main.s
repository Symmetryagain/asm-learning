.section .bss
trie_nodes:     .space 224*100000       # 26*8 + 8 + 8
.section .data
filename:       .asciz "input.txt"      # 输入文件名
fd:             .quad 0                 # 文件描述符
buffer:         .space 10000            # 文件内容缓冲区
overflow_buf:   .space 100              # 跨块单词暂存区（最大单词长度）
overflow_len:   .quad 0                 # 暂存区已存字符数
filesize:       .quad 0                 # 实际读取的字节数
current_word:   .space 100              # 当前处理的单词
error_msg:      .asciz "Error opening file\n"
error_msg_len:  .quad . - error_msg
brk_start:      .quad 0                 # 堆起始地址
trie_root:      .quad 0
trie_node_count:.quad 1
no_word_msg:    .asciz "No word\n"
no_word_msg_len:.quad . - no_word_msg

.section .text
.global _start

_start:
    # 初始化堆
    mov $12, %rax
    mov $0, %rdi
    syscall
    mov %rax, brk_start(%rip)

    # 打开文件
    mov $2, %rax
    lea filename(%rip), %rdi
    mov $0, %rsi           # O_RDONLY
    mov $0, %rdx
    syscall
    cmp $0, %rax
    jl  error_exit
    mov %rax, fd(%rip)

read_loop:
    # 将 overflow_buf 内容复制到 buffer 头部
    mov overflow_len(%rip), %rcx
    test %rcx, %rcx
    # 如果 overflow_buf 没有内容，直接读
    jz  read_new_chunk
    lea overflow_buf(%rip), %rsi
    lea buffer(%rip), %rdi
    call memcpy

read_new_chunk:
    # 计算剩余可读空间（总缓冲区大小 - 暂存区已用空间）
    mov $10000, %rax
    sub overflow_len(%rip), %rax
    mov %rax, %rdx         # 本次最大可读字节数

    # 读取文件到缓冲区后半部分
    mov $0, %rax           # sys_read
    mov fd(%rip), %rdi
    lea buffer(%rip), %rsi
    add overflow_len(%rip), %rsi  # 从缓冲区空余位置开始写入
    syscall
    # RAX = 本次实际读到的字符数
    cmp $0, %rax
    jl  error_exit
    je  process_remaining  # 读取完毕

    # 计算总有效数据长度（暂存区内容 + 新读取内容）
    add overflow_len(%rip), %rax
    mov %rax, filesize(%rip)
    movq $0, overflow_len(%rip)  # 清空暂存区

    # 处理 buffer 中最后一个有效字符连续段
    call save_overflow_chars

    # 处理 buffer 中的字符
    lea buffer(%rip), %rsi
    mov filesize(%rip), %rcx
    call process_buffer
    
    jmp read_loop

process_remaining:
    # 文件已读完, 关闭文件
    mov $3, %rax
    mov fd(%rip), %rdi
    syscall
    # 处理 overflow_buf 中的剩余字符
    mov overflow_len(%rip), %rcx
    test %rcx, %rcx
    # 如果没有则直接 find_max
    jz  find_max
    # 由于此处已经在 read_loop 开始时将 overflow_buf 读入 buffer, 将 buffer(%rip) 传入 RSI 为好
    lea buffer(%rip), %rsi
    call process_buffer

find_max:
    call trie_get_max
    test %rax, %rax
    jnz find_max_exist
    mov $1, %rax
    mov $1, %rdi
    mov no_word_msg(%rip), %rsi
    mov no_word_msg_len(%rip), %rdx
    syscall
    jmp exit

find_max_exist:
    lea trie_nodes(%rip), %r10
    mov %rax, %r9
    imul $224, %r9, %r9
    add %r10, %r9       # r9 = &node[pos]
    # 输出结果
    mov $1, %rdi
    mov 216(%r9), %rsi
    call strlen
    mov %rax, %rdx
    mov $1, %rax
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

error_exit:
    mov $1, %rax
    mov $1, %rdi
    lea error_msg(%rip), %rsi
    mov error_msg_len(%rip), %rdx
    syscall
    jmp exit

# --- 函数定义 ---

# 判断是否是字母
is_alpha:
    # 输入: AL = 字符
    # 输出: AL = 1 (是字母) / 0 (否)
    cmp $'A', %al
    jb  not_alpha
    cmp $'Z', %al
    jbe is_alpha_ret
    cmp $'a', %al
    jb  not_alpha
    cmp $'z', %al
    ja  not_alpha
is_alpha_ret:
    mov $1, %al
    ret
not_alpha:
    xor %al, %al
    ret


# 转小写
to_lower:
    # 输入: AL = 字符
    # 输出: AL = 小写字符
    cmp $'A', %al
    jb  to_lower_ret
    cmp $'Z', %al
    ja  to_lower_ret
    add $32, %al
to_lower_ret:
    ret


# 转储字符串
strdup:
    # 输入: RDI = 源字符串
    # 输出: RAX = 新字符串指针
    push %rdi
    call strlen
    mov %rax, %rdx
    inc %rdx
    call malloc
    mov %rax, %rdi
    pop %rsi
    call memcpy
    ret


# 申请内存
malloc:
    # 输入: RDX = 需要的大小
    # 输出: RAX = 分配的内存地址
    mov brk_start(%rip), %rax    # 当前堆顶地址
    mov %rax, %rdi               # 新堆顶地址 = 原堆顶 + RDX
    add %rdx, %rdi
    # 调用 brk 系统调用设置新堆顶
    mov $12, %rax                # brk 的系统调用号
    syscall
    # 检查是否成功
    cmp $0, %rax
    jl  malloc_error             # 失败处理
    mov brk_start(%rip), %rax
    add %rdx, brk_start(%rip)
    ret

malloc_error:
    xor %rax, %rax
    ret

# 复制
memcpy:
    # 输入: RDI = 目标, RSI = 源, RDX = 长度
    mov %rdx, %rcx
    rep movsb
    ret


# 字符串长度
strlen:
    # 输入: RSI = 字符串指针
    # 输出: RAX = 长度
    xor %rax, %rax
strlen_loop:
    cmpb $0, (%rsi, %rax)
    je  strlen_done
    inc %rax
    jmp strlen_loop
strlen_done:
    ret


# 处理一个 buffer 中的内容
process_buffer:
    # 输入: RSI=缓冲区地址, RCX=缓冲区长度
    push %rsi
    push %rcx
    lea current_word(%rip), %rdi
    xor %r8, %r8            # 当前单词长度

process_loop:
    test %rcx, %rcx
    jz  process_done
    movb (%rsi), %al

    # 检查是否为字母
    call is_alpha
    test %al, %al
    jz  non_alpha

    # 转换为小写并存储
    movb (%rsi), %al # -----------
    call to_lower
    movb %al, (%rdi)
    inc %rdi
    inc %r8
    jmp next_char

non_alpha:
    test %r8, %r8
    jz  next_char
    movb $0, (%rdi)        # 结束当前单词
    lea current_word(%rip), %rdi
    push %rsi
    call trie_insert
    pop %rsi
    lea current_word(%rip), %rdi
    xor %r8, %r8

next_char:
    inc %rsi
    dec %rcx
    jmp process_loop

process_done:
    test %r8, %r8
    jz  process_exit
    movb $0, (%rdi)        # 处理最后一个单词
    lea current_word(%rip), %rdi
    push %rsi
    call trie_insert
    pop %rsi

process_exit:
    pop %rcx
    pop %rsi
    ret


# 处理缓冲区最后一个有效字符连续段
save_overflow_chars:
    # 从缓冲区末尾向前扫描，找到最后一个有效字符连续段的起始位置
    lea buffer(%rip), %rsi
    add filesize(%rip), %rsi
    dec %rsi
    mov filesize(%rip), %rcx
    std                     # DF=1 逆向扫描
scan_loop:
    lodsb                   # 从后往前读取字符
    call is_alpha
    test %al, %al
    jz found_alpha
    loop scan_loop
    jmp scan_done
found_alpha:
    # 计算未处理字符的起始位置（%rsi+1 到缓冲区末尾）
    inc %rsi                # 修正逆向扫描后的指针
    inc %rsi
    lea buffer(%rip), %rax
    add filesize(%rip), %rax
    sub %rsi, %rax          # RAX = 未处理字节数
    mov %rax, overflow_len(%rip)
    sub %rax, filesize(%rip)

    # RSI = 该 buffer 最后一个有效连续段的首地址
    # 如果 RAX != 0, 将最后一个有效连续段复制到 overflow_buf
    # 应直接使用 memcpy
    test %rax, %rax
    jz scan_done
    mov %rsi, %rsi
    lea overflow_buf(%rip), %rdi
    mov %rax, %rdx
    cld                     # 恢复正向复制
    call memcpy
scan_done:
    cld                     # 恢复 DF=0
    ret


# trie 树新建节点
trie_add_node:
    # 输出: RAX = 新建 trie 节点的编号
    mov trie_node_count(%rip), %rax
    addq $1, trie_node_count(%rip)
    ret


# trie 树插入字符串
trie_insert:
    # 输入: RDI = 输入字符串的首地址
    push %rbx
    push %r12
    push %rcx
    xor %rbx, %rbx
    mov %rdi, %rsi
    call strlen
    mov %rdi, %rsi # RSI = s[]
    mov %rax, %r12 # r12 = len
    mov trie_root(%rip), %rdx # RDX = now
    xor %rcx, %rcx # RCX = i

trie_insert_loop:
    cmp %r12, %rcx
    jge trie_insert_done

    movzx  (%rsi,%rcx), %eax     # 读取 s[i]
    sub    $'a', %al         # 计算 k = s[i] - 'a'
    movzx  %al, %ebx             # %ebx = k

    lea    trie_nodes(%rip), %r11
    mov    %rdx, %r8
    imul   $224, %r8, %r8         # r8 = rdx * 224
    add    %r11, %r8               # r8 = &trie_nodes[rdx]

    lea    (%r8,%rbx,8), %r9    # r9 = &ne[k]
    cmpq   $0, (%r9)
    jne    trie_node_exist
    call   trie_add_node
    mov    %rax, (%r9)

trie_node_exist:
    mov    %r12, %r10
    decq   %r10
    cmp    %rcx, %r10
    jne    trie_str_not_end
    # 字符串末尾
    mov    208(%r8), %r11           # count 的偏移 = 26*8 = 208
    test   %r11, %r11
    jnz    trie_str_exist
    mov %rsi, %rdi
    push %rcx
    call strdup
    pop %rcx
    mov %rax, 216(%r8)
    
trie_str_exist:
    addq    $1, 208(%r8)

trie_str_not_end:
    mov    (%r9), %rdx
    incq %rcx
    jmp trie_insert_loop

trie_insert_done:
    pop %rcx
    pop %r12
    pop %rbx
    ret


# 寻找 trie 树上字符串中频率最高的
trie_get_max:
    xor %r8, %r8
    xor %rax, %rax
    xor %rcx, %rcx
    mov trie_node_count(%rip), %rdx

trie_get_max_loop:
    cmp %rdx, %rcx
    jge trie_get_max_done
    lea trie_nodes(%rip), %r10
    mov %rcx, %r9
    imul $224, %r9, %r9
    add %r10, %r9 # r9 = &node[i]
    mov 208(%r9), %r11
    cmp %r11, %r8
    jl trie_update_max
    inc %rcx
    jmp trie_get_max_loop

trie_update_max:
    mov %r11, %r8
    mov %rcx, %rax
    inc %rcx
    jmp trie_get_max_loop

trie_get_max_done:
    ret