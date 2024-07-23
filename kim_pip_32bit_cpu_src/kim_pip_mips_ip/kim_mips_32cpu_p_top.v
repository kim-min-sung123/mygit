module kim_mips_32cpu_p_top
(
    input   wire    clk,
    input   wire    rstn

);

//------------------------Parameter----------------------
localparam
    PC_ADDR_WIDTH = 32,
    INST_DATA_WIDTH = 32,
    INST_MEM_ADDR_WIDTH = 8, // inst mem
    INST_MEM_DATA_WIDTH = 8, // inst mem
    MIPS_REGISTER_DATA_WIDTH = 32, // DATA is instruction(32bit) and 32bit transfer per 1 transection
    MIPS_REGISTER_ADDR_WIDTH = $clog2(MIPS_REGISTER_DATA_WIDTH),
    DATA_MEM_ADDR_WIDTH = 8,
    DATA_MEM_DATA_WIDTH = 8,
    OPCODE_DATA_WIDTH = 6,
    OPERAND_ADDR_WIDTH = 5,
    CONTROLS_DATA_WIDTH = 9; 

//------------------------Local signal-------------------
wire    [8:0]                           controls_w;
wire    [8:0]                           control_mux_o;
wire    [PC_ADDR_WIDTH-1:0]             branch_add_out;
wire    [PC_ADDR_WIDTH-1:0]             branched_addr;

wire    [PC_ADDR_WIDTH-1:0]             j_addr;

wire    [PC_ADDR_WIDTH-1:0]             w_i_to_pc;
wire    [PC_ADDR_WIDTH-1:0]             w_o_by_pc;

wire                                    is_same_w; 

wire    [INST_DATA_WIDTH-1:0]           instruction;
wire    [INST_DATA_WIDTH-1:0]           instruction_reg;

wire    [PC_ADDR_WIDTH-1:0]             n_pc_addr_reg; // IF_ID output
wire    [PC_ADDR_WIDTH-1:0]             n_pc_addr; // IF_ID input, n_pc add output

wire                                    stall_w; 


wire                                    ID_EX_RegWrite; // ID_EX_FF output
wire                                    ID_EX_ALUSrc; 
wire                                    ID_EX_MemWrite; 
wire    [1:0]                           ID_EX_ALUOp; 
wire                                    ID_EX_MemtoReg; 
wire                                    ID_EX_Branch; 
wire                                    ID_EX_Jump; 
wire                                    ID_EX_RegDst; // ID_EX_FF output

wire    [DATA_MEM_DATA_WIDTH*4-1:0]     data_mem_mux_out;

wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  r_data1;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  r_data2;

wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  ID_EX_r_data1;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  ID_EX_r_data2;

wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  se_out;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  ID_EX_se_out;

wire    [5:0]                           ID_EX_funct_in;

wire    [OPERAND_ADDR_WIDTH-1:0]        ID_EX_Rs;
wire    [OPERAND_ADDR_WIDTH-1:0]        ID_EX_Rt;
wire    [OPERAND_ADDR_WIDTH-1:0]        ID_EX_Rd;

wire    [1:0]                           forwardA;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  forwardA_mux_out;
wire    [1:0]                           forwardB;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  forwardB_mux_out;
wire    [1:0]                           forwardC;

// alu
wire    [3:0]                           alu_control;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  alu_result;
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  EX_MEM_alu_result;

wire    [OPERAND_ADDR_WIDTH-1:0]        RegDst_mux_out;

wire                                    EX_MEM_RegWrite; 
wire                                    EX_MEM_MemWrite; 
wire                                    EX_MEM_MemtoReg; 

wire    [DATA_MEM_DATA_WIDTH*4-1:0]     w_data_to_mem;
wire    [DATA_MEM_DATA_WIDTH*4-1:0]     EX_MEM_w_data_to_mem;

wire    [OPERAND_ADDR_WIDTH-1:0]        EX_MEM_Rt_or_Rd;

wire    [DATA_MEM_DATA_WIDTH*4-1:0]     r_data_by_mem; // by data mem       
    

wire                                    MEM_WB_RegWrite; 
wire                                    MEM_WB_MemtoReg; 

wire    [DATA_MEM_DATA_WIDTH*4-1:0]     MEM_WB_r_data_by_mem; // by data mem   
wire    [MIPS_REGISTER_DATA_WIDTH-1:0]  MEM_WB_alu_result;
wire    [OPERAND_ADDR_WIDTH-1:0]        MEM_WB_Rt_or_Rd;



//------------------------LEFT TO RIGHT Instantiation------------------------

//-------------------------------- 1. IF cycle ------------------------------

