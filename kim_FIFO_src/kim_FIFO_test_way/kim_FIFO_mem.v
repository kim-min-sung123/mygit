//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: kim min sung
//
// Create Date: 
// License : 
// Design Name: 
// Module Name: 
// Project Name:
// Target Devices:
// Tool Versions:
//				
// Dependencies:
//
// Revision:
// Revision 
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module kim_FIFO_mem
# (
	parameter   FIFO_DATA_LENGTH = 32,
	parameter   FIFO_DATA_DEPTH  = 4,
	parameter   FIFO_LOG2_DEPTH  = 2
)
(
	input           						clk,
	input           						rst,

	input   wire           					w_hs,
    input   wire           					r_hs,

    input   wire    [FIFO_DATA_LENGTH-1:0]  data_in,                  

    output  wire     [FIFO_DATA_LENGTH-1:0] data_out,

    output  reg     [FIFO_LOG2_DEPTH-1:0]   w_ptr,
    output  reg     [FIFO_LOG2_DEPTH-1:0]   r_ptr,

    output  reg                             w_back,
    output  reg                             r_back
);

//------------------------Parameters-------------------
integer i;

//------------------------Local signal-------------------
reg [FIFO_DATA_LENGTH-1:0]  fifo_mem[FIFO_DATA_DEPTH-1:0];

//------------------------Instantiation------------------



// w_ptr, w_back, data logic
always @(posedge clk) begin
	if(rst) begin
		w_ptr	<= 0;
		w_back 	<= 0;
        for(i=0; i<FIFO_DATA_DEPTH; i=i+1) begin
            fifo_mem[i] <= {(FIFO_DATA_LENGTH){1'b0}};
        end
	end
	else if(w_hs) begin
		if(w_ptr == (FIFO_DATA_DEPTH-1)) begin
			w_ptr           <= 0;
			w_back 	        <= ~w_back;
            fifo_mem[w_ptr] <= data_in;
		end
		else begin
			w_ptr           <= w_ptr + 1;
			w_back 	        <= w_back;
            fifo_mem[w_ptr] <= data_in;
		end
	end	
end

// data out
assign data_out = fifo_mem[r_ptr];

// r_ptr, r_back logic
always @(posedge clk ) begin
	if(rst) begin
		r_ptr	<= 0;
		r_back 	<= 0;
	end
	else if(r_hs) begin
		if(r_ptr == (FIFO_DATA_DEPTH-1)) begin
			r_ptr   <= 0;
			r_back 	<= ~r_back;
		end
		else begin
			r_ptr   <= r_ptr + 1;
			r_back 	<= r_back;
		end
	end
end
	
endmodule

