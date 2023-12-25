module CPU
(
    clk_i,
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

// Program Counter
wire [31:0]         nextPC;
wire                pc_sel;

// ALU
wire [31:0]         in0;
wire [31:0]         in1;
wire [31:0]         fw1;

// Wire outputs
wire [31:0]         WB_data;

// =============================================================================
// Instruction Fetch
// =============================================================================

assign pc_sel = (Control.Branch_o & branch_predictor.predict_o) | branch_predictor.mispredict;
assign nextPC = pc_sel ? branch_predictor.dest_o : (PC.pc_o + 4);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(Hazard_Detection.PCWrite),
    .pc_i(nextPC)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o)
);

IF2ID_Register IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .pc_i(PC.pc_o),
    .stall(Hazard_Detection.Stall_o),
    .flush_i(branch_predictor.flush_IF_ID_o),
    .instruction_i(Instruction_Memory.instr_o)
);

// =============================================================================
// Instruction Decode
// =============================================================================

Hazard_Detection Hazard_Detection(
    .ID_Rs1(IF_ID.instruction_o[19:15]),
    .ID_Rs2(IF_ID.instruction_o[24:20]),
    .EX_Rd(ID_EX.instruction_o[11:7]),
    .EX_MemRead(ID_EX.MemRead_o)
);

Control Control(
    .opcode(IF_ID.instruction_o[6:0]),
    .nop(Hazard_Detection.NoOp)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(IF_ID.instruction_o[19:15]),
    .RS2addr_i(IF_ID.instruction_o[24:20]),
    .RDaddr_i(MEM_WB.RD_o),
    .RDdata_i(WB_data),
    .RegWrite_i(MEM_WB.RegWrite_o)
);

ImmGen ImmGen(
    .instruction(IF_ID.instruction_o)
);

Branch_Predictor branch_predictor(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .branch_i(Control.Branch_o),
    .equal_i(ALU.zero),
    .pc_i(IF_ID.pc_o),
    .imm(ImmGen.out)
);

ID2EX_Register ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(Control.RegWrite),
    .MemtoReg_i(Control.MemtoReg),
    .MemRead_i(Control.MemRead),
    .MemWrite_i(Control.MemWrite),
    .ALUOp_i(Control.ALUOp),
    .ALUSrc_i(Control.ALUSrc),
    .Branch_i(Control.Branch_o),
    .RS1data_i(Registers.RS1data_o),
    .RS2data_i(Registers.RS2data_o),
    .instruction_i(IF_ID.instruction_o),
    .imm_ext_i(ImmGen.out),
    .flush_i(branch_predictor.flush_ID_EX_o)
);

// =============================================================================
// Execute
// =============================================================================

Forwarding Forwarding(
    .EX_Rs1(ID_EX.instruction_o[19:15]),
    .EX_Rs2(ID_EX.instruction_o[24:20]),
    .MEM_RegWrite(EX_MEM.RegWrite_o),
    .MEM_Rd(EX_MEM.RD_o),
    .WB_RegWrite(MEM_WB.RegWrite_o),
    .WB_Rd(MEM_WB.RD_o)
);

ALU_Control ALU_Control(
    .ALUOp(ID_EX.ALUOp),
    .funct7(ID_EX.instruction_o[31:25]),
    .funct3(ID_EX.instruction_o[14:12])
);

assign in0 = (Forwarding.ForwardA == 2'b00) ? ID_EX.RS1data_o :
             (Forwarding.ForwardA == 2'b01) ? WB_data :
             (Forwarding.ForwardA == 2'b10) ? EX_MEM.ALUResult_o :
             32'h0;

assign fw1 = (Forwarding.ForwardB == 2'b00) ? ID_EX.RS2data_o :
             (Forwarding.ForwardB == 2'b01) ? WB_data :
             (Forwarding.ForwardB == 2'b10) ? EX_MEM.ALUResult_o :
             32'h0;
assign in1 = (ID_EX.ALUSrc_o == 1'b1) ? ID_EX.imm_ext_o : fw1;

ALU ALU(
    .in0(in0),
    .in1(in1),
    .op(ALU_Control.out)
);

EX2MEM_Register EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(ID_EX.RegWrite_o),
    .MemtoReg_i(ID_EX.MemtoReg_o),
    .MemRead_i(ID_EX.MemRead_o),
    .MemWrite_i(ID_EX.MemWrite_o),
    .ALUResult_i(ALU.data_o),
    .RS2data_i(fw1),
    .RD_i(ID_EX.instruction_o[11:7])
);

// =============================================================================
// Memory Access
// =============================================================================

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(EX_MEM.ALUResult_o),
    .MemRead_i(EX_MEM.MemRead_o),
    .MemWrite_i(EX_MEM.MemWrite_o),
    .data_i(EX_MEM.RS2data_o)
);

MEM2WB_Register MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .RegWrite_i(EX_MEM.RegWrite_o),
    .MemtoReg_i(EX_MEM.MemtoReg_o),
    .ALUResult_i(EX_MEM.ALUResult_o),
    .ReadData_i(Data_Memory.data_o),
    .RD_i(EX_MEM.RD_o)
);

// =============================================================================
// Write Back
// =============================================================================

assign WB_data = (MEM_WB.MemtoReg_o) ? MEM_WB.ReadData_o : MEM_WB.ALUResult_o;

endmodule

