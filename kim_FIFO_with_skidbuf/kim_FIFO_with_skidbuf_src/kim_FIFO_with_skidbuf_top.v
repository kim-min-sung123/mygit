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
module kim_FIFO_with_skidbuf_top
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

//------------------------Parameters---------------------

//------------------------Local signal-------------------
wire                            w_s_valid, w_s_ready, w_m_valid, w_m_ready;
wire    [FIFO_DATA_LENGTH-1:0]  w_s_data, w_m_data;

//------------------------Instantiation------------------

kim_skid_buffer #(
    .DATA_WIDTH(FIFO_DATA_LENGTH)
)
kim_skid_buffer_in
(
    .clk        (clk),
    .rst        (rst),

    .s_valid    (s_valid),
    .s_ready    (s_ready),
    .s_data     (s_data),

    .m_valid    (w_s_valid),
    .m_ready    (w_s_ready),
    .m_data     (w_s_data)
);


kim_FIFO_wrapper kim_FIFO_wrapper_u1
(
    .clk    (clk),
    .rst    (rst),

    .s_valid    (w_s_valid),
    .s_ready    (w_s_ready),
    .s_data     (w_s_data),

    .m_valid    (w_m_valid),
    .m_ready    (w_m_ready),
    .m_data     (w_m_data)
);

kim_skid_buffer #(
    .DATA_WIDTH(FIFO_DATA_LENGTH)
)
kim_skid_buffer_out
(
    .clk        (clk),
    .rst        (rst),

    .s_valid    (w_m_valid),
    .s_ready    (w_m_ready),
    .s_data     (w_m_data),

    .m_valid    (m_valid),
    .m_ready    (m_ready),
    .m_data     (m_data)
);


endmodule