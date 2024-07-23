//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_mux_4to1
// Module Name: kim_mux_4to1
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_mux_4to1
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_mux_4to1
# (
    parameter MUX_DATA_WIDTH = 32
)
(
    input   wire    [1:0]                   sel,
    input   wire    [MUX_DATA_WIDTH-1:0]    a,
    input   wire    [MUX_DATA_WIDTH-1:0]    b,
    input   wire    [MUX_DATA_WIDTH-1:0]    c,
    input   wire    [MUX_DATA_WIDTH-1:0]    d,
    output  reg    [MUX_DATA_WIDTH-1:0]     mux_out
);


//------------------------Instantiation------------------

always @(*) begin
    case (sel)
        2'b00: begin
            mux_out = a;
        end 
        2'b01: begin
            mux_out = b;
        end
        2'b10: begin
            mux_out = c;
        end
        2'b11: begin
            mux_out = d;
        end
        default: begin
            mux_out = 1'bx;
        end
    endcase
end
    
endmodule