# Lab 4

截止时间：9 月 25 日（周五）实验课结束前。

> 原文地址：<https://web.archive.org/web/20220121174546/https://inst.eecs.berkeley.edu/~cs61c/fa20/labs/lab04/>

## 实验目标

- TSWBAT 练习调试 RISC-V 汇编代码。
- TSWBAT 编写使用指针的 RISC-V 函数。

## RISC-V 模拟器

和上周一样，我们将使用 **Venus RISC-V 模拟器**（可在[此处](https://venus.cs61c.org/)在线访问）。此外，当你需要复习 Venus 的任意功能时，请参考我们课程网站上的 [Venus 指南](https://inst.eecs.berkeley.edu/~cs61c/sp21/resources/venus-reference)。在Labs根目录：java -jar tools/venus.jar . -dm

## 练习 1：调试 `megalistmanips.s`

在 Lab 3 中，你完成了一个 RISC-V 过程，它对链表中的每个元素都应用了一个函数。在本实验中，你将处理该过程的一个类似（但稍微更复杂）的版本。

现在，我们的数据结构不再是 `int` 的链表，而是 `int` 数组的链表。请记住，在处理 `struct` 中的数组时，我们需要显式地存储数组的大小。用 C 代码表示，该数据结构如下：

```c
struct node {
    int *arr;
    int size;
    struct node *next;
};
```

另外，新的 `map` 函数的功能是：它遍历链表，并对每个 `node` 的每个数组中的每个元素，都应用传入的函数，然后把结果存回数组。

```c
void map(struct node *head, int (*f)(int)) {
    if (!head) { return; }
    for (int i = 0; i < head->size; i++) {
      head->arr[i] = f(head->arr[i]);
    }
    map(head->next, f);
}
```

就本实验而言，不必过于担心 C 函数指针的奇怪语法（欢迎在[此处](https://www.geeksforgeeks.org/function-pointer-in-c/)进一步了解）。基本上，你可以像向普通函数传参一样，向函数指针传参。

### 行动项

将以下问题的答案记录在一个文本文件中。其中一些问题需要你使用 Venus 的模拟器标签页来运行 RISC-V 代码。

1. 找出 `megalistmanips.s` 中 `map` 函数里的五个错误。阅读 `megalistmanips.s` 中 `map` 函数下（在它通过 `jr ra` 返回之前）的所有注释行，并**确保这些代码行确实做了注释所描述的事**。一些提示：

   - 为什么在调用 `jal` 之前我们需要把一些东西保存到栈上？
   - `add t0, s0, x0` 和 `lw t0, 0(s0)` 之间有什么区别？
   - 注意 `struct node` 中各属性的类型。
   - *注意*：你只需要关注 `map`、`mapLoop` 和 `done` 这几个函数，但理解整个程序也是很有价值的。

2. **在本练习中，我们要求你在实现中不要使用任何额外的 save 寄存器**。通常你可以用 save 寄存器来存储那些你希望在函数返回后仍能使用的值（在本例中，即当我们在 `map` 中调用 `f` 时），但我们希望你改用临时寄存器，并遵循它们的 caller/callee 约定。**所提供的 `map` 实现只使用了 `s0` 和 `s1` 寄存器，因此我们将要求你不得使用 `s2` 到 `s11`。**

3. **将五个错误按顺序列成一个有序列表，并写明你所做的修改来修复它们**。

4. 将修正后的代码保存到 `megalistmanips.s` 文件中。**使用 `-cc` 标志在本地对代码运行基本的调用约定检查**：

   ```plaintext
   java -jar venus.jar megalistmanips.s -cc // Append appropriate path to `venus.jar`
   ```

   CC 检查器应报告 0 个警告。

   再次强调，如果你对任何 Venus 功能不确定，[Venus 指南](https://inst.eecs.berkeley.edu/~cs61c/sp21/resources/venus-reference)是一个很好的资源。

   *注意*：CC 检查器不会检查你是否使用了 `s0` 和 `s1` 之外的寄存器，但你需要实现这一要求才能通过自动评分器。

5. 作为参考，在网页界面上运行 `megalistmanips` 应该给出以下输出：

```plaintext
Lists before:
5 2 7 8 1
1 6 3 8 4
5 2 7 4 3
1 2 3 4 7
5 6 7 8 9

Lists after:
30 6 56 72 2
2 42 12 72 20
30 6 56 20 12
2 6 12 20 56
30 42 56 72 90
```

### 检查点

此时，请确保你对以下内容已经比较熟悉。请注意，这些不会计入实验 checkoff，但旨在衡量你对本练习中材料的掌握程度。

- 你应该知道如何在 Venus 中调试，包括单步执行代码和查看寄存器内容。
- 你应该理解 RISC-V 如何与内存交互。
- 你应该理解 RISC-V 中的 CALLER/CALLEE 约定。

## 练习 2：编写一个不含分支的函数

考虑定义在集合 `{-3, -2, -1, 0, 1, 2, 3}` 的整数上的离散值函数 `f`。函数定义如下：

```plaintext
f(-3) = 6
f(-2) = 61
f(-1) = 17
f(0) = -38
f(1) = 19
f(2) = 42
f(3) = 5
```

### 行动项

1. 在 `discrete_fn.s` 中用 RISC-V 实现该函数，条件是你的代码**不得**使用任何分支和/或跳转指令！
2. 将修正后的代码保存到文件 `discrete_fn.s` 中。

提示：你如何从动态地址加载一个字（word）？

## Checkoff

请提交到 Lab Autograder 作业（和上周一样！）。
