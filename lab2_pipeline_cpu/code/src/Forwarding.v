module Forwarding
(
    EX_Rs1,
    EX_Rs2,
    MEM_RegWrite,
    MEM_Rd,
    // MEM_ALUResult,
    WB_RegWrite,
    WB_Rd,
    // WB_WriteData,
    ForwardA,
    ForwardB,
);

// Interface
input  [4:0] EX_Rs1;
input  [4:0] EX_Rs2;
input        MEM_RegWrite;
input  [4:0] MEM_Rd;
// input [31:0] MEM_ALUResult;
input        WB_RegWrite;
input  [4:0] WB_Rd;
// input [31:0] WB_WriteData;

output [1:0] ForwardA;
output [1:0] ForwardB;

// TODO: Implementation
assign ForwardA = 2'b00;
assign ForwardB = 2'b00;

endmodule
