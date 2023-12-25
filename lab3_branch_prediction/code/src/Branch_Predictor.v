module Branch_Predictor
(
    input               clk_i,
    input               rst_i,
    input               branch_i,
    input [31:0]        pc_i,
    input [31:0]        imm,
    input               equal_i,
    output              predict_o,
    output [31:0]       dest_o,
    output              flush_IF_ID_o,
    output              flush_ID_EX_o
);

// Register File
reg                  branch = 1'b0;
reg  [31:0]            dest = 32'b0;
reg                 predict = 1'b0;
reg   [1:0]           state = 2'b11;

// Temporary variables
wire                  taken = branch_i & predict_o;
wire             mispredict = branch & ((predict & ~equal_i) | (~predict & equal_i));
wire [31:0]          backup;

// Read Data
assign     predict_o = state >= 2'b10;
assign        dest_o = mispredict ? dest : pc_i + imm;
assign        backup = taken ? (pc_i + 4) : (pc_i + imm);
assign flush_IF_ID_o = taken | mispredict;
assign flush_ID_EX_o =         mispredict;

always@(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        branch <= 1'b0;
        dest <= 32'b0;
        state <= 2'b11;
    end
    else begin
        branch <= branch_i;
        dest <= backup;
        predict <= predict_o;
        if (branch) begin
            if (equal_i) begin
                state <= (state == 2'b11) ? state : state + 1;
            end else begin
                state <= (state == 2'b00) ? state : state - 1;
            end
        end
    end
end


endmodule