// mux by branch
kim_mux_2to1 #(
  .MUX_DATA_WIDTH ( PC_ADDR_WIDTH )
)
 kim_mux_by_branch (
  .sel                ( control_mux_o[6] && is_same_w ), // controls[6] is Branch
  .a                  ( branch_add_out             ), 
  .b                  ( n_pc_addr                  ), // pc=pc+4
  .mux_out            ( branched_addr              )
);

// mux by jump = mux to pc
assign j_addr = {n_pc_addr_reg[31:28],instruction_reg[25:0],2'b00}; // word unit -> byte unit

kim_mux_2to1 #(
  .MUX_DATA_WIDTH ( PC_ADDR_WIDTH )
)
kim_mux_by_jump (
  .sel                ( control_mux_o[7]      ),
  .a                  ( j_addr                ), 
  .b                  ( branched_addr         ),
  .mux_out            ( w_i_to_pc             )
);

// pc
kim_pc_p #(
  .PC_ADDR_WIDTH ( PC_ADDR_WIDTH )
)
kim_pc_p_u1 (
  .clk                ( clk                   ),
  .rstn               ( rstn                  ),
  .pc_stall           ( stall_w               ),
  .pc_next            ( w_i_to_pc             ),
  .pc                 ( w_o_by_pc             )
);

// adder with pc
kim_adder_nbit_p #(
  .ADD_DATA_WIDTH ( PC_ADDR_WIDTH )
)
kim_adder_nbit_p_with_pc (
  .a                ( w_o_by_pc               ),
  .b                ( 4                       ), // 32bit unit transfer hypo
  .y                ( n_pc_addr               )
);

// instruction mem
kim_instruction_mem_p #(
  .MEM_ADDR_WIDTH ( INST_MEM_ADDR_WIDTH ),
  .MEM_DATA_WIDTH ( INST_MEM_DATA_WIDTH )
)
kim_instruction_mem_p_u1 (
  .r_addr_by_pc        ( w_o_by_pc[INST_MEM_ADDR_WIDTH-1:0] ),
  .instruction         ( instruction                        )
);

// IF_ID_FF
kim_IF_ID_FF kim_IF_ID_FF_u1 (
  .clk                ( clk                            ), 
  .rstn               ( rstn                           ), 
  .instruction        ( instruction                    ),
  .is_flush           ( control_mux_o[7] || (control_mux_o[6] && is_same_w) ), // for jump or beq
  .is_mem_hazard      ( stall_w                        ), // for mem hazard
  .pc_next_in         ( n_pc_addr                      ),
  .instruction_reg    ( instruction_reg                ),
  .pc_next_reg        ( n_pc_addr_reg                  )
);

//-------------------------------- 2. ID cycle ------------------------------

// hazard detection unit
kim_hazard_detection kim_hazard_detection_u1 (
  .ID_EX_MemtoReg           ( ID_EX_MemtoReg                 ), // input from EX cycle
  .EX_MEM_MemtoReg          ( EX_MEM_MemtoReg                ),
  .opcode                   ( instruction_reg[31:26]         ), 
  .Rs                       ( instruction_reg[25:21]         ),
  .Rt                       ( instruction_reg[20:16]         ), 
  .ID_EX_Rt                 ( ID_EX_Rt                       ), // input from EX cycle 
  .EX_MEM_Rt                ( EX_MEM_Rt_or_Rd                ),
  .stall                    ( stall_w                        )
);

// control mux with hazard detection
kim_mux_2to1 #(
  .MUX_DATA_WIDTH ( CONTROLS_DATA_WIDTH )
)
kim_mux_by_control (
  .sel                ( stall_w                 ),
  .a                  ( 0                       ),  // inst invalid
  .b                  ( controls_w              ),
  .mux_out            ( control_mux_o           )
);

