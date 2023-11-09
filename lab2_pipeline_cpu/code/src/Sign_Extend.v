module Sign_Extend
(
    instruction,
    imm_ext
);

// Interface
input  [31:0]       instruction;
output [31:0]       imm_ext;

wire   [12:0]       imm;

wire                SType;
wire                BType;

assign SType = (instruction[6:0] == 7'b0100011);
assign BType = (instruction[6:0] == 7'b1100011);
// R-Type: otherwise

assign imm = (BType) ? {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0} :
             (SType) ? {instruction[31], instruction[31:25], instruction[11:7]} :
                       {instruction[31], instruction[31:20]};

assign imm_ext = {{19{imm[12]}}, imm};

endmodule
