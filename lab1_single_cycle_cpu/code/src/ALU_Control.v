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

// Spec:
// ALUControl is determined by ALUOp and funct7 and funct3.
//
// | function |  funct7  | funct3 |
// | :------: | :------: | :----: |
// |    and   | 0000000  |  111   |
// |    xor   | 0000000  |  100   |
// |    sll   | 0000000  |  001   |
// |    add   | 0000000  |  000   |
// |    sub   | 0100000  |  000   |
// |    mul   | 0000001  |  000   |
// |   addi   |    -     |  000   |
// |   srai   | 0100000  |  101   |


// Implementation
assign ALUControl = 0;

endmodule
