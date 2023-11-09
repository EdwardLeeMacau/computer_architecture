module Hazard_Detection
(
    // EX2MEM_RegWrite,
    // EX2MEM_Rd,
    // MEM2WB_RegWrite,
    // MEM2WB_Rd,
    // ID2EX_MemRead,
    // ID2EX_Rs1,
    // ID2EX_Rs2,
    // ID2EX_RegWrite,
    // ID2EX_Rd,
    PCWrite,
    Stall_o,
    NoOp
);

// Interface
output PCWrite;
output Stall_o;
output NoOp;

// TODO: Implementation
assign PCWrite = 1'b0;
assign Stall = 1'b0;
assign NoOp = 1'b0;

endmodule