//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_mips_control
// Module Name: kim_mips_control
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_mips_control
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_mips_control_p
(
    input   wire [OP_DATA_WIDTH-1:0]        op_code,
    
    /*output  wire                            RegDst,  
    output  wire                            Jump,  
    output  wire                            Branch, 
    output  wire                            MemtoReg, // MemRead
    output  wire [1:0]                      ALUOp, 
    output  wire                            MemWrite, 
    output  wire                            ALUSrc, 
    output  wire                            RegWrite  <- no use in pip cpu */

    output  reg  [8:0]                      controls // wire             
);


//------------------------controls Info-------------------
// controls[0] is RegWrite
// controls[1] is ALUSrc
// controls[2] is MemWrite
// controls[3] is ALUOp[0]
// controls[4] is ALUOp[1]
// controls[5] is MemtoReg
// controls[6] is Branch
// controls[7] is Jump
// controls[8] is RegDst


//------------------------Parameter----------------------
localparam
    OP_DATA_WIDTH = 6;

//------------------------Local signal-------------------


//------------------------Instantiation------------------

// RegDst, Jump, Branch, MemtoReg, ALUOp[1],ALUOp[0], MemWrite, ALUSrc, RegWrite
always @(*) begin
    case (op_code) 
        6'b000000: begin
            controls = 9'b100010001; // R-type (add, sub, and, or, slt)
        end
        6'b000100: begin
            controls = 9'b001001000; // I-type beq
        end     
        6'b100011: begin
            controls = 9'b000100011; // I-type lw
        end    
        6'b101011: begin
            controls = 9'b000000110; // I-type sw
        end
        6'b000010: begin
            controls = 9'b010000000; // I-type j
        end  
        /* 6'b001000: begin
            controls = 9'b000000011; // I-type addi
        end */               
        default: begin
            controls = 9'b000000000; // to prevent latch 
        end     
    endcase
end

endmodule