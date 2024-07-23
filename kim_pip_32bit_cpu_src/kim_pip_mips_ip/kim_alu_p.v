//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-09
// Design Name: kim_alu
// Module Name: kim_alu
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_alu
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_alu_p 
#(
    parameter ALU_DATA_WIDTH = 32
) 
(
    input   wire [ALU_DATA_WIDTH-1:0]   a,
    input   wire [ALU_DATA_WIDTH-1:0]   b,
    input   wire [3:0]                  alu_control,
    output  wire                        alu_zero,
    output  reg [ALU_DATA_WIDTH-1:0]    alu_result  
);
    
//------------------------Parameter----------------------


//------------------------Local signal-------------------
wire [ALU_DATA_WIDTH-1:0] sum;

//------------------------Instantiation------------------
assign sum = a + ( b ^ {ALU_DATA_WIDTH{alu_control[2]}} ) + alu_control[2]; // cin is alu_control[2], select add or sub

assign alu_zero = (sum) ? 0 : 1 ;

always @(*) begin
    case (alu_control) 
        4'b0000: begin
            alu_result = a & b; // and
        end
        4'b0001: begin
            alu_result = a | b; // or
        end
        4'b0010: begin
            alu_result = sum; // add
        end
        4'b0110: begin
            alu_result = sum; // sub
        end
        4'b0111: begin
            alu_result = sum[ALU_DATA_WIDTH-1]; // slt = negative (sum's msb (signed))
        end
        4'b1100: begin
            alu_result = ~(a | b); // for NOT operation 
        end
        default: begin
            alu_result = 32'bx;
        end
    endcase
end

endmodule