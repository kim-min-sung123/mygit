//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-14
// Design Name: kim_branch_compare
// Module Name: kim_branch_compare
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_branch_compare
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_branch_compare ( // stall pip(=inst drop) 
    input   wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  r_data1,
    input   wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  r_data2,
    input   wire                                    is_branch,

    output  wire                                    is_same // to pc mux and IF_ID_FF
);

//------------------------Parameter----------------------
localparam
    MIPS_REGISTER_DATA_WIDTH = 32;

//------------------------Local signal-------------------


//------------------------Instantiation------------------
assign is_same = (is_branch) ? ( ((r_data1==r_data2)) ? 1 : 0 ) : 0 ;




endmodule