module IF2ID_Register
(
    input               clk_i,
    input               rst_i,
    input  [31:0]       instruction_i,
    input               stall,
    input               flush,
    input  [31:0]       pc_i,

    output [31:0]       instruction_o,
    output [31:0]       pc_o
);

// Register File
reg    [31:0]       instruction = 32'b0;
reg    [31:0]       pc = 32'b0;

// Read Data
assign instruction_o = instruction;
assign pc_o = pc;

always@(posedge clk_i or negedge rst_i) begin
    if (~stall) begin
        if (~rst_i | flush) begin
            instruction <= 32'b0;
            pc <= 32'b0;
        end
        else begin
            instruction <= instruction_i;
            pc <= pc_i;
        end
    end
end

endmodule
