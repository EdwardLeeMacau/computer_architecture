module Forwarding
(
    EX_Rs1,
    EX_Rs2,
    MEM_RegWrite,
    MEM_Rd,
    WB_RegWrite,
    WB_Rd,
    ForwardA,
    ForwardB,
);

// Interface
input  [4:0] EX_Rs1;
input  [4:0] EX_Rs2;
input        MEM_RegWrite;
input  [4:0] MEM_Rd;
input        WB_RegWrite;
input  [4:0] WB_Rd;

output [1:0] ForwardA;
output [1:0] ForwardB;

// Implementation
assign ForwardA = MEM_RegWrite && (MEM_Rd != 0) && (MEM_Rd == EX_Rs1) ? 2'b10 :
                  WB_RegWrite  && (WB_Rd  != 0) && ~(MEM_RegWrite && (MEM_Rd != 0) && (MEM_Rd == EX_Rs1)) && (WB_Rd == EX_Rs1) ? 2'b01 :
                  2'b00;
assign ForwardB = MEM_RegWrite && (MEM_Rd != 0) && (MEM_Rd == EX_Rs2) ? 2'b10 :
                  WB_RegWrite  && (WB_Rd  != 0) && ~(MEM_RegWrite && (MEM_Rd != 0) && (MEM_Rd == EX_Rs2)) && (WB_Rd == EX_Rs2) ? 2'b01 :
                  2'b00;

endmodule
