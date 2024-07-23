//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-09
// Design Name: kim_alu_control
// Module Name: kim_alu_control
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_alu_control
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_alu_control_p 
(
    input   wire  [1:0]                     alu_op_in,
    input   wire  [FUCNT_DATA_WIDTH-1:0]    fucnt_in,
    output  reg   [3:0]                     alu_control
);

//------------------------Parameter----------------------
localparam
    FUCNT_DATA_WIDTH = 6;


//------------------------Local signal-------------------


//------------------------Instantiation------------------
always @(*) begin
    if(alu_op_in == 2'b00) begin
        alu_control = 4'b0010; // lw,sw (add)
    end
    else if(alu_op_in == 2'b01) begin
        alu_control = 4'b0110; // beq (sub)
    end
    else if(alu_op_in == 2'b10) begin
        case (fucnt_in) 
            6'b100000: begin
                alu_control = 4'b0010; // add
            end
            6'b100010: begin
                alu_control = 4'b0110; // sub
            end
            6'b100100: begin
                alu_control = 4'b0000; // and
            end
            6'b100101: begin
                alu_control = 4'b0001; // or
            end
            6'b100111: begin
                alu_control = 4'b1100; // nor
            end
            6'b101010: begin
                alu_control = 4'b0111; // slt
            end
            default: begin
                alu_control = 4'b0010; // to prevent latch
            end
        endcase
    end
    else begin
        alu_control = 4'b0010; // to prevent latch
    end
end



    
 
endmodule