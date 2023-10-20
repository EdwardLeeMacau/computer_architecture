module CPU
(
    clk_i,
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

// Wires
wire [31:0]         adder_out;
wire [31:0]         pc_o;
wire [31:0]         instruction;

// Control outputs
wire [1:0]          ALUOp;
wire                ALUSrc;
wire                RegWrite;

// SignExtend outputs
wire [31:0]         imm_ext;

// Register outputs
wire [31:0]         RS1data;
wire [31:0]         RS2data;

// Muxer outputs
wire [31:0]         ALUin1;

// ALU_Control outputs
wire [2:0]          ALUControl_o;

// ALU outputs
wire                ALUZero;
wire [31:0]         ALUResult;

Control Control(
    .opcode(instruction[6:0]),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

Adder Add_PC(
    .in0(pc_o),
    .in1(4),
    .out(adder_out)
);

PC PC(
    clk_i, rst_i, adder_out, pc_o
);

Instruction_Memory Instruction_Memory(
    pc_o, instruction
);

Registers Registers(
    rst_i, clk_i, instruction[19:15], instruction[24:20], instruction[11:7], ALUResult, RegWrite, RS1data, RS2data
);

MUX32 MUX_ALUSrc(
    RS2data, imm_ext, ALUSrc, ALUin1
);

Sign_Extend Sign_Extend(
    instruction[31:20], imm_ext
);

ALU ALU(
    RS1data, ALUin1, ALUControl_o, ALUZero, ALUResult
);

ALU_Control ALU_Control(
    ALUOp, instruction[31:25], instruction[14:12], ALUControl_o
);

endmodule

