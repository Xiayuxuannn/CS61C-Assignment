.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================

argmax:

    # Prologue: check whether the array length is valid
    li t0, 1
    blt a1, t0, error

    # Initialize variables
    li t0, 1          # t0 = i, start from the second element
    lw t4, 0(a0)      # t4 = max, initialize with the first element
    li t5, 0          # t5 = max_index, initialize to index 0

loop_start:

    # Check whether all elements have been traversed
    bge t0, a1, loop_end

    # Calculate the address of array[i]
    slli t2, t0, 2
    add t2, a0, t2

    # Load array[i] into t3
    lw t3, 0(t2)

    # If the current element is not greater than max,
    # keep the previous maximum and its index
    ble t3, t4, loop_continue

    # Update the maximum element and its index
    add t4, t3, x0
    add t5, t0, x0

loop_continue:

    # Move to the next element
    addi t0, t0, 1
    j loop_start

loop_end:

    # Epilogue: return the index of the maximum element
    add a0, t5, x0
    ret

error:

    # Terminate the program with error code 77
    li a0, 77
    li a7, 93
    ecall

