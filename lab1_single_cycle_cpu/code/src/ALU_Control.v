// NOTE: Repeated definition in `ALU.v`
`define OP_ADD 3'b000
`define OP_SUB 3'b001
`define OP_MUL 3'b010
`define OP_DIV 3'b011
`define OP_AND 3'b100
`define OP_XOR 3'b101
`define OP_SLL 3'b110
`define OP_SRA 3'b111

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
// |  funct7  | funct3 | ALUOp | {func, ALUOP} | function |
// | :------: | :----: | :---: | :-----------: | :------: |
// |    -     |  000   |   01  | ???????00001  |   addi   |
// | 0000000  |  000   |   11  | 000000000011  |    add   |
// | 0100000  |  000   |   11  | 010000000011  |    sub   |
// | 0000000  |  111   |   11  | 000000011111  |    and   |
// | 0000000  |  100   |   11  | 000000010011  |    xor   |
// | 0000000  |  001   |   11  | 000000000111  |    sll   |
// | 0100000  |  101   |   01  | 010000010101  |   srai   |
// | 0000001  |  000   |   11  | 000000100011  |    mul   |


// Implementation
// Concatenate funct7, funct3 and ALUOp to determine ALUControl
reg [2:0] y = 3'bx;

wire [11:0] x;
assign x = {funct7, funct3, ALUOp};
always @ (x) begin
    casez (x)
        12'b???????00001: assign y = `OP_ADD;
        12'b000000000011: assign y = `OP_ADD;
        12'b010000000011: assign y = `OP_SUB;
        12'b000000100011: assign y = `OP_MUL;
        12'b000000011111: assign y = `OP_AND;
        12'b000000010011: assign y = `OP_XOR;
        12'b000000000111: assign y = `OP_SLL;
        12'b010000010101: assign y = `OP_SRA;
        default:          assign y = `OP_DIV;
    endcase
end

assign ALUControl = y;

endmodule
