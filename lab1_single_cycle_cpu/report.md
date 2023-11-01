# Report - Lab1 Single-Cycle CPU

## Modules Explanation

I implemented the CPU with the following components:

- ALU: Performs arithmetic operations specified in specification.
    - ALU controller: Translate the instruction into control signal of ALU.
    - Barrel shifter: The circuit for shifting the input arithmetically (operator `x >>> digit`)
- Control: Component to control both ALU and register file.
- And miscellaneous circuits, such as 32bit-adder and muxer with two input.

In the following sections, I will introduce the details of implementation according to the order of stages in CPU.

### 1. Instruction Fetching

This part is composed of a program counter (PC) and a adder. `Add_PC` helps calculating `PC + 4` for each cycle. `PC` and `Instruction_Memory` are provided in source code. While wiring the clock signal `clk_i`, reset bit `rst_i`, input/out pins correctly, this part can fetch machine code sequentially.

Notes that because the CPU is single-staged, without branching instructions. It is not necessary to support either PC setting or stalling. I leave it simple here.

### 2. Instruction Decoding

After fetched instructions from I-mem, the CPU can start to decode the instruction and pre-fetch the values from register files. `Registers` is provided in source code, I just need to wire the ports correctly. `Control` reads `opcode` from instruction, and determines 3 control signal: `ALUOp`, `ALUSrc` and `RegWrite`.

Observe that we only need to support arithmetic operations, all of them writes the result back to register file. Therefore, `RegWrite` is always `1` here for simplicity. Then, we can determine the source of operand 2 by inverting `opcode[5]`. Finally, there are only 2-bit different in `opcode[5:4]`, so I send these 2 bits to output for determining operation of ALU with other fields in instruction.

`Sign_Extend` reads the immediates with 12-bits length in instruction, then clone its most significant bit to make it as a 32-bit length word. `MUX_ALUSrc` selects the source of the operand 2 from either register file or immediates according to the control signal `ALUSrc`.

Because the CPU in this experiment support only the arithmetic operations, they always read operands from register file, and the result must be written back to register file. This part is simply setting control signal `RegWrite` as `1`, and wiring the output of ALU to the port `RDdata_i` in register file.

### 3. Execution (Arithmetic Operations)

`ALU_Control` reads `ALUOp`, `funct7` and `funct3` as input, and output `ALUControl`. The relation between input and output is illustrated in the following figure.

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

For `ALU`, all of the operations needed in ISA are implemented, then use a `casez` to select the output according to current instruction. Furthermore, I implemented a module `Barrel Shifter` for `srai`. Notes that the syntax of don't care bits is also support by `casez` in Verilog.

### 4. Writing Back

As mentioned in Section: Instruction Decoding, the CPU always write the result of arithmetic operations back to register. Here the output of ALU is wired to port `RDdata_i` in register file.

## Development Environment

OS Environment

```
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
```

Iverilog version: Icarus Verilog version 11.0 (stable)
