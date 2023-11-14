module IF2ID_Register
(
    clk_i,
    rst_i,

    pc_i,
    stall,
    instruction_i,

    pc_o,
    instruction_o
);

// Interface
input               clk_i;
input               rst_i;
input  [31:0]       instruction_i;
input               stall;
input  [31:0]       pc_i;

output [31:0]       instruction_o;
output [31:0]       pc_o;

// Register File
reg    [31:0]       instruction = 32'b0;
reg    [31:0]       pc = 32'b0;

// Read Data
assign instruction_o = instruction;
assign pc_o = pc;

always@(posedge clk_i or negedge rst_i) begin
    if (~stall) begin
        if (~rst_i) begin
            instruction <= 32'b0;
            pc <= 32'b0;
        end
        else begin
            instruction <= instruction_i;
            pc <= pc_i;
        end
    end
end

endmodule

module ID2EX_Register
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    instruction_i,
    imm_ext_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    instruction_o,
    imm_ext_o,
);

// Interface
input               clk_i;
input               rst_i;

input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input  [2:0]        ALUOp_i;
input               ALUSrc_i;
input  [31:0]       RS1data_i;
input  [31:0]       RS2data_i;
input  [31:0]       instruction_i;
input  [31:0]       imm_ext_i;

output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output [2:0]        ALUOp_o;
output              ALUSrc_o;
output [31:0]       RS1data_o;
output [31:0]       RS2data_o;
output [31:0]       instruction_o;
output [31:0]       imm_ext_o;

// Register File
reg                 RegWrite = 1'b0;
reg                 MemtoReg = 1'b0;
reg                 MemRead  = 1'b0;
reg                 MemWrite = 1'b0;
reg  [2:0]          ALUOp;
reg                 ALUSrc   = 1'b0;
reg  [31:0]         RS1data = 32'b0;
reg  [31:0]         RS2data = 32'b0;
reg  [31:0]         instruction = 32'b0;
reg  [31:0]         imm_ext = 32'b0;

// Read Data
assign    RegWrite_o = RegWrite;
assign    MemtoReg_o = MemtoReg;
assign     MemRead_o = MemRead;
assign    MemWrite_o = MemWrite;
assign       ALUOp_o = ALUOp;
assign      ALUSrc_o = ALUSrc;
assign     RS1data_o = RS1data;
assign     RS2data_o = RS2data;
assign instruction_o = instruction;
assign     imm_ext_o = imm_ext;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        ALUOp <= 2'b0;
        ALUSrc <= 1'b0;
        RS1data <= 32'b0;
        RS2data <= 32'b0;
        instruction <= 32'b0;
        imm_ext <= 32'b0;
    end
    else begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        ALUOp <= ALUOp_i;
        ALUSrc <= ALUSrc_i;
        RS1data <= RS1data_i;
        RS2data <= RS2data_i;
        instruction <= instruction_i;
        imm_ext <= imm_ext_i;
    end
end

endmodule

module EX2MEM_Register
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUResult_i,
    RS2data_i,
    RD_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUResult_o,
    RS2data_o,
    RD_o,
);

// Interface
input               clk_i;
input               rst_i;
input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input [31:0]        ALUResult_i;
input [31:0]        RS2data_i;
input  [4:0]        RD_i;

// Output
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output [31:0]       ALUResult_o;
output [31:0]       RS2data_o;
output  [4:0]       RD_o;

// Register File
reg                 RegWrite = 1'b0;
reg                 MemtoReg = 1'b0;
reg                 MemRead = 1'b0;
reg                 MemWrite = 1'b0;
reg    [31:0]       ALUResult = 32'b0;
reg    [31:0]       RS2data = 32'b0;
reg     [4:0]       RD = 5'b0;

// Read Data
assign  RegWrite_o = RegWrite;
assign  MemtoReg_o = MemtoReg;
assign   MemRead_o = MemRead;
assign  MemWrite_o = MemWrite;
assign ALUResult_o = ALUResult;
assign   RS2data_o = RS2data;
assign        RD_o = RD;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        ALUResult <= 32'b0;
        RS2data <= 32'b0;
        RD <= 5'b0;
    end
    else begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        ALUResult <= ALUResult_i;
        RS2data <= RS2data_i;
        RD <= RD_i;
    end
end

endmodule

module MEM2WB_Register
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    ReadData_i,
    RD_i,

    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    ReadData_o,
    RD_o,
);

// Interface
input               clk_i;
input               rst_i;
input               RegWrite_i;
input               MemtoReg_i;
input  [31:0]       ALUResult_i;
input  [31:0]       ReadData_i;
input  [4:0]        RD_i;

// Output
output              RegWrite_o;
output              MemtoReg_o;
output [31:0]       ALUResult_o;
output [31:0]       ReadData_o;
output  [4:0]       RD_o;

// Register File
reg                 RegWrite = 1'b0;
reg                 MemtoReg = 1'b0;
reg    [31:0]       ALUResult = 32'b0;
reg    [31:0]       ReadData = 32'b0;
reg     [4:0]       RD = 5'b0;

// Read Data
assign  RegWrite_o = RegWrite;
assign  MemtoReg_o = MemtoReg;
assign ALUResult_o = ALUResult;
assign  ReadData_o = ReadData;
assign        RD_o = RD;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite <= 1'b0;
        MemtoReg <= 1'b0;
        ALUResult <= 32'b0;
        ReadData <= 32'b0;
        RD <= 5'b0;
    end
    else begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        ALUResult <= ALUResult_i;
        ReadData <= ReadData_i;
        RD <= RD_i;
    end
end

endmodule
