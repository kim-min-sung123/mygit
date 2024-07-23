//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-13
// Design Name: kim_forwarding
// Module Name: kim_forwarding
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_forwarding
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_forwarding ( // + immediate transfer (I-type)
    input   wire                                           MEM_cycle_RegWrite, // for data hazard
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]            EX_MEM_Rt_or_Rd,

    input   wire                                           WB_cycle_RegWrite, // for mem hazard
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]            MEM_WB_Rt_or_Rd,

    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]            ID_EX_Rs,
    input   wire [MIPS_REGISTER_ADDR_WIDTH-1:0]            ID_EX_Rt,

    input   wire                                           ALUSrc, // for immediate transfer (I-type)

    output  reg  [1:0]       forward_A, // 00(no hazard),01(data hazard),10(mem hazard)
    output  reg  [1:0]       forward_B,  // 00(no hazard),01(data hazard),10(mem hazard),11(sign extend)
    output  reg  [1:0]       forward_C  // for sw wdata sel
);

//------------------------Local signal-------------------

//------------------------Parameter----------------------
localparam
    MIPS_REGISTER_DATA_WIDTH = 32,
    MIPS_REGISTER_ADDR_WIDTH = 5;


//------------------------Instantiation------------------

always @(*) begin
    if( MEM_cycle_RegWrite && (ID_EX_Rs == EX_MEM_Rt_or_Rd) ) begin // data hazard
        forward_A = 2'b01;
    end
    else  begin // mem hazard
        forward_A = {(WB_cycle_RegWrite && ( ID_EX_Rs == MEM_WB_Rt_or_Rd )),1'b0};
    end
end

// forward_B for Rt
always @(*) begin
    if (ALUSrc) begin 
        forward_B = 2'b11; // sign extension (I-type)
    end
    else begin
        forward_B = forward_C;
    end
end

// forward_C for wdata to mem (for sw)
always @(*) begin
    if(MEM_cycle_RegWrite) begin 
        if( ID_EX_Rt == EX_MEM_Rt_or_Rd ) begin // data hazard
            forward_C = 2'b01;
        end
        else begin
            forward_C = 2'b00;
        end
    end
    else if(WB_cycle_RegWrite) begin
       if( ID_EX_Rt == MEM_WB_Rt_or_Rd ) begin 
            forward_C = 2'b10; // mem hazard
        end
        else begin
            forward_C = 2'b00;
        end
    end
    else begin
        forward_C = 2'b00;
    end    
end

/////////////////////////////////////////////////////////////////////
/*
// forward_A for Rs
always @(*) begin
    if(MEM_cycle_RegWrite) begin // data hazard
        if( ID_EX_Rs == EX_MEM_Rt_or_Rd ) begin
            forward_A = 2'b01;
        end
        else begin
            forward_A = 2'b00;
        end
    end
    else if(WB_cycle_RegWrite) begin // mem hazard
       if( ID_EX_Rs == MEM_WB_Rt_or_Rd ) begin 
            forward_A = 2'b10;
        end
        else begin
            forward_A = 2'b00;
        end
    end
    else begin
        forward_A = 2'b00;
    end    
end


// forward_B for Rt
always @(*) begin
    if (ALUSrc) begin 
        forward_B = 2'b11; // sign extension output (I-type)
    end
    else if(MEM_cycle_RegWrite) begin 
        if( ID_EX_Rt == EX_MEM_Rt_or_Rd ) begin // data hazard
            forward_B = 2'b01;
        end
        else begin
            forward_B = 2'b00;
        end
    end
    else if(WB_cycle_RegWrite) begin
       if( ID_EX_Rt == MEM_WB_Rt_or_Rd ) begin 
            forward_B = 2'b10; // mem hazard
        end
        else begin
            forward_B = 2'b00;
        end
    end
    else begin
        forward_B = 2'b00;
    end    
end

// forward_C for wdata to mem (for sw)
always @(*) begin
    if(MEM_cycle_RegWrite) begin 
        if( ID_EX_Rt == EX_MEM_Rt_or_Rd ) begin // data hazard
            forward_C = 2'b01;
        end
        else begin
            forward_C = 2'b00;
        end
    end
    else if(WB_cycle_RegWrite) begin
       if( ID_EX_Rt == MEM_WB_Rt_or_Rd ) begin 
            forward_C = 2'b10; // mem hazard
        end
        else begin
            forward_C = 2'b00;
        end
    end
    else begin
        forward_C = 2'b00;
    end    
end
*/
endmodule










