module MEM2WB_Register
(
    input               clk_i,
    input               rst_i,
    input               RegWrite_i,
    input               MemtoReg_i,
    input  [31:0]       ALUResult_i,
    input  [31:0]       ReadData_i,
    input  [4:0]        RD_i,

    output              RegWrite_o,
    output              MemtoReg_o,
    output [31:0]       ALUResult_o,
    output [31:0]       ReadData_o,
    output  [4:0]       RD_o
);

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
