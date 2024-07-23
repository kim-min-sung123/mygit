
module mul_control_v2(
	input clk,rstb,
	input acc_lsb,
	input mul_en, // from CU
	input [3:0] multiplicand,
	output reg alu_sel, add_en, mul_complete, //  if mul is completed, send mul_complete to CU to stop mul
	output wire [3:0] multiplicand_to_alu
);
reg [2:0] mul_count;
reg [3:0] multiplicand_save;

assign multiplicand_to_alu = (acc_lsb) ? multiplicand_save : 0;

always @(posedge clk or negedge rstb)begin
	if(!rstb) begin 
		mul_count <= 0;
		add_en <= 0;
		mul_complete <= 1;
		alu_sel <= 0;
		multiplicand_save <= 0;
	end
	else begin
		if(mul_en)begin // mul_en is 1 clock
			mul_count <= mul_count + 1;
			add_en <= 1; // to alu
		   mul_complete <= 0;
		   alu_sel <= 1;
		   multiplicand_save <= multiplicand;	
		end
		else if((mul_count)&&(mul_count != 3'b100))begin
			mul_count <= mul_count + 1;
			add_en <= 1;
		   mul_complete <= 0;
		   alu_sel <= 1;
			multiplicand_save <= multiplicand_save;
		end
		else begin
			mul_count <= 0; 
			add_en <= 0;
			mul_complete <= 1;
			alu_sel <= 0;
			multiplicand_save <= 0;
		end			
	end	
end

endmodule
