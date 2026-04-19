`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 01:10:28 PM
// Design Name: 
// Module Name: Pipeline_Processor_32_Bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Pipeline_Processor_32_Bit (
    input logic clk,
    input logic reset
);

    // Create wires and connect everything

    // Hazard and forwarding signals
    logic pc_write, if_id_write, control_mux;
    logic [1:0] forward_a, forward_b;

    // IF (Instruction Fetch) signals
    logic [31:0] pc_out, next_pc, pc_plus4, if_instr;
    
    // Freeze PC if Hazard Unit reads pc_write = 0
    logic [31:0] actual_next_pc;
    assign actual_next_pc = pc_write ? next_pc : pc_out;

    // ID (Instruction Decode) signals
    logic [31:0] id_instr, id_pc_plus4;
    logic if_id_flush; // Clear fetch stage if branch or jump commands used

    // Freeze or flush IF/ID register
    logic [31:0] next_id_instr, next_id_pc_plus4;
    assign next_id_instr = if_id_flush ? 32'd0 : (if_id_write ? if_instr : id_instr);
    assign next_id_pc_plus4 = if_id_flush ? 32'd0 : (if_id_write ? pc_plus4 : id_pc_plus4);

    logic [4:0] rs, rt, rd;
    logic [5:0] opcode, funct;
    assign rs     = id_instr[25:21];
    assign rt     = id_instr[20:16];
    assign rd     = id_instr[15:11];
    assign opcode = id_instr[31:26];
    assign funct  = id_instr[5:0];

    logic [31:0] rs_value, rt_value, imm_extend;
    logic reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    logic [2:0] alu_op;

    // ID/EX control hazard mux
    // If control_mux = 0, stall and flush all control signals to 0
    logic id_reg_dst, id_alu_src, id_mem_to_reg, id_reg_write, id_mem_read, id_mem_write, id_branch;
    logic [2:0] id_alu_op;
    
    assign id_reg_dst    = control_mux ? reg_dst    : 1'b0;
    assign id_alu_src    = control_mux ? alu_src    : 1'b0;
    assign id_mem_to_reg = control_mux ? mem_to_reg : 1'b0;
    assign id_reg_write  = control_mux ? reg_write  : 1'b0;
    assign id_mem_read   = control_mux ? mem_read   : 1'b0;
    assign id_mem_write  = control_mux ? mem_write  : 1'b0;
    assign id_branch     = control_mux ? branch     : 1'b0;
    assign id_alu_op     = control_mux ? alu_op     : 3'b000;

    // EX (Execute) signals
    logic id_ex_reg_dst, id_ex_alu_src, id_ex_mem_to_reg, id_ex_reg_write;
    logic id_ex_mem_read, id_ex_mem_write, id_ex_branch;
    logic [2:0] id_ex_alu_op;
    logic [31:0] id_ex_pc_plus4, id_ex_rs_value, id_ex_rt_value, id_ex_imm_extend;
    logic [4:0] id_ex_rs, id_ex_rt, id_ex_rd;
    logic [5:0] id_ex_funct;
    logic id_ex_clear;

    logic [3:0] alu_ctrl;
    logic [31:0] alu_in_a, alu_in_b_temp, alu_in_b, alu_result;
    logic alu_check;
    logic [4:0] ex_write_reg;

    // MEM (Memory) signals
    logic ex_mem_wb_regwrite, ex_mem_wb_memtoreg, ex_mem_m_memread, ex_mem_m_memwrite;
    logic [31:0] ex_mem_alu_result, ex_mem_write_data, read_data;
    logic [4:0] ex_mem_write_reg;

    // WB (Writeback) signals
    logic mem_wb_regwrite, mem_wb_memtoreg;
    logic [31:0] mem_wb_read_data, mem_wb_alu_result, write_data_out;
    logic [4:0] mem_wb_write_reg;

    // Instantiate all modules

    // Instruction fetch
    pc pc_inst (.clk(clk), .reset(reset), .next_pc(actual_next_pc), .pc_out(pc_out));
    pc_plus4 pc_plus4_inst (.pc_in(pc_out), .pc_out(pc_plus4));
    instr_mem imem_inst (.addr(pc_out), .instr(if_instr));

    if_id_reg if_id_inst (.clk(clk), .reset(reset), .if_instr(next_id_instr), .if_pc_plus4(next_id_pc_plus4), .id_instr(id_instr), .id_pc_plus4(id_pc_plus4));

    // Instruction decode
    control_unit ctrl_inst (.opcode(opcode), .reg_dst(reg_dst), .alu_src(alu_src), .mem_to_reg(mem_to_reg), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch), .jump(jump), .alu_op(alu_op));

    reg_file reg_inst (.clk(clk), .rst(reset), .reg_write(mem_wb_regwrite), .rs_reg(rs), .rt_reg(rt), .rd_reg(mem_wb_write_reg), .write_data(write_data_out), .rs_value(rs_value), .rt_value(rt_value));

    imm_handle imm_inst (.instruction32(id_instr), .imm_extend(imm_extend));

    id_ex_reg id_ex_inst (
        .clk(clk), .rst(reset), .stall(~pc_write), .clear(id_ex_clear),
        .reg_dst_in(id_reg_dst), .alu_src_in(id_alu_src), .mem_to_reg_in(id_mem_to_reg),
        .reg_write_in(id_reg_write), .mem_read_in(id_mem_read), .mem_write_in(id_mem_write),
        .branch_in(id_branch), .alu_op_in(id_alu_op),
        .pc_plus4_in(id_pc_plus4), .rs_value_in(rs_value), .rt_value_in(rt_value),
        .imm_extend_in(imm_extend), .rs_in(rs), .rt_in(rt), .rd_in(rd), .function_in(funct),
        .reg_dst_out(id_ex_reg_dst), .alu_src_out(id_ex_alu_src), .mem_to_reg_out(id_ex_mem_to_reg),
        .reg_write_out(id_ex_reg_write), .mem_read_out(id_ex_mem_read), .mem_write_out(id_ex_mem_write),
        .branch_out(id_ex_branch), .alu_op_out(id_ex_alu_op),
        .pc_plus4_out(id_ex_pc_plus4), .rs_value_out(id_ex_rs_value), .rt_value_out(id_ex_rt_value),
        .imm_extend_out(id_ex_imm_extend), .rs_out(id_ex_rs), .rt_out(id_ex_rt), .rd_out(id_ex_rd),
        .function_out(id_ex_funct)
    );

    // Execute
    alu_control alu_c_inst (.alu_op(id_ex_alu_op), .funct_op(id_ex_funct), .alu_ctrl_signal(alu_ctrl));

    // Muxes for forwarding
    always_comb begin
        // Mux for ALU Input A
        case(forward_a)
            2'b10: alu_in_a = ex_mem_alu_result; // Forward from EX/MEM
            2'b01: alu_in_a = write_data_out;    // Forward from MEM/WB
            default: alu_in_a = id_ex_rs_value;  // Normal
        endcase
        // Mux for ALU Input B (Pre-Immediate Mux)
        case(forward_b)
            2'b10: alu_in_b_temp = ex_mem_alu_result; 
            2'b01: alu_in_b_temp = write_data_out;    
            default: alu_in_b_temp = id_ex_rt_value;  
        endcase
    end

    // Selects between register or immediate value for ALU
    assign alu_in_b = id_ex_alu_src ? id_ex_imm_extend : alu_in_b_temp;

    alu alu_inst (.a(alu_in_a), .b(alu_in_b), .alu_ctrl_signal(alu_ctrl), .op(alu_result), .check(alu_check));

    // Register destination mux
    assign ex_write_reg = id_ex_reg_dst ? id_ex_rd : id_ex_rt;

    // Branch and jump logic
    logic [31:0] branch_target, jump_target;
    logic pc_src;

    assign branch_target = id_ex_pc_plus4 + (id_ex_imm_extend << 2);
    assign jump_target = {id_pc_plus4[31:28], id_instr[25:0], 2'b00};
    assign pc_src = id_ex_branch & alu_check; // If branch instruction AND alu is zero

    // If jump or branch command used, clear the old instruction fetching
    assign if_id_flush = pc_src | jump;
    assign id_ex_clear = pc_src;

    // Next PC mux
    assign next_pc = jump ? jump_target : (pc_src ? branch_target : pc_plus4);

    // Memory modules
    ex_mem_reg ex_mem_inst (
        .clk(clk), .reset(reset),
        .wb_regwrite_in(id_ex_reg_write), .wb_memtoreg_in(id_ex_mem_to_reg),
        .m_memread_in(id_ex_mem_read), .m_memwrite_in(id_ex_mem_write),
        .alu_result_in(alu_result), .write_data_in(alu_in_b_temp), .write_reg_in(ex_write_reg),
        .wb_regwrite_out(ex_mem_wb_regwrite), .wb_memtoreg_out(ex_mem_wb_memtoreg),
        .m_memread_out(ex_mem_m_memread), .m_memwrite_out(ex_mem_m_memwrite),
        .alu_result_out(ex_mem_alu_result), .write_data_out(ex_mem_write_data),
        .write_reg_out(ex_mem_write_reg)
    );

    data_mem dmem_inst (.clk(clk), .mem_read(ex_mem_m_memread), .mem_write(ex_mem_m_memwrite), .address(ex_mem_alu_result), .write_data(ex_mem_write_data), .read_data(read_data));

    // Writeback modules
    mem_wb_reg mem_wb_inst (
        .clk(clk), .reset(reset), .wb_regwrite_in(ex_mem_wb_regwrite), .wb_memtoreg_in(ex_mem_wb_memtoreg),
        .read_data_in(read_data), .alu_result_in(ex_mem_alu_result), .write_reg_in(ex_mem_write_reg),
        .wb_regwrite_out(mem_wb_regwrite), .wb_memtoreg_out(mem_wb_memtoreg),
        .read_data_out(mem_wb_read_data), .alu_result_out(mem_wb_alu_result),
        .write_reg_out(mem_wb_write_reg)
    );

    writeback_mux wb_mux_inst (.mem_to_reg(mem_wb_memtoreg), .alu_result(mem_wb_alu_result),.read_data(mem_wb_read_data), .write_data_out(write_data_out));

    // Traffic controller modules
    forwarding_unit fwd_inst (.id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt),.ex_mem_rd(ex_mem_write_reg), .ex_mem_regwrite(ex_mem_wb_regwrite),.mem_wb_rd(mem_wb_write_reg), .mem_wb_regwrite(mem_wb_regwrite),.forward_a(forward_a), .forward_b(forward_b));

    hazard_detection_unit hdu_inst (.if_id_rs(rs), .if_id_rt(rt),.id_ex_rt(id_ex_rt), .id_ex_memread(id_ex_mem_read),.pc_write(pc_write), .if_id_write(if_id_write), .control_mux(control_mux));

endmodule
