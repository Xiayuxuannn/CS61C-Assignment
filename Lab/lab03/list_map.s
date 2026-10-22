.globl map

.text
main:
    jal ra, create_default_list
    add s0, a0, x0  # a0 = s0 是节点链表的头部

    # 打印链表
    add a0, s0, x0
    jal ra, print_list

    # 打印换行符
    jal ra, print_newline

    # 加载你的参数
    add a0, s0, x0  # 把第一个节点的地址加载到 a0

    # 把目标函数的地址加载到 a1（查看绿皮书上关于 la 的说明）
    ### YOUR CODE HERE ###
    la a1, square

    # 发起对 map 的调用
    jal ra, map

    # print the list
    add a0, s0, x0
    jal ra, print_list

    # 再打印一个换行符
    jal ra, print_newline

    addi a0, x0, 10
    ecall # 终止程序

map:
    # 序言：在栈上分配空间并备份寄存器
    ### YOUR CODE HERE ###
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp) 

    beq a0, x0, done    # 如果传入的是空指针（地址 0），直接就完成了。

    add s0, a0, x0  # 将当前节点的地址保存到 s0
    add s1, a1, x0  # 将函数的地址保存到 s1

    # 记住每个节点长 8 字节：4 字节存值，后面 4 字节存指向下一个节点的指针。
    # 这告诉你如何访问值、以及如何访问指向下一个节点的指针？

    # 将当前节点的值加载到 a0
    # 思考：为什么是 a0？
    ### YOUR CODE HERE ###
    lw a0, 0(s0)
    
    # 对该值调用目标函数。不要使用 label（准备好回答为什么）。
    # 是哪个函数？回想一下 "map" 的参数
    ### YOUR CODE HERE ###
    jalr ra, s1, 0

    # 将返回值存回节点
    # 你可以假设返回值在哪里？
    ### YOUR CODE HERE ###
    sw a0, 0(s0)

    # 将下一个节点的地址加载到 a0
    # 下一个节点的地址是当前节点的一个属性。
    # 想一想结构体在内存中是如何组织的。
    ### YOUR CODE HERE ###
    lw a0, 4(s0)

    # 把函数的地址放回 a1，为递归做准备
    # 思考：为什么是 a1？a0 呢？
    ### YOUR CODE HERE ###
    add a1, s1, x0

    # 递归
    ### YOUR CODE HERE ###
    jal ra, map

done:
    # 尾声：恢复寄存器值并释放栈空间
    ### YOUR CODE HERE ###
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp) 
    addi sp, sp, 12

    jr ra # 返回调用者

square:
    mul a0 ,a0, a0
    jr ra

create_default_list:
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    li  s0, 0       # 指向我们处理过的最后一个节点
    li  s1, 0       # 已处理的节点数量
loop:   # do...
    li  a0, 8
    jal ra, malloc      # 为下一个节点申请内存
    sw  s1, 0(a0)   # node->value = i
    sw  s0, 4(a0)   # node->next = last
    add s0, a0, x0  # last = node
    addi    s1, s1, 1   # i++
    addi t0, x0, 10
    bne s1, t0, loop    # ... while i != 10
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    jr ra

print_list:
    bne a0, x0, printMeAndRecurse
    jr ra       # 没有可打印的内容
printMeAndRecurse:
    add t0, a0, x0  # t0 获取当前节点的地址
    lw  a1, 0(t0)   # a1 获取当前节点的值
    addi a0, x0, 1      # 为打印整数的 ecall 做准备
    ecall
    addi    a1, x0, ' '     # a0 获取包含空格的字符串的地址
    addi    a0, x0, 11      # 为打印字符串的 syscall 做准备
    ecall
    lw  a0, 4(t0)   # a0 获取下一个节点的地址
    jal x0, print_list  # 递归。我们不必用 jal，因为 ra 里已经有我们想返回的地址了

print_newline:
    addi    a1, x0, '\n' # 加载换行符的 ascii 码
    addi    a0, x0, 11
    ecall
    jr  ra

malloc:
    addi    a1, a0, 0
    addi    a0, x0 9
    ecall
    jr  ra