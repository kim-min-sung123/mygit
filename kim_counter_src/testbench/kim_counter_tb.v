`timescale 1ns/1ps
module kim_counter_tb;

parameter CNT_DATA_WIDTH = 7;

reg                             clk,rst_n,start;
reg     [CNT_DATA_WIDTH-1:0]    cnt_val;

wire    [CNT_DATA_WIDTH-1:0]    cnt;

kim_counter_top #(
    .CNT_DATA_WIDTH(CNT_DATA_WIDTH)
)
kim_counter_top_u1 (
    .clk        (clk),
    .rst_n      (rst_n),
    .start      (start),
    .cnt_val    (cnt_val),

    .cnt        (cnt)
);

// clk
always #5 clk <= ~clk;

initial begin
    clk = 0;
    rst_n = 1;

    #10 
    rst_n = 0;

    #10 
    rst_n = 1;

    #10
    start = 1;
    cnt_val = 100;

    #10
    start = 0;
    cnt_val = 0;
end

initial begin
    $dumpfile("dump_wave");
    $dumpvars;
    $monitor("current cnt = %d, time = %d",cnt, $time);
    #1200
    $finish;
end








    
endmodule