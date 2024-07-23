//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-13
// Design Name: kim_ID_EX_FF
// Module Name: kim_ID_EX_FF
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_ID_EX_FF
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_ID_EX_FF 
(
    input   wire                                    clk,
    input   wire                                    rstn,

    input   wire                                    RegDst,  
    //input   wire                                    Jump,  
    //input   wire                                    Branch, 
    input   wire                                    MemtoReg, // MemRead
    input   wire [1:0]                              ALUOp, 
    input   wire                                    MemWrite, 
    input   wire                                    ALUSrc, 
    input   wire                                    RegWrite,

    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     r_data1,
    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     r_data2,

    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     se_in,
    input   wire [5:0]                              fucnt_in,

    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     IF_ID_Rs, // inst [25:21]
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     IF_ID_Rt, // inst [20:16]
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     IF_ID_Rd, // inst [15:11]
    input   wire                                    stall,

    output  reg                                     RegDst_reg,  
    //output  reg                                     Jump_reg,  
    //output  reg                                     Branch_reg, 
    output  reg                                     MemtoReg_reg, // MemRead
    output  reg [1:0]                               ALUOp_reg, 
    output  reg                                     MemWrite_reg, 
    output  reg                                     ALUSrc_reg, 
    output  reg                                     RegWrite_reg,

    output  reg [MIPS_REGISTER_DATA_WIDTH-1:0]      r_data1_reg,
    output  reg [MIPS_REGISTER_DATA_WIDTH-1:0]      r_data2_reg,

    output  reg [MIPS_REGISTER_DATA_WIDTH-1:0]      se_in_reg,
    output  reg [5:0]                               fucnt_in_reg,

    output  reg [MIPS_REGISTER_ADDR_WIDTH-1:0]      ID_EX_Rs_reg,
    output  reg [MIPS_REGISTER_ADDR_WIDTH-1:0]      ID_EX_Rt_reg,
    output  reg [MIPS_REGISTER_ADDR_WIDTH-1:0]      ID_EX_Rd_reg


);

//------------------------Parameter----------------------
localparam
    MIPS_REGISTER_DATA_WIDTH = 32,
    MIPS_REGISTER_ADDR_WIDTH = 5;
//------------------------Local signal-------------------

//------------------------Instantiation------------------

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    RegDst_reg      <= 0;
    //Jump_reg        <= 0;
    //Branch_reg      <= 0;
    MemtoReg_reg    <= 0;
    ALUOp_reg       <= 0;
    MemWrite_reg    <= 0;
    ALUSrc_reg      <= 0;
    RegWrite_reg    <= 0;
    r_data1_reg     <= 0;
    r_data2_reg     <= 0; 
    se_in_reg       <= 0; 
    fucnt_in_reg    <= 0;
    ID_EX_Rs_reg    <= 0;
    ID_EX_Rt_reg    <= 0;
    ID_EX_Rd_reg    <= 0;
    end
    else if(stall) begin
        RegDst_reg      <= 0;
        //Jump_reg      <= 0;
        //Branch_reg    <= 0;
        MemtoReg_reg    <= 0;
        ALUOp_reg       <= 0;
        MemWrite_reg    <= 0;
        ALUSrc_reg      <= 0;
        RegWrite_reg    <= 0;
        r_data1_reg     <= 0;
        r_data2_reg     <= 0; 
        se_in_reg       <= 0; 
        fucnt_in_reg    <= 0;
        ID_EX_Rs_reg    <= 0;
        ID_EX_Rt_reg    <= 0;
        ID_EX_Rd_reg    <= 0;
    end
    else begin
    RegDst_reg      <= RegDst;
    //Jump_reg        <= Jump;
    //Branch_reg      <= Branch;
    MemtoReg_reg    <= MemtoReg;
    ALUOp_reg       <= ALUOp;
    MemWrite_reg    <= MemWrite;
    ALUSrc_reg      <= ALUSrc;
    RegWrite_reg    <= RegWrite;
    r_data1_reg     <= r_data1;
    r_data2_reg     <= r_data2; 
    se_in_reg       <= se_in; 
    fucnt_in_reg    <= fucnt_in;
    ID_EX_Rs_reg    <= IF_ID_Rs;
    ID_EX_Rt_reg    <= IF_ID_Rt;
    ID_EX_Rd_reg    <= IF_ID_Rd;
    end
end


    
endmodule