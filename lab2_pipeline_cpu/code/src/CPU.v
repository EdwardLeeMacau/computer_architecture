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

// Control outputs
wire                ID_FlushIF;

// Register outputs
wire [31:0]         RS2data;

// Wire outputs
wire [31:0]         WB_data;

// =============================================================================
// Instruction Fetch
// =============================================================================

Adder Add_PC(
    .in0(pc_o),
    .in1(4),
    .out(adder_out)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(1'b1),
    .pc_i(adder_out),
    .pc_o(pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(pc_o)
);

IF2ID_Register RegID(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .pc_i(pc_o),
    .instruction_i(Instruction_Memory.instr_o)
);

// =============================================================================
// Instruction Decode
// =============================================================================

Control Control(
    .opcode(RegID.instruction_o[6:0])
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(RegID.instruction_o[19:15]),
    .RS2addr_i(RegID.instruction_o[24:20]),
    .RDaddr_i(RegWB.RD_o),
    .RDdata_i(WB_data),
    .RegWrite_i(RegWB.RegWrite_o)
);

assign ID_FlushIF = Control.Branch_o & (Registers.RS1data_o == RS2data);

// TODO: Modification
Sign_Extend Sign_Extend(
    .instruction(RegID.instruction_o)
);

ID2EX_Register RegEX(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(Control.RegWrite),
    .MemtoReg_i(Control.MemtoReg),
    .MemRead_i(Control.MemRead),
    .MemWrite_i(Control.MemWrite),
    .ALUOp_i(Control.ALUOp),
    .ALUSrc_i(Control.ALUSrc),
    .RS1data_i(Registers.RS1data_o),
    .RS2data_i(Registers.RS2data_o),
    .instruction_i(RegID.instruction_o),
    .imm_ext_i(Sign_Extend.imm_ext)
);

// =============================================================================
// Execute
// =============================================================================

Forwarding Forwarding(
    .EX_Rs1(RegEX.instruction_o[19:15]),
    .EX_Rs2(RegEX.instruction_o[24:20]),
    .MEM_RegWrite(RegMEM.RegWrite_o),
    .MEM_Rd(RegMEM.RD_o),
    .WB_RegWrite(RegWB.RegWrite_o),
    .WB_Rd(RegWB.RD_o)
);

ALU_Control ALU_Control(
    .ALUOp(RegEX.ALUOp),
    .funct7(RegEX.instruction_o[31:25]),
    .funct3(RegEX.instruction_o[14:12])
);

wire [31:0] in0;
wire [31:0] fw1;
wire [31:0] in1;

assign in0 = (Forwarding.ForwardA == 2'b00) ? RegEX.RS1data_o :
             (Forwarding.ForwardA == 2'b01) ? WB_data :
             (Forwarding.ForwardA == 2'b10) ? RegMEM.ALUResult_o :
             32'h0;

assign fw1 = (Forwarding.ForwardB == 2'b00) ? RegEX.RS2data_o :
             (Forwarding.ForwardB == 2'b01) ? WB_data :
             (Forwarding.ForwardB == 2'b10) ? RegMEM.ALUResult_o :
             32'h0;
assign in1 = (RegEX.ALUSrc_o == 1'b1) ? RegEX.imm_ext_o : fw1;

ALU ALU(
    .in0(in0),
    .in1(in1),
    .op(ALU_Control.out)
);

EX2MEM_Register RegMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(RegEX.RegWrite_o),
    .MemtoReg_i(RegEX.MemtoReg_o),
    .MemRead_i(RegEX.MemRead_o),
    .MemWrite_i(RegEX.MemWrite_o),
    .ALUResult_i(ALU.out),
    .RS2data_i(fw1),
    .RD_i(RegEX.instruction_o[11:7])
);

// =============================================================================
// Memory Access
// =============================================================================

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(RegMEM.ALUResult_o),
    .MemRead_i(RegMEM.MemRead_o),
    .MemWrite_i(RegMEM.MemWrite_o),
    .data_i(RegMEM.RS2data_o)
);

MEM2WB_Register RegWB(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(RegMEM.RegWrite_o),
    .MemtoReg_i(RegMEM.MemtoReg_o),
    .ALUResult_i(RegMEM.ALUResult_o),
    .ReadData_i(Data_Memory.data_o),
    .RD_i(RegMEM.RD_o)
);

// =============================================================================
// Write Back
// =============================================================================

assign WB_data = (RegWB.MemtoReg_o) ? RegWB.ReadData_o : RegWB.ALUResult_o;

endmodule

