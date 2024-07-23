
module acc_v2 (
	input clk,rstb,
    input fill_data, alu_sel,
	input [3:0] alu_out, bus_reg_data,
	input [1:0] high_sel, low_sel, 
	output reg [3:0] acc_high_data, acc_low_data
	// 00 : maintain, 01 : left shift, 10 : right shift, 11 : load
);

wire [3:0] data_in;

assign data_in = (alu_sel) ? alu_out : bus_reg_data;

always @(posedge clk or negedge rstb)begin
	if(!rstb)begin
		acc_high_data <= 0;
	end	
	else begin
		if(high_sel==2'b00)begin 
			acc_high_data <= acc_high_data;
		end
		else if(high_sel==2'b01)begin // about div
			if(fill_data) acc_high_data <= {data_in[2:0],acc_low_data[3]};
			else acc_high_data <= {acc_high_data[2:0],acc_low_data[3]};  
		end	
		else if(high_sel==2'b10)begin // about mul
			acc_high_data <= {fill_data,data_in[3:1]}; 
		end	
		else acc_high_data <= fill_data; // fill_data is about carry
	end	
end

always @(posedge clk or negedge rstb)begin
	if(!rstb)begin
		acc_low_data <= 0;
	end		
	else begin
		if(low_sel==2'b00)begin // sel's separating is needed for optimization	
			acc_low_data <= acc_low_data;
		end
		else if(low_sel==2'b01)begin // about div
			acc_low_data <= {acc_low_data[2:0],fill_data}; 
		end	
		else if(low_sel==2'b10)begin // about mul
			acc_low_data[3] <= data_in[0];
			acc_low_data[2:0] <= acc_low_data[3:1];
		end	
		else acc_low_data <= data_in; 
	end	
end

endmodule
