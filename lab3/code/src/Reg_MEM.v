module EX2MEM_Register
(
    input               clk_i,
    input               rst_i,
    input               RegWrite_i,
    input               MemtoReg_i,
    input               MemRead_i,
    input               MemWrite_i,
    input [31:0]        ALUResult_i,
    input [31:0]        RS2data_i,
    input  [4:0]        RD_i,

    output              RegWrite_o,
    output              MemtoReg_o,
    output              MemRead_o,
    output              MemWrite_o,
    output [31:0]       ALUResult_o,
    output [31:0]       RS2data_o,
    output  [4:0]       RD_o
);

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
