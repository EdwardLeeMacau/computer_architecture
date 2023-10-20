module Sign_Extend
(
    imm,
    imm_ext
);

// Interface
input [11:0] imm;
output [31:0] imm_ext;

// Implementation
assign imm_ext = {{20{imm[11]}}, imm};

endmodule
