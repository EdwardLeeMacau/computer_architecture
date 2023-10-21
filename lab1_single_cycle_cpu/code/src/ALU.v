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
reg [31:0] y;
always @(in0 or in1 or op) begin
    case (op)
        3'b000: y = in0 + in1;
        3'b001: y = in0 - in1;
        3'b010: y = in0 * in1;
        3'b011: y = 0;
        3'b100: y = in0 & in1;
        3'b101: y = in0 | in1;
        3'b110: y = in0 << in1;
        3'b111: y = in0 >>> in1;
    endcase
end

assign out = y;
assign zero = (out == 0);

endmodule
