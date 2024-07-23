//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_mux_2to1
// Module Name: kim_mux_2to1
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_mux_2to1
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_mux_2to1
# (
    parameter MUX_DATA_WIDTH = 32
) 
(
    input   wire                            sel,
    input   wire    [MUX_DATA_WIDTH-1:0]    a,
    input   wire    [MUX_DATA_WIDTH-1:0]    b,
    output  wire    [MUX_DATA_WIDTH-1:0]    mux_out
);

//------------------------Instantiation------------------
assign mux_out = (sel) ? a : b ;
    
endmodule