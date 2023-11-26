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
wire signed [31:0]  ALUResult;

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
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(adder_out),
    .pc_o(pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(pc_o),
    .instr_o(instruction)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(instruction[19:15]),
    .RS2addr_i(instruction[24:20]),
    .RDaddr_i(instruction[11:7]),
    .RDdata_i(ALUResult),
    .RegWrite_i(RegWrite),
    .RS1data_o(RS1data),
    .RS2data_o(RS2data)
);

MUX32 MUX_ALUSrc(
    .in0(RS2data),
    .in1(imm_ext),
    .sel(ALUSrc),
    .out(ALUin1)
);

Sign_Extend Sign_Extend(
    .imm(instruction[31:20]),
    .imm_ext(imm_ext)
);

ALU ALU(
    .in0(RS1data),
    .in1(ALUin1),
    .op(ALUControl_o),
    .zero(ALUZero),
    .out(ALUResult)
);

ALU_Control ALU_Control(
    .ALUOp(ALUOp),
    .funct7(instruction[31:25]),
    .funct3(instruction[14:12]),
    .ALUControl(ALUControl_o)
);

endmodule

