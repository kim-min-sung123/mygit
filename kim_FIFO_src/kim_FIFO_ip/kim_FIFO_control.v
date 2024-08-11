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
module kim_FIFO_control 
# (
	parameter   FIFO_DATA_LENGTH = 32,
	parameter   FIFO_DATA_DEPTH  = 4,
	parameter   FIFO_LOG2_DEPTH  = 2
)
(
	input           						clk,
	input           						rst,

	input           						s_valid,
	output         				 			s_ready,
	input   		[FIFO_DATA_LENGTH-1:0] 	s_data,
	output	wire	[FIFO_DATA_LENGTH-1:0]	w_data, // to FIFO mem				

	output          						m_valid,
	input           						m_ready,
	output  		[FIFO_DATA_LENGTH-1:0] 	m_data,
	input   wire	[FIFO_DATA_LENGTH-1:0] 	r_data, // from FIFO mem		
	
	input	wire	[FIFO_LOG2_DEPTH-1:0]	w_ptr, r_ptr,
	input	wire							w_back_in, r_back_in,
	
	output	wire							w_hs, r_hs
);
//------------------------Parameters-------------------
localparam 
	S_RUN 	= 2'b00,
	S_EMPTY = 2'b01,
	S_FULL  = 2'b10;
//------------------------Local signal-------------------
wire	empty_condi1, empty_condi2, full_condi1, full_condi2; 
wire	empty_en, full_en;
wire	back_eq;
reg		[1:0]	n_state, c_state;

//------------------------Instantiation------------------

// w_hs, m_valid output
assign w_hs = s_valid && s_ready;
assign m_valid = (c_state != S_EMPTY) || s_valid; 

// r_hs, s_ready output
assign r_hs = m_valid && m_ready;
assign s_ready = (c_state != S_FULL ) || m_ready; 

// data transfer
assign w_data = s_data;
assign m_data = (w_hs && (c_state == S_EMPTY)) ? s_data : r_data; 



// full, empty logic
assign back_eq = (w_back_in == r_back_in);

assign empty_condi1 = (!back_eq) && (r_ptr == (FIFO_DATA_DEPTH-1)) && (w_ptr == 0);
assign empty_condi2 = back_eq && ( r_ptr == (w_ptr-1));
assign empty_en =  (!w_hs) && (empty_condi1 || empty_condi2);

assign full_condi1 = back_eq && (w_ptr == (FIFO_DATA_DEPTH-1)) && (r_ptr == 0);
assign full_condi2 = (!back_eq) && ( w_ptr == (r_ptr-1));
assign full_en  = (!r_hs) && (full_condi1 || full_condi2);


// fsm
always @(posedge clk) begin
	if(rst) begin
		c_state <= S_EMPTY;
	end
	else begin
		c_state <= n_state;
	end
end	

always @(*) begin
	n_state = c_state;
	case (c_state)
		S_RUN: 
			if(w_hs && full_en)	
				n_state = S_FULL;
			else if(r_hs && empty_en) 
				n_state = S_EMPTY;
		S_EMPTY:
			if(w_hs && (!r_hs)) 
				n_state = S_RUN;
		S_FULL:
			if(r_hs && (!w_hs))
				n_state = S_RUN;
	endcase
end
	
endmodule
