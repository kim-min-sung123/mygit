module reg_1bit (
   input clk, rstb, in_en, d,
	output reg q
);
	
always @(posedge clk or negedge rstb)begin
   if(!rstb)begin
      q <= 0;
	end
	else begin
	   if(in_en) q <= d;
	   else q <= q;
	end	
end

endmodule


