//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-05
// Design Name: kim_MIPS_register
// Module Name: kim_MIPS_register
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_MIPS_register
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_mips_register_p 
( 
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     read_to_reg1_in, // about addr of mips_reg
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     read_to_reg2_in, // about addr of mips_reg
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     write_to_w_reg_in, // about addr of mips_reg
    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     w_data,
    input   wire                                    RegWrite,

    output  wire [MIPS_REGISTER_DATA_WIDTH-1:0]     r_data1,
    output  wire [MIPS_REGISTER_DATA_WIDTH-1:0]     r_data2
    
);

//------------------------Address Info-------------------
// 00000 : $0(register num), $zero(register name)  function : always 0 
// 00001 : $1(register num), $at(register name)  function : reserved register for Assembler
// 00010 : $2(register num), $v0(register name)  function : store return from function
// 00011 : $3(register num), $v1(register name)  function : store return from function
// ~~

//------------------------ TOTAL MIPS_register Info -------------------
// $0	         $zero                       It is always fixed to 0.    
// $1	         $at                         Registers reserved for Assembler
// $2, $3	     $v0, $v1	                 Register that stores the value returned from a function
// $4, ...,$7	 $a0, ..., $a3	             Register to store function arguments
// $8, ...,$15 	 $t0, ..., $t7	             Register used to temporarily store values
// $16, ...,$23	 $s0, ... $s7	             Registers used to store long-lasting values
// $24, $25	     $t8, $t9	                 Register used to temporarily store values
// $26, $27	     $k0, $k1	                 Registers reserved for the kernel (Operating System)
// $28	         $gp	                     Register that stores the value of the global pointer
// $29	         $sp	                     Register that stores the value of the stack pointer
// $30	         $fp	                     Register that stores the value of the frame pointer
// $31	         $ra	                     Register that stores the address of the return location

//------------------------Parameter----------------------
localparam
    MIPS_REGISTER_DATA_WIDTH = 32, // DATA is instruction(32bit) and 32bit transfer per 1 transection
    MIPS_REGISTER_ADDR_WIDTH = $clog2(MIPS_REGISTER_DATA_WIDTH); // word num = MIPS_REGISTER_DATA_WIDTH

//------------------------Local signal-------------------
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    zero = 32'b0; // reg num 0
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    at; // 1
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    v [1:0]; // 2~3
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    a [3:0]; // 4~7
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    t [9:0]; // 8~15, 24~25
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    s [7:0]; // 16~23
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    k [1:0]; // 26~27
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    gp; // 28 
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    sp; // 29
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    fp; // 30
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    ra; // 31  total 32 num registers

    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    r_reg1;
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    r_reg2;
    reg [MIPS_REGISTER_DATA_WIDTH-1:0]    w_reg; 
   

//------------------------Instantiation------------------


// 1-1. r_data1
// assign r_data1 = r_reg1;
assign r_data1 = (RegWrite && (read_to_reg1_in==write_to_w_reg_in)) ? w_data  : r_reg1 ;

always @(*) begin
        case (read_to_reg1_in) 
            5'b00000: begin
                r_reg1 <= zero;   
            end
            5'b00001: begin
                r_reg1 <= at;   
            end
            5'b00010: begin
                r_reg1 <= v[0];   
            end
            5'b00011: begin
                r_reg1 <= v[1];   
            end
            5'b00100: begin
                r_reg1 <= a[0];
            end
            5'b00101: begin
                r_reg1 <= a[1];
            end
            5'b00110: begin
                r_reg1 <= a[2];
            end
            5'b00111: begin
                r_reg1 <= a[3];
            end
            5'b01000: begin
                r_reg1 <= t[0];
            end
            5'b01001: begin
                r_reg1 <= t[1];
            end
            5'b01010: begin
                r_reg1 <= t[2];   
            end
            5'b01011: begin
                r_reg1 <= t[3];  
            end
            5'b01100: begin
                r_reg1 <= t[4]; 
            end
            5'b01101: begin
                r_reg1 <= t[5];
            end
            5'b01110: begin
                r_reg1 <= t[6];
            end
            5'b01111: begin
                r_reg1 <= t[7]; 
            end
            5'b10000: begin
                r_reg1 <= s[0];  
            end
            5'b10001: begin
                r_reg1 <= s[1];  
            end
            5'b10010: begin
                r_reg1 <= s[2]; 
            end
            5'b10011: begin
                r_reg1 <= s[3];  
            end
            5'b10100: begin
                r_reg1 <= s[4]; 
            end
            5'b10101: begin
                r_reg1 <= s[5];   
            end
            5'b10110: begin
                r_reg1 <= s[6]; 
            end
            5'b10111: begin
                r_reg1 <= s[7]; 
            end
            5'b11000: begin
                r_reg1 <= t[8];   
            end
            5'b11001: begin
                r_reg1 <= t[9];  
            end
            5'b11010: begin
                r_reg1 <= k[0]; 
            end
            5'b11011: begin
                r_reg1 <= k[1]; 
            end
            5'b11100: begin
                r_reg1 <= gp;   
            end
            5'b11101: begin
                r_reg1 <= sp;   
            end
            5'b11110: begin
                r_reg1 <= fp;   
            end
            5'b11111: begin
                r_reg1 <= ra;   
            end
            default: begin
                r_reg1 <= 0;  
            end                
        endcase
