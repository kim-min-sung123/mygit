`timescale 1ns/1ps
module kim_FIFO_top 
# (
	parameter   FIFO_DATA_LENGTH = 32,
	parameter   FIFO_DATA_DEPTH  = 4,
	parameter   FIFO_LOG2_DEPTH  = 2
)
(
	input           				clk,
	input           				rst,

	input           				s_valid,
	output         				 	s_ready,
	input   [FIFO_DATA_LENGTH-1:0] 	s_data,

	output          				m_valid,
	input           				m_ready,
	output  [FIFO_DATA_LENGTH-1:0] 	m_data
);

//------------------------Parameters-------------------


//------------------------Local signal-------------------
wire	[FIFO_LOG2_DEPTH-1:0]	w_ptr_w, r_ptr_w;
wire							w_back_w, r_back_w;
wire							w_hs_w, r_hs_w;
wire	[FIFO_DATA_LENGTH-1:0]	data_in_w,data_out_w;
//------------------------Instantiation------------------

kim_FIFO_control #(
	.FIFO_DATA_LENGTH	(FIFO_DATA_LENGTH),
	.FIFO_DATA_DEPTH	(FIFO_DATA_DEPTH),
	.FIFO_LOG2_DEPTH	(FIFO_LOG2_DEPTH)
)	
FIFO_control_u1
(
	.clk		(clk),
	.rst		(rst),

	.s_valid	(s_valid),
	.s_ready	(s_ready),
	.s_data		(s_data ),
	.w_data		(data_in_w), // to FIFO mem				

	.m_valid	(m_valid),
	.m_ready	(m_ready),
	.m_data		(m_data), // output from fifo
	.r_data		(data_out_w), // from FIFO mem		
	
	.w_ptr		(w_ptr_w), 
	.r_ptr		(r_ptr_w),
	.w_back_in	(w_back_w), 
	.r_back_in	(r_back_w),
	
	.w_hs		(w_hs_w),
	.r_hs		(r_hs_w)
);

kim_FIFO_mem #(
	.FIFO_DATA_LENGTH	(FIFO_DATA_LENGTH),
	.FIFO_DATA_DEPTH	(FIFO_DATA_DEPTH),
	.FIFO_LOG2_DEPTH	(FIFO_LOG2_DEPTH)
)	
FIFO_mem_u1
(
	.clk		(clk),
	.rst		(rst),

	.w_hs		(w_hs_w),
    .r_hs		(r_hs_w),

    .data_in	(data_in_w),    

    .data_out	(data_out_w),

    .w_ptr		(w_ptr_w),
    .r_ptr		(r_ptr_w),

    .w_back		(w_back_w),
    .r_back		(r_back_w)
);

endmodule