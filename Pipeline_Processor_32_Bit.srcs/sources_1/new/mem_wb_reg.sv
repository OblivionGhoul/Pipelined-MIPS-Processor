`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:58:51 PM
// Design Name: 
// Module Name: mem_wb_reg
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


// Separates Memory and Writeback stages
module mem_wb_reg (
    input  logic clk,
    input  logic reset,
    
    // Input control signals from MEM stage
    input  logic wb_regwrite_in,
    input  logic wb_memtoreg_in,
    
    // Input data from MEM stage
    input  logic [31:0] read_data_in,  // Data pulled from memory
    input  logic [31:0] alu_result_in, // ALU result
    input  logic [4:0] write_reg_in,   // Destination register address
    
    // Output control signals to WB stage
    output logic wb_regwrite_out,
    output logic wb_memtoreg_out,
    
    // Output data to WB stage
    output logic [31:0] read_data_out,
    output logic [31:0] alu_result_out,
    output logic [4:0] write_reg_out
);
    
    // Look for positive edge of clock or reset signal
    always_ff @(posedge clk or posedge reset) begin
        // If reset is high, set everything to 0
        if (reset) begin
            wb_regwrite_out <= 1'b0;
            wb_memtoreg_out <= 1'b0;
            read_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            write_reg_out <= 5'b0;
        end else begin
            // At the positive edge of clock, pass inputs into outputs
            wb_regwrite_out <= wb_regwrite_in;
            wb_memtoreg_out <= wb_memtoreg_in;
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_out <= write_reg_in;
        end
    end
endmodule
