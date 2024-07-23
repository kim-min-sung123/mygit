//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_instruction_mem
// Module Name: kim_instruction_mem
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_instruction_mem
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_instruction_mem_p 
# (
    parameter MEM_ADDR_WIDTH = 6, // free set . I decided mem size as [63:0]
    parameter MEM_DATA_WIDTH = 8
) 
(
    input   wire [MEM_ADDR_WIDTH-1:0]       r_addr_by_pc,
    output  wire [MEM_DATA_WIDTH*4-1:0]     instruction
);

//------------------------Local signal-------------------
reg [MEM_DATA_WIDTH-1:0] mem [2**MEM_ADDR_WIDTH-1:0]; 

//------------------------Instantiation------------------
// 1. memory initialization
initial begin
    $readmemh("instmemfile.txt",mem); // total mem initialization as memfile content
    // must set right path and for me, only absolute path was right
end

// 2. read by mem
assign instruction = {mem[r_addr_by_pc+3],
                      mem[r_addr_by_pc+2],
                      mem[r_addr_by_pc+1],
                      mem[r_addr_by_pc]}; // Little Endian by intel cpu
endmodule