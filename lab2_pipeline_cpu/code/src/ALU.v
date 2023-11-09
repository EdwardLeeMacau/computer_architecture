`define OP_ADD 3'b000
`define OP_SUB 3'b001
`define OP_MUL 3'b010
`define OP_DIV 3'b011
`define OP_AND 3'b100
`define OP_XOR 3'b101
`define OP_SLL 3'b110
`define OP_SRA 3'b111

module ALU
(
    in0,
    in1,
    op,
    zero,
    out
);

// Interface
input [31:0] in0;
input [31:0] in1;
input [2:0] op;

output zero;
output [31:0] out;

// Implementation:
//
// ALU designed by case statement
// Reference: https://programmermagazine.github.io/201310/htm/article4.html
wire [4:0] imm;
wire [31:0] srai_o;
assign imm = in1[4:0];              // for srai

Barrel_Shifter shifter(
    .in(in0),
    .shamt(imm),
    .out(srai_o)
);

reg [31:0] y;
always @(in0 or in1 or op or srai_o) begin
    case (op)
        `OP_ADD: y = in0 + in1;
        `OP_SUB: y = in0 - in1;
        `OP_MUL: y = in0 * in1;
        `OP_DIV: y = 32'bx;
        `OP_AND: y = in0 & in1;
        `OP_XOR: y = in0 ^ in1;
        `OP_SLL: y = in0 << in1;
        `OP_SRA: y = srai_o;
    endcase
end

assign out = y;
assign zero = (out == 0);

endmodule
