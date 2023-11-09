# Report - Lab1 Single-Cycle CPU

## Modules Explanation

The CPU is implemented with the following components:

- ALU: Performs arithmetic operations specified in specification.
    - ALU controller: Translates the instruction into control signal of ALU.
    - Barrel shifter: The circuit shifts the input arithmetically (operator `x >>> digit`)
- Control: Control both ALU and register file.
- And miscellaneous circuits, such as 32bit-adder and muxer with two input.

The following sections will introduce the details of the implementation according to the order of stages in CPU.

### 1. Instruction Fetching

This part is composed of a program counter (PC) and an adder. `Add_PC` helps calculate `PC + 4` for each cycle. `PC` and `Instruction_Memory` are provided in source code. While wiring the clock signal `clk_i`, reset bit `rst_i`, input/out pins correctly, this part can fetch machine code sequentially.

Notes that because the CPU is single-staged, without branching instructions, it is not necessary to support either PC setting or stalling.

### 2. Instruction Decoding

After fetching the instructions from I-mem, the CPU  starts to decode the instruction and pre-fetch the values from register files. `Registers` are provided in the source code, the ports just need to be wired correctly. The `Control` reads `opcode` from instruction, and determines 3 control signal: `ALUOp`, `ALUSrc` and `RegWrite`.

Observe that only need the support of arithmetic operations are needed, all of them write the result back to register file. Therefore, `RegWrite` is always `1` here for simplicity. Then, the source of  operand 2 can be determined by inverting `opcode[5]`. Finally, there are only 2-bit different in `opcode[5:4]`, so they are send to output for determining operation of the ALU with other fields in instruction.

`Sign_Extend` reads the immediates with 12-bits length in instruction, then clone its most significant bit to make it as a 32-bit length word. `MUX_ALUSrc` selects the source of the operand 2 from either the register file or the immediates according to the control signal `ALUSrc`.

Since the CPU in this experiment supports only the arithmetic operations, they always read operands from the register file, and the result must be written back to register file. This part is simply setting the control signal `RegWrite` to `1`, and wiring the output of the ALU to the port `RDdata_i` in the register file.

### 3. Execution (Arithmetic Operations)

The `ALU_Control` reads `ALUOp`, `funct7` and `funct3` as inputs, and output the `ALUControl`. The relation between the input and output is illustrated in the following figure.

|   funct7   | funct3 | ALUOp | {func, ALUOp}  | function |
| :--------: | :----: | :---: | :------------: | :------: |
| `​xxxxxxx`  | `000`  | `01`  | `xxxxxxx00001` |   addi   |
| `0000000`  | `000`  | `11`  | `000000000011` |   add    |
| `0100000`  | `000`  | `11`  | `010000000011` |   sub    |
| `0000000`  | `111`  | `11`  | `000000011111` |   and    |
| `0000000`  | `100`  | `11`  | `000000010011` |   xor    |
| `0000000`  | `001`  | `11`  | `000000000111` |   sll    |
| `0100000`  | `101`  | `01`  | `010000010101` |   srai   |
| `0000001`  | `000`  | `11`  | `000000100011` |   mul    |

For `ALU`, all of the operations needed in ISA are implemented, then a `casez` is used to select the output according to the current instruction. Furthermore, I implemented a module `Barrel Shifter` for `srai`. Notes that the syntax of don't care bits are also support by `casez` in Verilog.

### 4. Writing Back

As mentioned in the section: Instruction Decoding, the CPU always write the result of arithmetic operations back to register. Here the output of ALU is wired to port `RDdata_i` in register file.

## Development Environment

OS Environment

```
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
```

Iverilog version: Icarus Verilog version 11.0 (stable)
