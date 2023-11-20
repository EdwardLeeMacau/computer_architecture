# Report - Lab2 Pipeline CPU

## Modules Explanation

Extending from Lab1, the following components are added to support pipelining and extra instructions:

- Forwarding:
    - Detects EX/MEM hazard, and forward the value to ALU if needed.
- Hazard detector:
    - Detects data hazard caused by load instructions and indicates signal *Stall* to other components.
    - Detects control hazard caused by branching instruction and indicates signal *Flush* to other components.
- Pipeline registers:
    - Several pipeline stage registers are implemented.
- Control:
    - Extended to decode extra instructions.

The following sections will introduce what is modified according to the order of stages.

### 1. Instruction Fetching

To handle data hazards and new instruction `beq`, the module `PC` supports

1. Running/stalling via setting `write_i` to 1/0,
2. Select to feed either `PC + 4` or the target address of branching instruction to `pc_i` by a muxer.

Then, both the value of `PC` and the instruction fetched from I-mem are sent to `IF/ID Register`. Note that the value of the corresponding control signal is determined in the next stage. See the next section for details.

### 2. Instruction Decoding

The module `Registers` receives inputs `RS1addr` and `RS2addr` from `IF/ID Register`. Also, to support memRead, memWrite, and branching operations, the module `Control` reads opcode from instruction, and determines control signal: `RegWrite`, `MemtoReg`, `MemRead`, `MemWrite`, `ALUOp`, `ALUSrc` and `Branch`.

<!-- Observe that there are only 3-bit differences in `opcode[6:4]`, so they are sent to output for determining the operation of the ALU with other fields in instruction. -->

`Sign_Extend` reads the instruction, and evaluates whether it is S-Type, B-Type, or I-Type by checking its opcode. Then extract the immediate and form it as 32-bit values.

The module `Hazard Detection` raises the flag *Stall* if EX.memRead is 1, and EX.RDaddr equals to either ID.RS1addr or RS2addr.

To execute branch instruction `beq` in stage ID instead of stage EX, it is needed to check whether the branch condition is satisfied here. This is implemented by checking the control signal `Branch`, and `RS1data =?= RS2data`. If yes, a signal is needed to send to the muxer for the input `pc_i`, the value of PC should be set as the branching target, and previous instructions should be flushed.

The values from registers, control signals, intermediates, and instructions are sent to `ID/EX Register`.

### 3. Execution

Notes that to resolve EX/MEM hazard, a forwarding module is needed to forward the execution result from EX/MEM stages to ALU. The impl. of module `Forwarding` is based on the source code provided in spec (Listing 1 and 2, Lab2 spec).

The module `ALU_Control` reads `ALUOp`, `funct7`, and `funct3` as inputs, and outputs a 3-bit integer to indicate which arithmetic operations ALU should do. The i/o relation of this module is illustrated in the following table.

|  funct7   | funct3 | ALUOp |  {func, ALUOP}  | function |         operations         |
| :-------: | :----: | :---: | :-------------: | :------: | :------------------------: |
| `xxxxxxx` | `010`  | `000` | `xxxxxxx010000` |    lw    |            `+`             |
| `xxxxxxx` | `010`  | `010` | `xxxxxxx010010` |    sw    |            `+`             |
| `xxxxxxx` | `000`  | `001` | `xxxxxxx000001` |   addi   |            `+`             |
| `0000000` | `000`  | `011` | `0000000000011` |   add    |            `+`             |
| `0100000` | `000`  | `011` | `0100000000011` |   sub    |            `-`             |
| `0000000` | `111`  | `011` | `0000000111011` |   and    |            `&`             |
| `0000000` | `100`  | `011` | `0000000100011` |   xor    |            `^`             |
| `0000000` | `001`  | `011` | `0000000001011` |   sll    |            `<<`            |
| `0100000` | `101`  | `001` | `0100000101001` |   srai   |           `>>>`            |
| `0000001` | `000`  | `011` | `0000001000011` |   mul    |            `*`             |
| `xxxxxxx` | `000`  | `110` | `xxxxxxx000110` |   beq    | Never occurred in stage EX |

Because the arithmetic operations for module `ALU` are not changed, its design is kept the same as Lab1. Then the result of module `ALU`, RS2data, control signal, and RDaddr are sent to `EX/MEM Register`.

### 4. Memory

While wiring the ports correctly, the instructions `lw` and `sw` can be executed. The result of ALU, read_data, and control signal are sent to `MEM/WB Register`.

### 5. Writing Back

Finally, the result of instruction is determined in this stage. And its destination register are fed to `RDdata_i` and `RDaddr_i` of the module `Registers`. `RegWrite` determines if the result should be stored in the register file.

## Difficulties Encountered and Solutions in This Lab

- A register initialization bug.
I want to implement the components with as less as possible logic gates. The first version of the `Control` determines `memRead` by opcode[6:4] only. With the initial value of 0 in my implementation, there is an unexpected stall between the first and second instructions. Since the signal *stall* is raised because of the design of the logic circuit and initial value of the registers. To avoid the problem, I decided to check opcode[0] also for memRead.
- Cannot r/w `x0` in the same cycle. Otherwise, it leads to a bug `x0 != 0`.

## Development Environment

OS Environment

```
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
```

iverilog version: Icarus Verilog version 11.0 (stable)
