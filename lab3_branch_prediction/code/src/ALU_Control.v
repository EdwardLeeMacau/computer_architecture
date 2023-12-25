// NOTE: Repeated definition in `ALU.v`
`define OP_ADD 3'b000
`define OP_SUB 3'b001
`define OP_MUL 3'b010
`define OP_NOP 3'b011
`define OP_AND 3'b100
`define OP_XOR 3'b101
`define OP_SLL 3'b110
`define OP_SRA 3'b111

// Spec:
// ALUControl is determined by ALUOp and funct7 and funct3.
//
// |  funct7  | funct3 | ALUOp | {func, ALUOP} | function |
// | :------: | :----: | :---: | :-----------: | :------: |
// |    -     |  000   |  001  | ???????000001 |   addi   |
// |    -     |  010   |  000  | ???????010000 |     lw   |
// |    -     |  010   |  010  | ???????010010 |     sw   |
// | 0000000  |  000   |  011  | 0000000000011 |    add   |
// | 0100000  |  000   |  011  | 0100000000011 |    sub   |
// | 0000000  |  111   |  011  | 0000000111011 |    and   |
// | 0000000  |  100   |  011  | 0000000100011 |    xor   |
// | 0000000  |  001   |  011  | 0000000001011 |    sll   |
// | 0100000  |  101   |  001  | 0100000101001 |   srai   |
// | 0000001  |  000   |  011  | 0000001000011 |    mul   |
// |    -     |  000   |  110  | ???????000110 |    beq   |

module ALU_Control
(
    input  [2:0] ALUOp,
    input  [6:0] funct7,
    input  [2:0] funct3,

    output [2:0] out
);

// Implementation
// Concatenate funct7, funct3 and ALUOp to determine ALUControl
reg [2:0] y;

wire [12:0] x;
assign x = {funct7, funct3, ALUOp};
always @ (x) begin
    casez (x)
        13'b???????000001: assign y = `OP_ADD;  // addi
        13'b???????010000: assign y = `OP_ADD;  // lw
        13'b???????010010: assign y = `OP_ADD;  // sw
        13'b0000000000011: assign y = `OP_ADD;  // add
        13'b0100000000011: assign y = `OP_SUB;
        13'b???????000110: assign y = `OP_SUB;  // beq
        13'b0000001000011: assign y = `OP_MUL;
        13'b0000000011111: assign y = `OP_AND;
        13'b0000000010011: assign y = `OP_XOR;
        13'b0000000001011: assign y = `OP_SLL;
        13'b0100000101001: assign y = `OP_SRA;
        default:           assign y = `OP_NOP;
    endcase
end

assign out = y;

endmodule
