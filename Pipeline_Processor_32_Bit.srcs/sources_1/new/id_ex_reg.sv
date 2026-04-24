`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2026 
// Design Name: 
// Module Name: id_ex_reg
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
// description: after the decode stage, the values of control signals and registers
// will be passed along to the execute stage if there is no stall or flush hazard handling on clocks edge

module id_ex_reg(
    input logic clk,
    input logic rst, // reset 
    input logic stall, // if stall = 1 = hold, hold values in pipeline, hazard detection
    input logic clear, // if clear = 1 = bubble, clear all pipeline values, used for hazard detection
    
    // previous control signals from control_unit.sv
    input logic reg_dst_in,   // destination write back rd or rt
    input logic alu_src_in,   // second input rt or immediate value
    input logic mem_to_reg_in,// write memory back to reg
    input logic reg_write_in, // register file write enable
    input logic mem_read_in,  // read enable
    input logic mem_write_in, // write enable
    input logic branch_in,  // branch instruction coming in
    input logic [1:0] alu_op_in, // alu opcode for operation type
    
    // datapath decode values
    input logic [31:0] pc_plus4_in, //32 bits add 4 to pc counter
    input logic [31:0] rs_value_in, // value in rs register
    input logic [31:0] rt_value_in, // value in rt register
    input logic [31:0] imm_extend_in, // value from immidiate extend
    input logic [4:0] rs_in, // 5 bits // register num
    input logic [4:0] rt_in, // register num
    input logic [4:0] rd_in, // register num
    input logic [5:0] function_in,  // 6 bits // r-type function field bits to identify
    
    // outputs going to execute stage
    output logic reg_dst_out,   // destination write back rd or rt
    output logic alu_src_out,   // second input rt or immediate value
    output logic mem_to_reg_out,// write memory back to reg
    output logic reg_write_out, // register file write enable
    output logic mem_read_out,  // read enable
    output logic mem_write_out, // write enable
    output logic branch_out,  // branch instruction coming in
    output logic [1:0] alu_op_out,
    
    // all stored values going to execute stage
    // cannot keep same signal because of clk edge updating
    output logic [31:0] pc_plus4_out, //32 bits add 4 to pc counter
    output logic [31:0] rs_value_out, // value in rs register
    output logic [31:0] rt_value_out, // value in rt register
    output logic [31:0] imm_extend_out, // value from immidiate extend
    output logic [4:0] rs_out, // 5 bits // register num
    output logic [4:0] rt_out, // register num
    output logic [4:0] rd_out, // register num
    output logic [5:0] function_out // type of operation
        
    );
    
    always_ff @(posedge clk) begin // do updates and work on clocks pos edge
        if(rst == 1 || clear == 1) begin // if reset or clean is 1, then we clear all outputs
            reg_dst_out <= 1'b0;      // same as adding bubble or NOP, which is a hold on the pipeline for hazard detection
            alu_src_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            alu_op_out <= 2'b00;

            pc_plus4_out <= 32'd0;
            rs_value_out <= 32'd0;
            rt_value_out <= 32'd0;
            imm_extend_out <= 32'd0;
            rs_out <= 5'd0;
            rt_out <= 5'd0;
            rd_out <= 5'd0;
            function_out <= 6'd0;    
        end
        
        else if (stall == 0) begin // if there is no stall then update out variables to go to execution stage registers
            reg_dst_out <= reg_dst_in;
            alu_src_out <= alu_src_in;
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_out <= branch_in;
            alu_op_out <= alu_op_in;

            pc_plus4_out <= pc_plus4_in;
            rs_value_out <= rs_value_in;
            rt_value_out <= rt_value_in;
            imm_extend_out <= imm_extend_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
            function_out <= function_in;
        end
        // if there is a stall we do nothing and old values stay in the pipeline
    end
endmodule
