`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:57:10 PM
// Design Name: 
// Module Name: ex_mem_reg
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

// Separates the Execute and Memory stages
// It passes control signals, the ALU result, and data to be written to memory
module ex_mem_reg (
    input  logic clk,
    input  logic reset,
    
    // Input control signals from EX stage
    input  logic wb_regwrite_in, // Writeback control
    input  logic wb_memtoreg_in, // Writeback control
    input  logic m_memread_in,   // Memory read
    input  logic m_memwrite_in,  // Memory write
    
    // Input data from EX stage
    input  logic [31:0] alu_result_in,  // ALU result
    input  logic [31:0] write_data_in,  // Data to store in RAM
    input  logic [4:0] write_reg_in,    // Destination register address
    
    // Output control signals for MEM stage
    output logic wb_regwrite_out,
    output logic wb_memtoreg_out,
    output logic m_memread_out,
    output logic m_memwrite_out,
    
    // Output data for MEM stage
    output logic [31:0] alu_result_out,
    output logic [31:0] write_data_out,
    output logic [4:0] write_reg_out
);

    // Look for positive edge of clock or reset signal
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // If reset is high, set everything to 0
            wb_regwrite_out <= 1'b0;
            wb_memtoreg_out <= 1'b0;
            m_memread_out <= 1'b0;
            m_memwrite_out <= 1'b0;
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            write_reg_out <= 5'b0;
        end else begin
            // At the positive edge of clock, pass inputs into outputs
            wb_regwrite_out <= wb_regwrite_in;
            wb_memtoreg_out <= wb_memtoreg_in;
            m_memread_out <= m_memread_in;
            m_memwrite_out <= m_memwrite_in;
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            write_reg_out <= write_reg_in;
        end
    end
endmodule
