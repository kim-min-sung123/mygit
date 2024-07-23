module kim_counter_control #(
    parameter CNT_DATA_WIDTH = 7  // $clog2(cnt_val)
) 
(
    input   wire                            clk,
    input   wire                            rst_n,
    input   wire                            start,
    input   wire    [CNT_DATA_WIDTH-1:0]    cnt_val,
    input   wire    [CNT_DATA_WIDTH-1:0]    c_cnt, // current count value from counter module

    output  wire                            run_o,
    output  wire                            done_o
);

reg     [1:0]     n_state;
reg     [1:0]     c_state;
reg     [CNT_DATA_WIDTH-1:0]    cnt_val_r;


localparam 
    S_IDLE = 2'b00,
    S_RUN  = 2'b01,
    S_DONE = 2'b10;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        c_state = S_IDLE;
    end
    else begin
        c_state = n_state;
    end
end

// n_state logic
always @(*) begin
    n_state = c_state;
    case (c_state)
        S_IDLE: if(start) 
                    n_state = S_RUN;
                    
        S_RUN : if( c_cnt == (cnt_val_r-1) ) 
                    n_state = S_DONE;
                else 
                    n_state = S_RUN;
                    
        S_DONE:     n_state = S_IDLE;
    endcase
end
    
assign run_o  = (c_state != S_IDLE); // for cnt start
assign done_o = (c_state == S_DONE); // for initialize cnt

// to capture cnt_val
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_val_r <= 0;
    end
    else if(start) begin
        cnt_val_r <= cnt_val;
    end
end

endmodule