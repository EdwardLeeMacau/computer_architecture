module MUX32
(
    in0,
    in1,
    sel,
    out
);

// Interface
input [31:0] in0;
input [31:0] in1;
input sel;
output [31:0] out;

// Implementation
assign out = sel ? in1 : in0;

endmodule

module MUX32_8x1
(
    in0, in1, in2, in3, in4, in5, in6, in7,
    sel,
    out
);

// Interface
input [31:0] in0;
input [31:0] in1;
input [31:0] in2;
input [31:0] in3;
input [31:0] in4;
input [31:0] in5;
input [31:0] in6;
input [31:0] in7;
input [2:0] sel;

output [31:0] out;

// Implementation
// FIXME: select proper input to out
assign out = 0;

endmodule
