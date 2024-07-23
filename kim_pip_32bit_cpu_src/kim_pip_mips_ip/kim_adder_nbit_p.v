//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_adder_nbit
// Module Name: kim_adder_nbit
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_adder_nbit
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_adder_nbit_p
#(
    parameter ADD_DATA_WIDTH = 32
) 
(
    input   wire [ADD_DATA_WIDTH-1:0]   a,
    input   wire [ADD_DATA_WIDTH-1:0]   b,
    output  wire [ADD_DATA_WIDTH-1:0]   y
);
//------------------------Instantiation------------------
assign y = a + b;
    
endmodule