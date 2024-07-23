module kim_counter_top #(
    parameter CNT_DATA_WIDTH = 7  // $clog2(cnt_val)
)  
(
    input   wire                            clk,
    input   wire                            rst_n,
    input   wire                            start,
    input   wire    [CNT_DATA_WIDTH-1:0]    cnt_val,

    output  wire    [CNT_DATA_WIDTH-1:0]    cnt
);

wire    cnt_en;
wire    init_cnt;

kim_counter_control #(
  .CNT_DATA_WIDTH ( CNT_DATA_WIDTH )
) 
counter_control_u1 (
    .clk            (clk     ),
    .rst_n          (rst_n   ),
    .start          (start   ),
    .cnt_val        (cnt_val ),
    .c_cnt          (cnt     ),   // current count value

    .run_o          (cnt_en  ),
    .done_o         (init_cnt)
);

kim_counter #(
  .CNT_DATA_WIDTH ( CNT_DATA_WIDTH )
) 
counter_u1 (
    .clk            (clk     ),
    .rst_n          (rst_n   ),
    .cnt_en         (cnt_en  ),
    .init_cnt       (init_cnt),

    .cnt            (cnt     )
);


    
endmodule