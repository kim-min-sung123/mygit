//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-08
// Design Name: kim_data_mem 
// Module Name: kim_data_mem 
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_data_mem 
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_data_mem_p 
# (
    parameter MEM_ADDR_WIDTH = 6, // free set . I decided mem size as [63:0]
    parameter MEM_DATA_WIDTH = 8
) 
(
    input   wire                            clk,
    input   wire                            MemWrite,
    input   wire [MEM_DATA_WIDTH*4-1:0]     w_data,
  //input   wire                            MemRead, // why need?
    input   wire [MEM_ADDR_WIDTH-1:0]       addr_by_alu, 
    output  wire [MEM_DATA_WIDTH*4-1:0]     r_data
);

//------------------------Local signal-------------------
reg [MEM_DATA_WIDTH-1:0] mem [2**MEM_ADDR_WIDTH-1:0]; 

//------------------------Instantiation------------------
// 1. memory initialization
initial begin
    $readmemh("datamemfile.txt",mem); // total mem initialization as memfile content
    // must set right path and for me, only absolute path was right
end

// 2. read by mem
assign r_data = {mem[addr_by_alu+3],
                 mem[addr_by_alu+2],
                 mem[addr_by_alu+1],
                 mem[addr_by_alu]}; // Little Endian by intel cpu

// 3.  write to mem
always @(posedge clk) begin
    if(MemWrite) begin
        {mem[addr_by_alu+3], 
         mem[addr_by_alu+2], 
         mem[addr_by_alu+1], 
         mem[addr_by_alu  ]} <= w_data;
    end
end
endmodule