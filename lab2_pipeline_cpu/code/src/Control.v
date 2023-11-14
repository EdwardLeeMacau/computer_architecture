module Control
(
    opcode,
    nop,
    RegWrite,
    MemtoReg,
    MemRead,
    MemWrite,
    ALUOp,
    ALUSrc,
    Branch_o,
);

// Interface
input  [6:0]    opcode;
input           nop;

output          RegWrite;
output          MemtoReg;
output          MemRead;
output          MemWrite;
output [2:0]    ALUOp;
output          ALUSrc;
output          Branch_o;

// Spec:
//
// RegWrite (    ): x00xxxx, x01xxxx, x11xxxx
// MemtoReg ( lw ): x00xxxx
//  MemRead ( lw ): x00xxxx
// MemWrite ( sw ): 010xxxx
//    ALUOp (    ):
//   ALUSrc (    ): x00xxxx, x01xxxx, x10xxxx
// Branch_o (    ): 1xxxxxx

wire    PowerOn = opcode[1] & opcode[0];

assign RegWrite = (~PowerOn | nop) ? 0 :              ~opcode[5] |  opcode[4];
assign MemtoReg = (~PowerOn | nop) ? 0 : ~opcode[6] & ~opcode[5] & ~opcode[4];
assign  MemRead = (~PowerOn | nop) ? 0 : ~opcode[6] & ~opcode[5] & ~opcode[4];
assign MemWrite = (~PowerOn | nop) ? 0 : ~opcode[6] &  opcode[5] & ~opcode[4];
assign    ALUOp = (~PowerOn | nop) ? 0 : opcode[6:4];
assign   ALUSrc = (~PowerOn | nop) ? 0 :              ~opcode[5] | ~opcode[4];
assign Branch_o = (~PowerOn | nop) ? 0 :  opcode[6];

endmodule
