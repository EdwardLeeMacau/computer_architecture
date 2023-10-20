module ALU_Control
(
    ALUOp,
    funct7,
    funct3,
    ALUControl
);

// Interface
input [1:0] ALUOp;
input [6:0] funct7;
input [2:0] funct3;

output [2:0] ALUControl;

assign ALUControl = 0;

endmodule
