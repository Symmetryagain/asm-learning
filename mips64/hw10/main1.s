.text
.globl print_uint32
print_uint32:
    # 保存寄存器
    daddiu $sp, $sp, -64
    sd $ra, 56($sp)
    sd $s0, 48($sp)
    sd $s1, 40($sp)
    sd $s2, 32($sp)

    move $s0, $a0          # 保存输入数值到$s0
    dsll $s0, $s0, 32    # 左移32位，清空低32位以外的数据
    dsrl $s0, $s0, 32    # 右移32位回原位，此时高32位为0

    # 处理输入为0的特殊情况
    bnez $s0, non_zero
    li $v0, 5001           # Linux write 系统调用
    li $a0, 1              # stdout
    daddiu $a1, $sp, 16    # 缓冲区地址
    li $a2, 1              # 输出长度
    li $t0, '0'
    sb $t0, 16($sp)        # 存储字符 '0'
    syscall
    j end_proc

non_zero:
    li $s1, 0              # 初始化计数器
    daddiu $s2, $sp, 23    # 指向缓冲区末尾（预留12字节）

loop:
    li $t1, 10
    ddivu $s0, $t1
    mfhi $t2
    mflo $s0
    addiu $t3, $t2, '0'
    sb $t3, 0($s2)
    daddiu $s2, $s2, -1
    addiu $s1, $s1, 1
    bnez $s0, loop

    daddiu $s2, $s2, 1     # 调整指针到第一个字符

output_loop:
    li $v0, 5001           # write 系统调用
    li $a0, 1
    move $a1, $s2
    li $a2, 1
    syscall
    daddiu $s2, $s2, 1
    addiu $s1, $s1, -1
    bnez $s1, output_loop

end_proc:
    # 恢复寄存器并返回
    ld $ra, 56($sp)
    ld $s0, 48($sp)
    ld $s1, 40($sp)
    ld $s2, 32($sp)
    daddiu $sp, $sp, 64
    jr $ra