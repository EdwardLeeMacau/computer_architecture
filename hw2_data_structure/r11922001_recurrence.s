.globl __start

.text
__start:
    # Read input => store to s0
    li a0, 5
    ecall
    mv s0, a0
    jal ra, recurrence

output:
    # Output the result
    mv a1, a0
    li a0, 1
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

recurrence:
    # T(n) = 2T(n - 1) + T(n - 2)
    #
    # base case:
    #  T(0) = 0
    #  T(1) = 1
    #
    # args:
    #   s0: n
    #
    # returns:
    #   a0: T(n)
    addi t0, zero, 1
    bgt s0, t0, loop # if s0 > 1, do recurrence
    mv a0, s0
    ret

loop:
    # allocate 12 bytes from stack
    addi sp, sp, -12
    # store s0, s1 and ra to stack
    sw ra, 8(sp)
    sw s1, 4(sp)
    sw s0, 0(sp)
    # calculate T(n - 1)
    addi s0, s0, -1
    jal ra, recurrence
    addi t0, zero, 2
    mul s1, a0, t0
    # calculate T(n - 2)
    addi s0, s0, -1
    jal ra, recurrence
    add a0, a0, s1
    # restore s0, s1 and ra from stack
    lw ra, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    # free 8 bytes from stack
    addi sp, sp, 12
    ret
