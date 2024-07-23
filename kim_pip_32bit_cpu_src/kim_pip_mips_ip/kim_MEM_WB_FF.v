//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-13
// Design Name: kim_MEM_WB_FF
// Module Name: kim_MEM_WB_FF
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_MEM_WB_FF
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_MEM_WB_FF 
(
    input   wire                                    clk,
    input   wire                                    rstn,

    //input   wire                                    RegDst,  
    //input   wire                                    Jump,  
    //input   wire                                    Branch, 
    input   wire                                    MemtoReg, // MemRead,  select either mem data or alu data  
    //input   wire [1:0]                              ALUOp, 
    //input   wire                                    MemWrite, 
    //input   wire                                    ALUSrc, 
    input   wire                                    RegWrite,

    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     r_data,
    input   wire [MIPS_REGISTER_DATA_WIDTH-1:0]     alu_result,

    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]     EX_MEM_Rt_or_Rd,


    //output  reg                                     RegDst_reg,  
    //output  reg                                     Jump_reg,  
    //output  reg                                     Branch_reg, 
    output  reg                                     MemtoReg_reg, // MemRead
    //output  reg [1:0]                               ALUOp_reg, 
    //output  reg                                     MemWrite_reg, 
    //output  reg                                     ALUSrc_reg, 
    output  reg                                     RegWrite_reg,

    output  reg [MIPS_REGISTER_DATA_WIDTH-1:0]      r_data_reg,
    output  reg [MIPS_REGISTER_DATA_WIDTH-1:0]      alu_result_reg,

    output  reg [MIPS_REGISTER_ADDR_WIDTH-1:0]      MEM_WB_Rt_or_Rd_reg


);

//------------------------Parameter----------------------
localparam
    MIPS_REGISTER_DATA_WIDTH = 32,
    MIPS_REGISTER_ADDR_WIDTH = 5;
//------------------------Local signal-------------------

//------------------------Instantiation------------------

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
    //RegDst_reg            <= 0;
    //Jump_reg              <= 0;
    //Branch_reg            <= 0;
    MemtoReg_reg        <= 0;
    //ALUOp_reg,            <= 0;
    //MemWrite_reg          <= 0;
    //ALUSrc_reg            <= 0;
    r_data_reg          <= 0; 
    alu_result_reg      <= 0; 
    MEM_WB_Rt_or_Rd_reg <= 0;
    end
    else begin
    //RegDst_reg            <= RegDst;
    //Jump_reg              <= Jump;
    //Branch_reg            <= Branch;
    MemtoReg_reg        <= MemtoReg;
    //ALUOp_reg,            <= ALUOp;
    //MemWrite_reg          <= MemWrite;
    //ALUSrc_reg            <= ALUSrc;
    RegWrite_reg        <= RegWrite;
    r_data_reg          <= r_data; 
    alu_result_reg      <= alu_result;
    MEM_WB_Rt_or_Rd_reg <= EX_MEM_Rt_or_Rd;
    end
end


    
endmodule