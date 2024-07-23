//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_sign_extend
// Module Name: kim_sign_extend
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_sign_extend
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_sign_extend_p
(
    input   wire [IMMEDIT_DATA_WIDTH-1:0]    immediate_in,
    output  wire [ADD_DATA_WIDTH-1:0]        immediate_out 
);

//------------------------Parameter----------------------
localparam
    IMMEDIT_DATA_WIDTH = 16,
    ADD_DATA_WIDTH = 32;

//------------------------Instantiation------------------
assign immediate_out = {{16{immediate_in[IMMEDIT_DATA_WIDTH-1]}},immediate_in}; // extend msb

endmodule