// adder with branch
kim_adder_nbit_p #(
  .ADD_DATA_WIDTH ( PC_ADDR_WIDTH )
)
kim_adder_nbit_p_with_branch (
  .a                ( n_pc_addr_reg                     ),
  .b                ( {se_out[PC_ADDR_WIDTH-3:0],2'b00} ), // word unit -> byte
  .y                ( branch_add_out                    )
);

// mips control
kim_mips_control_p kim_mips_control_p_u1(
  .op_code            ( instruction_reg[INST_DATA_WIDTH-1:26] ),  
  .controls           ( controls_w                            )          
);

// mips register
kim_mips_register_p kim_mips_register_p_u1(
  .clk                 ( clk  ),  
  .rstn                ( rstn ),
  .read_to_reg1_in     ( instruction_reg[25:21] ), // about addr of mips_reg
  .read_to_reg2_in     ( instruction_reg[20:16] ), // about addr of mips_reg
  .write_to_w_reg_in   ( MEM_WB_Rt_or_Rd        ), // about addr of mips_reg
  .w_data              ( data_mem_mux_out       ),
  .RegWrite            ( MEM_WB_RegWrite        ),
  .r_data1             ( r_data1                ),
  .r_data2             ( r_data2                ) 
);

// branch compare unit
kim_branch_compare kim_branch_compare_u1 (
  .r_data1          ( r_data1       ),  
  .r_data2          ( r_data2       ),
  .is_branch        ( controls_w[6] ),
  .is_same          ( is_same_w     ) 
);

// sign extend for I type
kim_sign_extend_p kim_sign_extend_p_u1 (
  .immediate_in        ( instruction_reg[15:0]  ),  
  .immediate_out       ( se_out                 )
);


// ID_EX_FF 
//------------------------controls Info-------------------
// controls_w[0] is RegWrite
// controls_w[1] is ALUSrc
// controls_w[2] is MemWrite
// controls_w[3] is ALUOp[0]
// controls_w[4] is ALUOp[1]
// controls_w[5] is MemtoReg
// controls_w[6] is Branch
// controls_w[7] is Jump
// controls_w[8] is RegDst
kim_ID_EX_FF kim_ID_EX_FF_u1 (
  .clk                ( clk                            ),
  .rstn               ( rstn                           ), 

  .RegDst             ( control_mux_o[8]                   ),
  .MemtoReg           ( control_mux_o[5]                   ),
  .ALUOp              ( {control_mux_o[4],control_mux_o[3]}   ),
  .MemWrite           ( control_mux_o[2]                   ),
  .ALUSrc             ( control_mux_o[1]                   ),
  .RegWrite           ( control_mux_o[0]                   ),

  .r_data1            ( r_data1 ),
  .r_data2            ( r_data2 ),

  .se_in              ( se_out                          ),
  .fucnt_in           ( instruction_reg[5:0]            ),

  .IF_ID_Rs           ( instruction_reg[25:21]          ),
  .IF_ID_Rt           ( instruction_reg[20:16]          ),
  .IF_ID_Rd           ( instruction_reg[15:11]          ),
  .stall              ( stall_w                         ), // for nop ex

  .RegDst_reg         ( ID_EX_RegDst                    ),  
  .MemtoReg_reg       ( ID_EX_MemtoReg                  ),
  .ALUOp_reg          ( ID_EX_ALUOp                     ),
  .MemWrite_reg       ( ID_EX_MemWrite                  ),
  .ALUSrc_reg         ( ID_EX_ALUSrc                    ),
  .RegWrite_reg       ( ID_EX_RegWrite                  ),

  .r_data1_reg        ( ID_EX_r_data1                   ),
  .r_data2_reg        ( ID_EX_r_data2                   ),

  .se_in_reg          ( ID_EX_se_out                    ),
  .fucnt_in_reg       ( ID_EX_funct_in                  ),

  .ID_EX_Rs_reg       ( ID_EX_Rs                        ),
  .ID_EX_Rt_reg       ( ID_EX_Rt                        ),
  .ID_EX_Rd_reg       ( ID_EX_Rd                        )
);

//-------------------------------- 3. EX cycle ------------------------------

// mux by forwardA
kim_mux_3to1 #(
  .MUX_DATA_WIDTH ( MIPS_REGISTER_DATA_WIDTH )
)
kim_mux_by_forwardA (
  .sel                ( forwardA                ),
  .a                  ( ID_EX_r_data1           ),  // no hazard
  .b                  ( EX_MEM_alu_result       ),  // data hazard
  .c                  ( data_mem_mux_out        ),  // mem hazard
  .mux_out            ( forwardA_mux_out        )
);


// mux by forwardB, sign extension
kim_mux_4to1 #(
  .MUX_DATA_WIDTH ( MIPS_REGISTER_DATA_WIDTH )
)
kim_mux_by_forwardB (
  .sel                ( forwardB                ),
  .a                  ( ID_EX_r_data2           ),  // no hazard
  .b                  ( EX_MEM_alu_result       ),  // data hazard
  .c                  ( data_mem_mux_out        ),  // mem hazard
  .d                  ( ID_EX_se_out            ),  // sign extend
  .mux_out            ( forwardB_mux_out        )
);

// mux for selecting Rt or Rd
assign RegDst_mux_out = ( ID_EX_RegDst ) ? ID_EX_Rd : ID_EX_Rt ;

// alu
kim_alu_p #(
  .ALU_DATA_WIDTH ( DATA_MEM_DATA_WIDTH*4 )
)
kim_alu_p_u1 (
  .a                  ( forwardA_mux_out    ), 
  .b                  ( forwardB_mux_out    ),
  .alu_control        ( alu_control         ),
  .alu_zero           (                     ), // no use
  .alu_result         ( alu_result          )  
);

// alu control
kim_alu_control_p kim_alu_control_p_u1(
  .alu_op_in          ( ID_EX_ALUOp         ),
  .fucnt_in           ( ID_EX_funct_in      ),
  .alu_control        ( alu_control         )
);