end

// 1-2. r_data2
// assign r_data2 = r_reg2;
assign r_data2 = (RegWrite && (read_to_reg2_in==write_to_w_reg_in)) ? w_data  : r_reg2 ;

always @(*) begin
        case (read_to_reg2_in) 
            5'b00000: begin
                r_reg2 <= zero;   
            end
            5'b00001: begin
                r_reg2 <= at;   
            end
            5'b00010: begin
                r_reg2 <= v[0];   
            end
            5'b00011: begin
                r_reg2 <= v[1];   
            end
            5'b00100: begin
                r_reg2 <= a[0];
            end
            5'b00101: begin
                r_reg2 <= a[1];
            end
            5'b00110: begin
                r_reg2 <= a[2];
            end
            5'b00111: begin
                r_reg2 <= a[3];
            end
            5'b01000: begin
                r_reg2 <= t[0];
            end
            5'b01001: begin
                r_reg2 <= t[1];
            end
            5'b01010: begin
                r_reg2 <= t[2];   
            end
            5'b01011: begin
                r_reg2 <= t[3];  
            end
            5'b01100: begin
                r_reg2 <= t[4]; 
            end
            5'b01101: begin
                r_reg2 <= t[5];
            end
            5'b01110: begin
                r_reg2 <= t[6];
            end
            5'b01111: begin
                r_reg2 <= t[7]; 
            end
            5'b10000: begin
                r_reg2 <= s[0];  
            end
            5'b10001: begin
                r_reg2 <= s[1];  
            end
            5'b10010: begin
                r_reg2 <= s[2]; 
            end
            5'b10011: begin
                r_reg2 <= s[3];  
            end
            5'b10100: begin
                r_reg2 <= s[4]; 
            end
            5'b10101: begin
                r_reg2 <= s[5];   
            end
            5'b10110: begin
                r_reg2 <= s[6]; 
            end
            5'b10111: begin
                r_reg2 <= s[7]; 
            end
            5'b11000: begin
                r_reg2 <= t[8];   
            end
            5'b11001: begin
                r_reg2 <= t[9];  
            end
            5'b11010: begin
                r_reg2 <= k[0]; 
            end
            5'b11011: begin
                r_reg2 <= k[1]; 
            end
            5'b11100: begin
                r_reg2 <= gp;   
            end
            5'b11101: begin
                r_reg2 <= sp;   
            end
            5'b11110: begin
                r_reg2 <= fp;   
            end
            5'b11111: begin
                r_reg2 <= ra;   
            end
            default: begin
                r_reg2 <= 0;
            end               
        endcase
end

// 2-1. w_data by write_to_w_reg_in

/* : no effect
always @(posedge clk or negedge rstn) begin 
    if(!rstn) begin
        zero <= 0;
    end
    else begin
        zero <= 0;
    end
end
*/

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        at <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00001) begin
        at <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        v[0] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00010) begin
        v[0] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        v[1] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00011) begin
        v[1] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        a[0] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00100) begin
        a[0] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        a[1] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00101) begin
        a[1] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        a[2] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00110) begin
        a[2] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        a[3] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b00111) begin
        a[3] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[0] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01000) begin
        t[0] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[1] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01001) begin
        t[1] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[2] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01010) begin
        t[2] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[3] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01011) begin
        t[3] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[4] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01100) begin
        t[4] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[5] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01101) begin
        t[5] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[6] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01110) begin
        t[6] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[7] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b01111) begin
        t[7] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[0] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10000) begin
        s[0] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[1] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10001) begin
        s[1] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[2] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10010) begin
        s[2] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[3] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10011) begin
        s[3] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[4] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10100) begin
        s[4] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[5] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10101) begin
        s[5] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[6] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10110) begin
        s[6] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        s[7] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b10111) begin
        s[7] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[8] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11000) begin
        t[8] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        t[9] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11001) begin
        t[9] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        k[0] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11010) begin
        k[0] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        k[1] <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11011) begin
        k[1] <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        gp <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11100) begin
        gp <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        sp <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11101) begin
        sp <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        fp <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11110) begin
        fp <= w_data;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        ra <= 0;
    end
    else if(RegWrite && write_to_w_reg_in == 5'b11111) begin
        ra <= w_data;
    end
end

endmodule