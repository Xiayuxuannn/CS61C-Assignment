.globl simple_fn naive_pow inc_arr

.data
failure_message: .asciiz "Test failed for some reason.\n"
success_message: .asciiz "Sanity checks passed! Make sure there are no CC violations.\n"
array:
    .word 1 2 3 4 5
exp_inc_array_result:
    .word 2 3 4 5 6

.text
main:
    # 我们通过往几个保存寄存器(saved register)里装入一批随机值来测试程序——
    # 如果这些函数返回之后,其中任何一个值被改动了,
    # 就说明这几个函数里有某个违反了
    # 调用规范(calling convention)
    li s0, 2623
    li s1, 2910
    # ……中间的寄存器省略了,免得文件太长
    # 如果想做得严谨一些,
    # 还应该对 s2-s20 也加上检查
    li s11, 134
    # 现在,我们来调用几个函数
    # simple_fn:应当返回 1
    jal simple_fn # 是 "jal ra, simple_fn" 的简写
    li t0, 1
    bne a0, t0, failure
    # naive_pow:应当返回 2 ** 7 = 128
    li a0, 2
    li a1, 7
    jal naive_pow
    li t0, 128
    bne a0, t0, failure
    # inc_arr:原地对 "array" 的每个元素加 1
    la a0, array
    li a1, 5
    jal inc_arr
    jal check_arr # 验证 inc_arr 的结果,失败则跳转到 "failure"
    # 检查保存寄存器中的值是否仍然正确
    li t0, 2623
    li t1, 2910
    li t2, 134
    bne s0, t0, failure
    bne s1, t1, failure
    bne s11, t2, failure
    # 如果上面的分支一个都没有触发,就打印一条消息并正常退出
    li a0, 4
    la a1, success_message
    ecall
    li a0, 10
    ecall

# 一个很简单的函数,返回 1。
#
# FIXME 修复这个函数中被报告的错误(必要时可以删除代码行,
# 只要函数最终仍然在 a0 中返回 1 即可)。
simple_fn:
    li t0, 1
    mv a0, t0
    ret

# 计算 a0 的 a1 次方。
# 对应下面这段 C 伪代码:
#
# uint32_t naive_pow(uint32_t a0, uint32_t a1) {
#     uint32_t s0 = 1;
#     while (a1 != 0) {
#         s0 *= a0;
#         a1 -= 1;
#     }
#     return s0;
# }
#
# FIXME 这个函数里有一个调用规范(CC)错误!
# 那些全大写的注释会提示你缺少了什么。
# 另一个提示:"s0" 里的 "s" 代表什么?
naive_pow:
    # BEGIN PROLOGUE
    addi sp, sp, -4
    sw s0, 0(sp)
    # END PROLOGUE
    li s0, 1
naive_pow_loop:
    beq a1, zero, naive_pow_end
    mul s0, s0, a0
    addi a1, a1, -1
    j naive_pow_loop
naive_pow_end:
    mv a0, s0
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    addi sp, sp, 4
    # END EPILOGUE
    ret

# 原地将数组的每个元素加 1。
# a0 存放数组起始地址,a1 存放
# 数组包含的元素个数。
#
# 这个函数会调用 "helper_fn",后者接收一个
# 地址作为参数,并将该地址处存放的 32 位值加 1。
inc_arr:
    # BEGIN PROLOGUE
    #
    # FIXME 还有哪些寄存器需要保存?
    #
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    # END PROLOGUE
    mv s0, a0 # 把数组起始地址拷贝到保存寄存器
    mv s1, a1 # 把数组长度拷贝到保存寄存器
    li t0, 0 # 计数器初始化为 0
inc_arr_loop:
    beq t0, s1, inc_arr_end
    slli t1, t0, 2 # 把数组下标转换为字节偏移
    add a0, s0, t1 # 起始地址加上偏移量
    # 准备调用 helper_fn
    addi sp, sp, -4
    sw t0, 0(sp)
    # FIXME 在调用 helper_fn 之前,添加代码保存 t0 中的值
    # 提示:"t0" 里的 "t" 代表什么?
    # 另外也想一想:为什么我们不需要保存 t1?
    #
    jal helper_fn
    # helper_fn 调用结束
    lw t0, 0(sp)
    addi sp, sp, 4
    addi t0, t0, 1 # 计数器加 1
    j inc_arr_loop
inc_arr_end:
    # BEGIN EPILOGUE
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    # END EPILOGUE
    ret

# 这个辅助函数把 a0 所指内存地址处的值加 1。
# 它没有返回值。
# 对应的 C 伪代码:"*a0 = *a0 + 1"
#
# FIXME 这个函数同样违反了调用规范,但它可能不会
# 被 Venus 的 CC 检查器报出来(试着想想为什么)。helper_fn 没有用 .globl 导出
# 无论如何你都应该修复这个 bug:根据需要
# 补全序言(prologue)和尾声(epilogue)。
helper_fn:
    # BEGIN PROLOGUE
    addi sp, sp, -4
    sw s0, 0(sp)
    # END PROLOGUE
    lw t1, 0(a0)
    addi s0, t1, 1
    sw s0, 0(a0)
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    addi sp, sp, 4
    # END EPILOGUE
    ret

# 这行注释以下的内容都可以忽略

# 检查 inc_arr 的结果,调用一次之后
# 数组应为 2 3 4 5 6。
# 可以放心忽略这个函数,它没有错误。
check_arr:
    la t0, exp_inc_array_result
    la t1, array
    addi t2, t1, 20 # 最后一个元素偏移 5*4 个字节
check_arr_loop:
    beq t1, t2, check_arr_end
    lw t3, 0(t0)
    lw t4, 0(t1)
    bne t3, t4, failure
    addi t0, t0, 4
    addi t1, t1, 4
    j check_arr_loop
check_arr_end:
    ret
    

# 这其实不算一个函数——它只是打印一条消息,然后在失败时
# 终止程序。可以把它当作异常。
failure:
    li a0, 4 # 打印字符串的 ecall
    la a1, failure_message
    ecall
    li a0, 10 # 退出程序的 ecall
    ecall
    
