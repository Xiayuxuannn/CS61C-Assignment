.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    blt a1, x0, error_m0
    blt a2, x0, error_m0

    blt a4, x0, error_m1
    blt a5, x0, error_m1

    bne a2, a4, error_74
    # Prologue

    addi sp, sp, -48

    sw ra, 36(sp)
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)

    # Save matrix arguments in s registers
    add s0, a0, x0      # m0 pointer
    add s1, a1, x0      # m0 rows
    add s2, a2, x0      # m0 cols
    add s3, a3, x0      # m1 pointer
    add s4, a4, x0      # m1 rows
    add s5, a5, x0      # m1 cols
    add s6, a6, x0      # output pointer

    li s7, 0            # i = 0

outer_loop_start:

    bge s7, s1, outer_loop_end
    li s8, 0            # j = 0

inner_loop_start:

    bge s8, s5, inner_loop_end

    # =========================================
    # 3. Calculate dot arguments
    # =========================================

    # a0 = &m0[i][0]
    # offset = i * m0_cols * 4

    mul t0, s7, s2
    slli t0, t0, 2
    add a0, s0, t0

    # a1 = &m1[0][j]
    # offset = j * 4
    slli t0, s8, 2
    add a1, s3, t0

    # dot length = m0_cols
    add a2, s2, x0

    # m0 row stride = 1
    li a3, 1

    # m1 column stride = m1_cols
    add a4, s5, x0

    jal ra, dot

    # Store result
    sw a0, 0(s6)
    addi s6, s6, 4

    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:

    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:

    # Epilogue

    lw ra, 36(sp)
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)

    addi sp, sp, 48

    ret

error_m0:

    li a0, 72
    j exit

error_m1:

    li a0, 73
    j exit

error_74:

    LI a0, 74
    j exit