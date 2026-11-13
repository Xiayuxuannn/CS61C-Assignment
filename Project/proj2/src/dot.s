.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, errorlen
    blt a3, t0, errorstr
    blt a4, t0, errorstr

    # t0 is the i == 0
    li t0, 0
    # t6 is the result of the dot
    li t6, 0

loop_start:

    bge t0, a2, loop_end
    slli t3, a3, 2
    slli t4, a4, 2

    lw t1, 0(a0) #t1 is the v0[d] 
    lw t2, 0(a1) #t2 is the v1[d]

    mul t1, t1, t2
    add t6, t6, t1

    add a0, a0, t3  #a0 :the v0 pointer change to the next element.
    add a1, a1, t4  #a1 :the v1 pointer change to the next element.

    addi t0, t0, 1
    j loop_start

loop_end:

    # Epilogue
    add a0, t6, x0
    ret

errorlen:

    li a0, 75
    li a7, 93
    ecall

errorstr:

    li a0, 76
    li a7, 93
    ecall