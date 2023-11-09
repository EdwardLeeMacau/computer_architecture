module IF2ID_Register
(
    clk_i,
    rst_i,
    pc_i,
    instruction_i,
    pc_o,
    instruction_o
);

// Interface
input               clk_i;
input               rst_i;
input [31:0]        instruction_i;
input [31:0]        pc_i;

output [31:0]       instruction_o;
output [31:0]       pc_o;

// Register File
reg [31:0]          instruction;
reg [31:0]          pc;

// Read Data
assign instruction_o = instruction;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        instruction <= 32'b0;
        pc <= 32'b0;
    end
    else begin
        instruction <= instruction_i;
        pc <= pc_i;
    end
end

endmodule

module ID2EX_Register
(

);

endmodule

module EX2MEM_Register
(

);

endmodule

module MEM2WB_Register
(

);

endmodule
