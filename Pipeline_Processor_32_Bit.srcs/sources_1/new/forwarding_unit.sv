`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:59:54 PM
// Design Name: 
// Module Name: forwarding_unit
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


// Detects data hazards and forwards data from the EX/MEM or MEM/WB pipeline registers to the ALU inputs to avoid stalling.
module forwarding_unit (
    // What the ALU currently needs to process
    input  logic [4:0] id_ex_rs, 
    input  logic [4:0] id_ex_rt,
    
    // The instruction in the MEM stage that is writing back
    input  logic [4:0] ex_mem_rd,
    input  logic ex_mem_regwrite,
    
    // The instruction in the WB stage that is writing back
    input  logic [4:0] mem_wb_rd,
    input  logic mem_wb_regwrite,
    
    // Outputs that controls the ALU input muxes
    // 00 = Normal, 10 = Forward from EX/MEM, 01 = Forward from MEM/WB
    output logic [1:0] forward_a, // Controls ALU input A (rs)
    output logic [1:0] forward_b  // Controls ALU input B (rt)
);

    always_comb begin
        // Set the default to no forwarding (00)
        forward_a = 2'b00;
        forward_b = 2'b00;

        // Forward from the pipeline register right after ALU
        // Check if MEM stage is writing to the register that is currently needed
        // Ensure system is not forwarding register 0
        
        // Forward A logic - rs
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs)) begin
            forward_a = 2'b10;
        end
        // Check for a MEM Hazard in the WB stage if EX stage didn't forward it yet
        else if (mem_wb_regwrite && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs)) begin
            forward_a = 2'b01;
        end

        // Forward B logic (same as forward A logic, but for the other ALU input - rt)
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rt)) begin
            forward_b = 2'b10;
        end
        else if (mem_wb_regwrite && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rt)) begin
            forward_b = 2'b01;
        end
    end
endmodule
