`timescale 1ns / 1ps 
module kim_mips_32cpu_p_tb();

parameter CLK_PERIOD = 10000; // 100 MHz


reg clk;
reg rstn;

initial begin
        clk  = 0;
        rstn = 0;
#100    rstn = 1;    
#1000   $finish; 
end

always begin
    #5 clk = ~clk; // 100 MHZ
end

kim_mips_32cpu_p_top DUT(
    .clk    ( clk  ),
    .rstn   ( rstn )
);



endmodule



