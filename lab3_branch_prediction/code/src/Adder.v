// Spec:
// 32-bit adder without carry-in and carry-out.

module Adder
(
    input  [31:0] in0,
    input  [31:0] in1,
    output [31:0] out
);

assign out = in0 + in1;

endmodule
