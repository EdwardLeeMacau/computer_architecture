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
