module kim_counter #(
    parameter CNT_DATA_WIDTH = 7  // $clog2(cnt_val)
) 
(
    input   wire                            clk,
    input   wire                            rst_n,
    input   wire                            cnt_en,
    input   wire                            init_cnt,

    output  reg    [CNT_DATA_WIDTH-1:0]     cnt
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0; 
    end
    else if(cnt_en) begin
        if(init_cnt) cnt <= 0; 
        else cnt <= cnt + 1;
    end
    else begin
        cnt <= cnt; 
    end
end
    
endmodule