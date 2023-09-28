.globl __start

.rodata
    division_by_zero: .string "division by zero"
    ops: .word op_add, op_sub, op_mul, op_div, op_min, op_pow, op_factorial

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    # Optain the addr of operation
    # int (*op)(int, int) = &ops[s1];
    la t0, ops
    slli t1, s1, 2
    add t1, t1, t0
    lw t1, 0(t1)
    # Invoke the operation
    # int result = op(s0, s2);
    jr t1

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit

op_add:
    add s3, s0, s2
    jal zero, output

op_sub:
    sub s3, s0, s2
    jal zero, output

op_mul:
    mul s3, s0, s2
    jal zero, output

op_div:
    beqz s2, division_by_zero_except
    div s3, s0, s2
    jal zero, output

op_min:
    # #define min(a, b) ((a) < (b) ? (a) : (b))
    slt t0, s0, s2
    bnez t0, op_min_true
    mv s3, s2
    j op_min_end
op_min_true:
    mv s3, s0
op_min_end:
    jal zero, output

op_pow:
    addi t0, zero, 1
op_pow_loop:
    beqz s2, op_pow_end
    mul t0, t0, s0
    addi s2, s2, -1
    j op_pow_loop
op_pow_end:
    mv s3, t0
    jal zero, output

op_factorial:
    addi t0, zero, 1
op_factorial_loop:
    beqz s0, op_factorial_end
    mul t0, t0, s0
    addi s0, s0, -1
    j op_factorial_loop
op_factorial_end:
    mv s3, t0
    jal zero, output
