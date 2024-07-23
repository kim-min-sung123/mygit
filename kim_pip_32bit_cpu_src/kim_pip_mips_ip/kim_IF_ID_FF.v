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
module kim_IF_ID_FF 
(
    input   wire                            clk,
    input   wire                            rstn,
    input   wire    [INST_DATA_WIDTH-1:0]   instruction,
    input   wire                            is_flush, // for beq, jump
    input   wire                            is_mem_hazard, // by hazard detection
    input   wire    [PC_ADDR_WIDTH-1:0]     pc_next_in, // by pc = pc + 4 for beq, jump
        
    output  reg     [INST_DATA_WIDTH-1:0]   instruction_reg,
    output  reg     [INST_DATA_WIDTH-1:0]   pc_next_reg
);

//------------------------Parameter----------------------
localparam
    INST_DATA_WIDTH = 32,
    PC_ADDR_WIDTH = 32;
    

//------------------------Local signal-------------------

//------------------------Instantiation------------------

// instruction_reg
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        instruction_reg <= 0;
    end
    else if(is_flush) begin
        instruction_reg <= 0; // for 2 bubble -> 1 bubble by beq . for preventing the execution of the next inst when a branch occurs.
    end
    else if(is_mem_hazard) begin
        instruction_reg <= instruction_reg; // out again by hazard detection's inst invarild(stall)
    end   
    else begin
        instruction_reg <= instruction;
    end
end

// pc_next_reg
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        pc_next_reg <= 0;
    end   
    else begin
        pc_next_reg <= pc_next_in;
    end
end


    
endmodule