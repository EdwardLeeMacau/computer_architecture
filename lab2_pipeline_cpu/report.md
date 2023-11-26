# Report - Lab2 Pipeline CPU

## Modules Explanation

Extending from Lab1, the following components are added to support pipelining and extra instructions:

- **Forwarding**: Detects EX/MEM hazard, and forward the value to ALU if needed.
- **Hazard detector**: Helps to detect data hazard and control hazard
    - Indicates signal *Stall* when data hazard caused by load instr. is occurred.
    - Indicates signal *Flush* when control hazard caused by branching instr. is occurred.
- Pipeline registers: 4 distinct pipeline stage registers are implemented.
- **Control**: Extended to decode extra instructions.
- **ImmGen**: Modified from **Sign_Extend** to extract immediates from S-Type, B-Type or I-Type instructions.

The following sections introduce what is modified according to the order of pipeline stages. Note that the syntax `STAGE.value` is used to represent some of the values taken from other stages. For example: `EX.MemRead` means the control signal `MemRead` stored in register **ID/EX Register**.

### 1. Instruction Fetching

To handle data hazards and new instr. `beq`, the module **PC** supports

1. Running/stalling via setting `write_i` to 1/0,
2. Select to feed either `PC + 4` or the target address of branching instr. to `pc_i` by a muxer.

Then, both the value of **PC** and the instr. are sent to **IF/ID Register**. Note that `write_i` and the selector of the muxer, are determined in the next pipeline stage. See the next section for details.

### 2. Instruction Decoding

The module **Registers** receives inputs `RS1addr` and `RS2addr` from **IF/ID Register**. Also, to support `lw`, `sw` and `beq`, the module **Control** reads `opcode` from instr., and determines control signals. The i/o relation of this module is illustrated in the following table.

| `opcode[6:0]` |     Meaning     | RegWrite | MemtoReg | MemRead | MemWrite |     ALUOp     | ALUSrc | Branch |
| :-----------: | :-------------: | :------: | :------: | :-----: | :------: | :-----------: | :----: | :----: |
|    0110011    | Arithmetic ops. |    1     |    0     |    0    |    0     | `opcode[6:4]` |   0    |   0    |
|    0010011    | Arithmetic imm. |    1     |    0     |    0    |    0     | `opcode[6:4]` |   1    |   0    |
|    0000011    |      Load       |    1     |    1     |    1    |    0     | `opcode[6:4]` |   1    |   0    |
|    0100011    |      Store      |    0     |    0     |    0    |    1     | `opcode[6:4]` |   1    |   0    |
|    1100011    |     Branch      |    0     |    0     |    0    |    0     | `opcode[6:4]` |   *    |   1    |

Note that the control signal `MemRead` is used for detecting hazard. Therefore, it should be 0 when the instr. is not `lw`, even `MemtoReg` or `RegWrite` is set as 0 for other instructions.

**ImmGen** reads instr., and evaluates whether it is S-Type, B-Type, or I-Type by checking its opcode. Then extract the immediate and form it as 32-bit values.

The module **Hazard Detection** raises the flag *Stall* if both `EX.MemRead` is 1 and `EX.RDaddr` equals to either `ID.RS1addr` or `ID.RS2addr`.

To execute branch instr. `beq` earlier, it is needed to check whether the branching condition is satisfied in stage ID. This is implemented by checking if `Branch` is raised, and `RS1data` equals to `RS2data`. If the branching condition is fulfilled, the target of nextPC is set as branching target (refer to Sec. 1 for detailed information), and a signal *flush* is send to **IF/ID Register** to flush the instr.

The values read from registers, control signals, intermediates, and instructions are sent to **ID/EX Register**.

### 3. Execution

Notes that to resolve EX/MEM hazard, a forwarding module is needed to forward the execution result from EX/MEM stages to ALU. The impl. of module **Forwarding** is based on the source code provided in spec (Listing 1 and 2, Lab2 spec).

The module **ALU_Control** reads `ALUOp`, `funct7`, and `funct3` as inputs, and outputs a 3-bit integer to indicate which arithmetic operations ALU should do. The i/o relation of this module is illustrated in the following table.

|  funct7   | funct3 | ALUOp |  {func, ALUOP}  | function | operations |
| :-------: | :----: | :---: | :-------------: | :------: | :--------: |
| `xxxxxxx` | `010`  | `000` | `xxxxxxx010000` |    lw    |    `+`     |
| `xxxxxxx` | `010`  | `010` | `xxxxxxx010010` |    sw    |    `+`     |
| `xxxxxxx` | `000`  | `001` | `xxxxxxx000001` |   addi   |    `+`     |
| `0000000` | `000`  | `011` | `0000000000011` |   add    |    `+`     |
| `0100000` | `000`  | `011` | `0100000000011` |   sub    |    `-`     |
| `0000000` | `111`  | `011` | `0000000111011` |   and    |    `&`     |
| `0000000` | `100`  | `011` | `0000000100011` |   xor    |    `^`     |
| `0000000` | `001`  | `011` | `0000000001011` |   sll    |    `<<`    |
| `0100000` | `101`  | `001` | `0100000101001` |   srai   |   `>>>`    |
| `0000001` | `000`  | `011` | `0000001000011` |   mul    |    `*`     |
| `xxxxxxx` | `000`  | `110` | `xxxxxxx000110` |   beq    | DONT care  |

Because the arithmetic operations for module **ALU** are not changed, its design is kept the same as Lab1. Then the result of module **ALU**, `RS2data`, control signals, and `EX.RDaddr` are sent to **EX/MEM Register**.

### 4. Memory

While wiring the ports correctly, the instr. `lw` and `sw` can be executed. The result of ALU, value of ReadData, and control signal are sent to `MEM/WB Register`.

### 5. Writing Back

Finally, the result of instr. is determined in this stage. `WB.RDdata` and `WB.RDaddr` are fed to **Registers**. `WB.RegWrite` determines if the result should be stored in module **Registers**.

## Difficulties Encountered and Solutions in This Lab

- A register initialization bug.
I want to implement the components with as less as possible logic gates. The first version of the module **Control** determines `MemRead` by `opcode[6:4]` only. With the initial value 0 of the registers in my implementation, there is an unexpected *stall* between the first and second instr. Since the signal *stall* is raised because of the design of the logic circuit and initial value of the registers. To avoid the problem, I decided to check `opcode[0]` also for memRead.
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
