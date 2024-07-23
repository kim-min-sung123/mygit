/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2024 04:30:50 PM
// Design Name: 
// Module Name: alu_acc_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_acc_v1(
    input clk, rstb,
    input op_add, op_sub, // op_mul and op_div enter in mul or div_control module
	input op_and, op_or,
    input [3:0] bus_reg_data1, // multiplicand or divisor from CU
	input [3:0] bus_reg_data2, // multiplier or dividend from CU
	input mul_en, div_en, // from CU
	output wire [3:0] acc_high_data, acc_low_data,
    output zero_flag, sign_flag, carry_flag
);

wire Cout_w;
wire [1:0] high_sel_w, low_sel_w;
wire [3:0] alu_out_w;
wire alu_sel_w_mul, alu_sel_w_div;
wire mul_en_r, div_en_r; // when mul or div
wire [3:0] multiplicand_to_alu, divisor_to_alu;
wire mul_complete, div_complete;

assign high_sel_w = (mul_en|div_en) ? 3 : (!mul_complete) ? 2 : 
                    (!div_complete) ? 1 : 0; // + more coding
assign  low_sel_w = (mul_en|div_en) ? 3 : (!mul_complete) ? 2 :
                    (!div_complete) ? 1 : 0; // + more coding
						  
alu_v1 U1(
    .clk(clk),
    .rstb(rstb),
    .op_add(op_add),
    .op_sub(op_sub),
    .op_mul(mul_en_r),
    .op_div(div_en_r),
    .op_and(op_and),
    .op_or(op_or),
    .acc_high_data(acc_high_data),
    .bus_reg_data(bus_reg_data1 | multiplicand_to_alu | divisor_to_alu),
    .alu_out(alu_out_w),
    .zero_flag(zero_flag),
    .sign_flag(sign_flag),
    .carry_flag(carry_flag),
    .Cout(Cout_w)
);

acc_v2 U2(
    .clk(clk),
    .rstb(rstb),
    .fill_data(Cout_w),
    .alu_sel(alu_sel_w_mul | alu_sel_w_div),
    .alu_out(alu_out_w),
    .bus_reg_data(bus_reg_data2),
    .high_sel(high_sel_w),
    .low_sel(low_sel_w),
    .acc_high_data(acc_high_data),
    .acc_low_data(acc_low_data)
);

mul_control_v2 U3(
    .clk(clk),
    .rstb(rstb),
    .acc_lsb(acc_low_data[0]),
    .mul_en(mul_en),
    .multiplicand(bus_reg_data1),
    .alu_sel(alu_sel_w_mul),
    .add_en(mul_en_r),
    .mul_complete(mul_complete),
    .multiplicand_to_alu(multiplicand_to_alu)
);

div_control_v1 U4(
    .clk(clk),
    .rstb(rstb),
    .div_en(div_en),
    .divisor(bus_reg_data1),
    .alu_sel(alu_sel_w_div),
    .sub_en(div_en_r),
    .div_complete(div_complete),
    .divisor_to_alu(divisor_to_alu)
);

endmodule	
