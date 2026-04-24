`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 12:47:39 PM
// Design Name: 
// Module Name: top_level
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
// Matthew Bernardino
// description: top level that instantiates all the files together

module decode_ex(
    // standard clk and reset variables
    input logic clk,
    input logic rst, // reset so if 1 then reset all reg to 0

    // hazard variables
    input logic stall, // hold values, do not continue in pipeline
    input logic clear, // flush set all reg to 0

    // inputs coming from instruction fetch to decode stage 
    input logic [31:0] instruction_in,   // current instruction in decode stage 32 bit
    input logic [31:0] pc_plus4_in,    // PC + 4 for current instruction 32 bit address

    // writeback inputs coming from memory stage
    input logic wb_reg_write,
    input logic [4:0]  wb_write_reg,
    input logic [31:0] wb_write_value,

    // outputs going from decode to memory stage 
    output logic mem_to_reg_out,
    output logic reg_write_out,
    output logic mem_read_out,
    output logic mem_write_out,
    output logic branch_out,
    output logic jump_out,

    output logic [31:0] pc_plus4_out,
    output logic [31:0] alu_result_out,
    output logic [31:0] rt_value_out,     
    output logic [31:0] imm_extend_out,
    output logic [4:0]  write_reg_out,
    output logic check_out //beq use from alu 
    
    );
    
    // need to make wires for instruction breakdown into bit fields
    logic [5:0] opcode;
    logic [4:0] rs;
    logic [4:0] rt;
    logic [4:0] rd;
    logic [5:0] funct;
    
    // assign the variables to their bit fields within the 32 bit instruction address
    assign opcode = instruction_in[31:26];
    assign rs = instruction_in[25:21];
    assign rt = instruction_in[20:16];
    assign rd = instruction_in[15:11];
    assign funct = instruction_in[5:0];
    
    // decode stage wires
    logic reg_dst_decode;
    logic alu_src_decode;
    logic mem_to_reg_decode;
    logic reg_write_decode;
    logic mem_read_decode;
    logic mem_write_decode;
    logic branch_decode;
    logic jump_decode;
    logic [1:0] alu_op_decode;

    logic [31:0] rs_value_decode;
    logic [31:0] rt_value_decode;
    logic [31:0] imm_extend_decode;

    
    // decode to execute stage wires dte
    logic reg_dst_dte;
    logic alu_src_dte;
    logic mem_to_reg_dte;
    logic reg_write_dte;
    logic mem_read_dte;
    logic mem_write_dte;
    logic branch_dte;
    logic [1:0] alu_op_dte;

    logic [31:0] pc_plus4_dte;
    logic [31:0] rs_value_dte;
    logic [31:0] rt_value_dte;
    logic [31:0] imm_extend_dte;
    logic [4:0] rs_dte;
    logic [4:0] rt_dte;
    logic [4:0] rd_dte;
    logic [5:0] function_dte;

    // execute stage wires
    logic [2:0] alu_ctrl_signal_execute;
    logic [31:0] alu_ipb_execute; // used for non rtype value for immediate use or with offset like lw, sw
    logic [4:0] write_reg_execute;
    
    
    // control unit file instantiation
    control_unit ctrl_unit_inst(
        .opcode(opcode),
        .reg_dst(reg_dst_decode),
        .alu_src(alu_src_decode),
        .mem_to_reg(mem_to_reg_decode),
        .reg_write(reg_write_decode),
        .mem_read(mem_read_decode),
        .mem_write(mem_write_decode),
        .branch(branch_decode),
        .jump(jump_decode),
        .alu_op(alu_op_decode)
    );

    // register file instantiation
    reg_file reg_file_inst(
        .clk(clk),
        .rst(rst),
        .reg_write(wb_reg_write),
        .rs_reg(rs),
        .rt_reg(rt),
        .rd_reg(wb_write_reg),
        .write_data(wb_write_value),
        .rs_value(rs_value_decode),
        .rt_value(rt_value_decode)
    );

    // immediate handle file instantiation
    imm_handle imm_handle_inst(
        .instruction32(instruction_in),
        .imm_extend(imm_extend_decode)
    );

    // decode to execute file instantiation
    id_ex_reg id_ex_inst(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .clear(clear),

        .reg_dst_in(reg_dst_decode),
        .alu_src_in(alu_src_decode),
        .mem_to_reg_in(mem_to_reg_decode),
        .reg_write_in(reg_write_decode),
        .mem_read_in(mem_read_decode),
        .mem_write_in(mem_write_decode),
        .branch_in(branch_decode),
        .alu_op_in(alu_op_decode),

        .pc_plus4_in(pc_plus4_in),
        .rs_value_in(rs_value_decode),
        .rt_value_in(rt_value_decode),
        .imm_extend_in(imm_extend_decode),
        .rs_in(rs),
        .rt_in(rt),
        .rd_in(rd),
        .function_in(funct),

        .reg_dst_out(reg_dst_dte),
        .alu_src_out(alu_src_dte),
        .mem_to_reg_out(mem_to_reg_dte),
        .reg_write_out(reg_write_dte),
        .mem_read_out(mem_read_dte),
        .mem_write_out(mem_write_dte),
        .branch_out(branch_dte),
        .alu_op_out(alu_op_dte),

        .pc_plus4_out(pc_plus4_dte),
        .rs_value_out(rs_value_dte),
        .rt_value_out(rt_value_dte),
        .imm_extend_out(imm_extend_dte),
        .rs_out(rs_dte),
        .rt_out(rt_dte),
        .rd_out(rd_dte),
        .function_out(function_dte)
    );

    // ALU control file instantiation
    alu_control alu_ctrl_inst(
        .alu_op(alu_op_dte),
        .funct_op(function_dte),
        .alu_ctrl_signal(alu_ctrl_signal_execute)
    );

    // for input b in alu, choose between immediate and rt value
    always_comb begin
        if (alu_src_dte == 1) begin // when 1, use the immediate exentended value
            alu_ipb_execute = imm_extend_dte; // update the variable to go into alu
        end 
        else begin // if 0 then use the rt register value
            alu_ipb_execute = rt_value_dte; // update the variable to go into alu
        end
    end

    // ALU
    alu alu_inst(
        .a(rs_value_dte),
        .b(alu_ipb_execute),
        .alu_ctrl_signal(alu_ctrl_signal_execute),
        .op(alu_result_out),
        .check(check_out)
    );

    // in execute stage, mux that selects the register destination, determines which register to write back 
    always_comb begin
        if (reg_dst_dte == 1) begin // when destination register is 1, rd for r type instructions will be used
            write_reg_execute = rd_dte;
        end
        else begin
            write_reg_execute = rt_dte; // when destination register is 0, rt for i type instructions will be used
        end
    end
    

    // outputs from top level to next stage
    assign mem_to_reg_out = mem_to_reg_dte;
    assign reg_write_out  = reg_write_dte;
    assign mem_read_out   = mem_read_dte;
    assign mem_write_out  = mem_write_dte;
    assign branch_out     = branch_dte;
    assign jump_out       = jump_decode;

    assign pc_plus4_out   = pc_plus4_dte;
    assign rt_value_out   = rt_value_dte;
    assign imm_extend_out = imm_extend_dte;
    assign write_reg_out  = write_reg_execute;
    
endmodule
