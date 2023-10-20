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

// Implementation
wire [31:0]             bitwise_and;
wire [31:0]             bitwise_xor;
wire [31:0]             bitwise_add;
wire [31:0]             bitwise_sll;
wire [31:0]             bitwise_sub;
wire [31:0]             bitwise_mul;
wire [31:0]             bitwise_srl;

assign bitwise_and[31:0] = in0 & in1;
assign bitwise_xor[31:0] = in0 ^ in1;

Adder Adder(
    in0, in1, bitwise_add
);

assign bitwise_sll = 32'b0;
assign bitwise_sub = 32'b0;
assign bitwise_mul = 32'b0;
assign bitwise_srl = 32'b0;

MUX32_8x1 Mux(
    bitwise_and,
    bitwise_xor,
    bitwise_sll,
    bitwise_add,
    bitwise_sub,
    bitwise_mul,
    bitwise_srl,
    0,
    op,
    out
);

endmodule
