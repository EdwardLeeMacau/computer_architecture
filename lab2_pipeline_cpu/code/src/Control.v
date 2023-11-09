module Control
(
    opcode,
    ALUOp,
    ALUSrc,
    RegWrite,
    Branch_o,
);

// Interface
input [6:0] opcode;

output [1:0] ALUOp;
output ALUSrc;
output RegWrite;
output Branch_o;

// Spec:
// Only 0b'0110011 (R-type) or 0b'0010011 (I-type) is expected to be used in this lab.
//
// ALUOp: not specified
// ALUSrc is determined by opcode[5].
// RegWrite: TODO.
// Branch_o: TODO

// TODO: Implementation
assign ALUOp = opcode[5:4];
assign ALUSrc = ~opcode[5];
assign RegWrite = 1;
assign Branch_o = 0;

endmodule
