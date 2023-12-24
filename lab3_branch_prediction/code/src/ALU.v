`define OP_ADD 3'b000
`define OP_SUB 3'b001
`define OP_MUL 3'b010
`define OP_NOP 3'b011
`define OP_AND 3'b100
`define OP_XOR 3'b101
`define OP_SLL 3'b110
`define OP_SRA 3'b111

module ALU
(
    input  signed [31:0]   in0,
    input  signed [31:0]   in1,
    input  signed  [2:0]   op,

    output                 zero,
    output signed [31:0]   data_o
);

wire [4:0] imm;
assign imm = in1[4:0];              // for srai
assign data_o = (op == `OP_ADD) ? in0 + in1 :
                (op == `OP_SUB) ? in0 - in1 :
                (op == `OP_MUL) ? in0 * in1 :
                (op == `OP_NOP) ? 32'b0 :
                (op == `OP_AND) ? in0 & in1 :
                (op == `OP_XOR) ? in0 ^ in1 :
                (op == `OP_SLL) ? in0 << in1 :
                (op == `OP_SRA) ? $signed(in0) >>> imm :
                                  32'b0;

assign zero = (data_o == 0);

endmodule
