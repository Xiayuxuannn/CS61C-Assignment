.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial:
#     addi s0, x0, 1
#     addi s1, x0, 1
# loop:
#     bgt s1, a0, exit
#     mul s0, s0, s1
#     addi s1, s1, 1
#     j loop

# exit:
#     add a0, x0, s0
#     jr ra

factorial:
    # BEGIN PROLOGUE
    addi sp, sp, -8      # 开栈帧，留出8字节
    sw   ra, 4(sp)         # 保存返回地址（因为马上要递归调用，ra会被覆盖）
    sw   a0, 0(sp)          # 保存参数 n（因为递归返回后还要用它做乘法）
    # END PROLOGUE

    addi t0, x0, 1         # t0 = 1，作为比较基准
    bgt  a0, t0, recurse   # if (n > 1) 跳去递归分支
    addi a0, x0, 1          # 否则（n<=1）：返回值 = 1
    j    return

recurse:
    addi a0, a0, -1         # a0 = n - 1，作为下一次调用的参数
    jal  factorial            # 递归调用 factorial(n-1)，结果存回 a0
                                # （jal 会把返回地址存进 ra，跳到 factorial 开头）

    lw   t1, 0(sp)              # 取回原来保存的 n
    mul  a0, a0, t1              # a0 = factorial(n-1) * n

return:
    # BEGIN EPILOGUE
    lw   ra, 4(sp)               # 恢复返回地址
    addi sp, sp, 8                 # 归还栈帧
    # END EPILOGUE
    jr   ra                        # 跳回调用者