// forwarding unit
kim_forwarding kim_forwarding_u1(
  .MEM_cycle_RegWrite ( EX_MEM_RegWrite ),// for data hazard
  .EX_MEM_Rt_or_Rd    ( EX_MEM_Rt_or_Rd ),

  .WB_cycle_RegWrite  ( MEM_WB_RegWrite ), // for mem hazard
  .MEM_WB_Rt_or_Rd    ( MEM_WB_Rt_or_Rd ),

  .ID_EX_Rs           ( ID_EX_Rs        ),
  .ID_EX_Rt           ( ID_EX_Rt        ),

  .ALUSrc             ( ID_EX_ALUSrc    ), // for immediate transfer (I-type)

  .forward_A          ( forwardA        ), // 00(no hazard),01(data hazard),10(mem hazard)
  .forward_B          ( forwardB        ), // 00(no hazard),01(data hazard),10(mem hazard),11(sign extend)
  .forward_C          ( forwardC        )
);

kim_mux_3to1 #(
  .MUX_DATA_WIDTH ( DATA_MEM_DATA_WIDTH*4 )
)
 kim_mux_by_forwardC_sw ( // for wdata to mem (wdata to mem must not be se_out)
  .sel                ( forwardC                ),
  .a                  ( ID_EX_r_data2           ),  // no hazard
  .b                  ( EX_MEM_alu_result       ),  // data hazard
  .c                  ( data_mem_mux_out        ),  // mem hazard
  .mux_out            ( w_data_to_mem           )
);

// EX_MEM_FF
kim_EX_MEM_FF kim_EX_MEM_FF_u1 (
  .clk                 ( clk                            ),
  .rstn                ( rstn                           ), 

  .MemtoReg            ( ID_EX_MemtoReg                 ),
  .MemWrite            ( ID_EX_MemWrite                 ),
  .RegWrite            ( ID_EX_RegWrite                 ),

  .alu_result          ( alu_result    ),
  .w_data_to_mem       ( w_data_to_mem ),

  .ID_EX_Rt_or_Rd      ( RegDst_mux_out                 ),

  .MemtoReg_reg        ( EX_MEM_MemtoReg                ),
  .MemWrite_reg        ( EX_MEM_MemWrite                ),
  .RegWrite_reg        ( EX_MEM_RegWrite                ),

  .alu_result_reg      ( EX_MEM_alu_result              ),
  .w_data_to_mem_reg   ( EX_MEM_w_data_to_mem           ),

  .EX_MEM_Rt_or_Rd_reg ( EX_MEM_Rt_or_Rd                )
);

//-------------------------------- 4. MEM cycle ------------------------------

// data mem
kim_data_mem_p #(
  .MEM_ADDR_WIDTH (DATA_MEM_ADDR_WIDTH),
  .MEM_DATA_WIDTH (DATA_MEM_DATA_WIDTH)
) 
kim_data_mem_p_u1 (
  .clk                ( clk                                        ), 
  .MemWrite           ( EX_MEM_MemWrite                            ),
  .w_data             ( EX_MEM_w_data_to_mem                       ),
  .addr_by_alu        ( EX_MEM_alu_result[DATA_MEM_ADDR_WIDTH-1:0] ),
  .r_data             ( r_data_by_mem                              )
);

// MEM_WB_FF
kim_MEM_WB_FF kim_MEM_WB_FF_u1 (
  .clk                 ( clk                            ),
  .rstn                ( rstn                           ), 

  .MemtoReg            ( EX_MEM_MemtoReg                ),
  .RegWrite            ( EX_MEM_RegWrite                ),

  .r_data              ( r_data_by_mem                  ),
  .alu_result          ( EX_MEM_alu_result              ),

  .EX_MEM_Rt_or_Rd     ( EX_MEM_Rt_or_Rd                ),

  .MemtoReg_reg        ( MEM_WB_MemtoReg                ),
  .RegWrite_reg        ( MEM_WB_RegWrite                ),

  .r_data_reg          ( MEM_WB_r_data_by_mem           ),
  .alu_result_reg      ( MEM_WB_alu_result              ),

  .MEM_WB_Rt_or_Rd_reg ( MEM_WB_Rt_or_Rd                )
);

//-------------------------------- 5. WB cycle ------------------------------

// mux for selecting w_data(to reg) by MemtoReg
kim_mux_2to1 #(
  .MUX_DATA_WIDTH ( MIPS_REGISTER_DATA_WIDTH )
)
 kim_mux_by_MemtoReg (
  .sel                ( MEM_WB_MemtoReg            ), 
  .a                  ( MEM_WB_r_data_by_mem       ), 
  .b                  ( MEM_WB_alu_result          ), 
  .mux_out            ( data_mem_mux_out           )
);

endmodule

