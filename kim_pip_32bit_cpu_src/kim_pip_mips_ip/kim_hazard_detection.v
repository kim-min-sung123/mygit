//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: min sung kim
// License : 
// Create Date: 24-06-14
// Design Name: kim_hazard_detection
// Module Name: kim_hazard_detection
// Project Name:
// Target Devices: 
// Tool Versions:
// Description: kim_hazard_detection
// Dependencies:
// Revision:
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module kim_hazard_detection ( // stall pip and pc no update for lw's 2cycle
    input   wire                                ID_EX_MemtoReg,
    input   wire                                EX_MEM_MemtoReg, // for 2cycle latency for beq after lw
    input   wire    [OPCODE_DATA_WIDTH-1:0]     opcode, // to prevent I and I hazard (don't compare Rt)
    input   wire    [OPERAND_ADDR_WIDTH-1:0]    Rs, 
    input   wire    [OPERAND_ADDR_WIDTH-1:0]    Rt,
    input   wire    [OPERAND_ADDR_WIDTH-1:0]    ID_EX_Rt,
    input   wire    [OPERAND_ADDR_WIDTH-1:0]    EX_MEM_Rt, // for 2cycle latency for beq after lw

    output  wire                                stall // fanout is 3   
                           
);

//------------------------Parameter----------------------
localparam
    OPCODE_DATA_WIDTH = 6,
    OPERAND_ADDR_WIDTH = 5;

//------------------------Local signal-------------------
reg     w_stall;
wire    w_MemtoReg;
wire    w_beq_hazard_en;

//------------------------Instantiation------------------

assign stall = ( w_MemtoReg && w_stall );
assign w_MemtoReg = ( ID_EX_MemtoReg || EX_MEM_MemtoReg );
assign w_beq_hazard_en = ( (Rs==EX_MEM_Rt)||(Rt==EX_MEM_Rt) );

always @(*) begin
    if( opcode == 0 ) begin // R-type. Rt is destination in I-type
        w_stall = ( ((Rs==ID_EX_Rt)||(Rt==ID_EX_Rt)) && (ID_EX_Rt) ); 
        // && (ID_EX_Rt) to prevent when front inst is nop ( ID_EX_Rt is 0 at nop )
    end
    else if(opcode == 6'b000100) begin // beq
        w_stall = (  ((Rs==ID_EX_Rt)||(Rt==ID_EX_Rt)) || w_beq_hazard_en );
    end
    else begin
        w_stall = ( ((opcode!=2)&&(Rs==ID_EX_Rt)) && (ID_EX_Rt) );  // both I and not j
    end
end


/*  another algorithm
assign stall = ( MemtoReg && w_stall );

always @(*) begin    
    if( (opcode!=2)&&(Rs == ID_EX_Rt) ) begin // R and I and not j
        w_stall = 1;
    end
    else if( opcode == 0 ) begin // work at only R-type why? Rt is destination in I-type
        if( Rt == ID_EX_Rt ) begin
            w_stall = 1;
        end
        else begin
            w_stall = 0;
        end // w_stall = (Rt == ID_EX_Rt);
    end    
    else begin
        w_stall = 0; // if I-type
    end
end
*/

endmodule