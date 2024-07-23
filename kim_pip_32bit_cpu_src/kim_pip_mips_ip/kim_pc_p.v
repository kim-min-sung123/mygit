//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_pc
// Module Name: kim_pc
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_pc
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_pc_p
#(
    parameter PC_ADDR_WIDTH = 32
) 
(
    input wire                     clk,
    input wire                     rstn,
    input wire                     pc_stall, // about hazard detection
    input wire [PC_ADDR_WIDTH-1:0] pc_next,
    output reg [PC_ADDR_WIDTH-1:0] pc
);

//------------------------Instantiation------------------
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pc <= 0;
    end
    else if(pc_stall) begin
        pc <= pc; 
    end
    else begin
        pc <= pc_next;
    end    
end
    
endmodule