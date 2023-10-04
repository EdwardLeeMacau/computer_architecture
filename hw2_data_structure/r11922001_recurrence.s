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
    li a0, 1
    mv a1, s0
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
    addi t0, zero, 2
    bgt s0, t0, loop # if s0 >= 2, do recurrence
    mv a0, s0
    jr ra

loop:
    # allocate 8 bytes from stack
    addi sp, sp, -8
    # store s0 and s1 to stack
    sw s0, 4(sp)
    sw s1, 0(sp)
    # calculate T(n - 1)
    addi s0, s0, -1
    jal ra, recurrence
    addi t0, zero, 2
    mul s1, a0, t0
    # calculate T(n - 2)
    addi s0, s0, -1
    jal ra, recurrence
    add a0, a0, s1
    # restore s0 and s1 from stack
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 8
    jr ra
