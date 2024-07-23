module alu_v1(
   input clk, rstb,
   input op_add, op_sub, op_mul, op_div,
	input op_and, op_or,
	input [3:0] acc_high_data,
   input [3:0] bus_reg_data,
   output [3:0] alu_out,
   output Cout, zero_flag, sign_flag, carry_flag
);

wire [3:0] alu_out_w;


assign alu_out = (op_and==1) ? acc_high_data & bus_reg_data : 
                 (op_or==1) ? acc_high_data | bus_reg_data : alu_out_w ; 
// logic

add_subNbit_v2 #(.N(4)) add_sub4bit(
.A(acc_high_data),
.B(bus_reg_data),
.Cin(op_sub|op_div),
.S(alu_out_w), 
.Cout(Cout)
); 

reg_1bit sign_f(
.clk(clk), .rstb(rstb), .in_en(op_sub), .d( (op_sub&(!Cout)) ), .q(sign_flag)
);

reg_1bit carry_f(
.clk(clk), .rstb(rstb), .in_en(1), .d( (op_add|op_div)&Cout ), .q(carry_flag)
);

reg_1bit zero_f(
.clk(clk), .rstb(rstb), .in_en(1), .d( (alu_out_w == 4'b0000) ), .q(zero_flag)
);

endmodule
	
	