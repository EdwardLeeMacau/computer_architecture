module Hazard_Detection
(
    input  [4:0]    ID_Rs1,
    input  [4:0]    ID_Rs2,
    input  [4:0]    EX_Rd,
    input           EX_MemRead,

    output          PCWrite,
    output          Stall_o,
    output          NoOp
);

// Implementation
assign Stall_o = (EX_MemRead && (EX_Rd == ID_Rs1) | (EX_Rd == ID_Rs2));
assign PCWrite = ~Stall_o;
assign    NoOp = Stall_o;

endmodule