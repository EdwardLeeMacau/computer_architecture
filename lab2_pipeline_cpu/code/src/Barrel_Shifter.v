module Barrel_Shifter
(
    in,
    shamt,
    out
);

// Interface
input [31:0] in;
input [4:0] shamt;
input [31:0] out;

// Spec:
// Barrel shifter is used to implement srai.

// Implementation
wire [31:0] r16_i;
wire [31:0] r16_o;
wire [31:0] r8_i;
wire [31:0] r8_o;
wire [31:0] r4_i;
wire [31:0] r4_o;
wire [31:0] r2_i;
wire [31:0] r2_o;
wire [31:0] r1_i;
wire [31:0] r1_o;

assign r16_i = in >>> 16;
MUX32 mux16(
    .in0(in),
    .in1(r16_i),
    .sel(shamt[4]),
    .out(r16_o)
);

assign r8_i = r16_o >>> 8;
MUX32 mux8(
    .in0(r16_o),
    .in1(r8_i),
    .sel(shamt[3]),
    .out(r8_o)
);

assign r4_i = r8_o >>> 4;
MUX32 mux4(
    .in0(r8_o),
    .in1(r4_i),
    .sel(shamt[2]),
    .out(r4_o)
);

assign r2_i = r4_o >>> 2;
MUX32 mux2(
    .in0(r4_o),
    .in1(r2_i),
    .sel(shamt[1]),
    .out(r2_o)
);

assign r1_i = r2_o >>> 1;
MUX32 mux1(
    .in0(r2_o),
    .in1(r1_i),
    .sel(shamt[0]),
    .out(r1_o)
);

assign out = r1_o;

endmodule