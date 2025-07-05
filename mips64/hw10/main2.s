# reverse.s
    .text
    .globl reverse
reverse:
    addi  $t0, $a1, -1       # m = length-1
    sra   $t0, $t0, 1        # m = (length-1)/2

    addi  $t1, $a1, -1       # 计算length-1
    dsll  $t1, $t1, 2        # 转换为字节偏移
    daddu $t1, $a0, $t1      # q = a + (length-1)*4

    beq   $t0, $zero, end    # 如果m=0，直接返回

loop:
    lw    $t2, 0($a0)       # 加载*p的值
    lw    $t3, 0($t1)       # 加载*q的值
    sw    $t3, 0($a0)       # *p = 原*q的值
    sw    $t2, 0($t1)       # *q = 原*p的值

    daddiu $a0, $a0, 4      # p++
    daddiu $t1, $t1, -4     # q--
    addi  $t0, $t0, -1      # 循环计数器减1
    bne   $t0, $zero, loop  # 继续循环

end:
    jr    $ra               # 返回