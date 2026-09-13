#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    return (x >> n) & 1;                 //保留第n位
}                                        //构造00..001
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    *x = (*x & ~(1 << n)) | (v << n);    //先把第 n 位清零，再写入 v：
}                                        //构造11....110(第n位)11......1
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    *x = *x ^ (1 << n);                  //任何数与0异或都是他自己，与1异或相当于取反
}                                        //构造00.....001(第n位)00.....0

