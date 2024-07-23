
module div_control_v1(
	input clk,rstb,
	input div_en, // from CU
	input [3:0] divisor,
	output reg alu_sel, sub_en, div_complete,
	output [3:0] divisor_to_alu
);

reg [2:0] div_count; 
reg [3:0] divisor_save;

assign divisor_to_alu = divisor_save;

always @(posedge clk or negedge rstb)begin
	if(!rstb) begin 
		div_count <= 0;
		sub_en <= 0;
		div_complete <= 1;
		alu_sel <= 0;
		divisor_save <= 0;
	end
	else begin
		if(div_en)begin // div_en is 1 clock
			div_count <= div_count + 1;
			sub_en <= 1;
			div_complete <= 0;
			alu_sel <= 1;
			divisor_save <= divisor;
		end
		else if( (div_count)&&(div_count != 3'b101) )begin
			div_count <= div_count + 1;
			sub_en <= 1;
			div_complete <= 0;
			alu_sel <= 1;
			divisor_save <= divisor_save;
		end
		else begin
			div_count <= 0;
			sub_en <= 0;
			div_complete <= 1;
			alu_sel <= 0;
			divisor_save <= 0;
		end			
	end	
end

endmodule


