`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:00:31 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


// Detects load-use hazards
// If a LW instruction is right before an instruction that needs that data, stall the pipeline for 1 clock cycle
module hazard_detection_unit (
    // Current instruction's sources in the Decode stage
    input  logic [4:0] if_id_rs,
    input  logic [4:0] if_id_rt,
    
    // Previous instruction's destination in the EX stage
    input  logic [4:0] id_ex_rt,
    input  logic id_ex_memread,
    
    // Outputs to stall the pipeline
    // 0 means stall, 1 means continues normally
    output logic pc_write,    // Controls PC
    output logic if_id_write, // Controls IF/ID register
    output logic control_mux  // Turns all ID control signals to 0
);

    always_comb begin
        // Default settings to not stall
        pc_write = 1'b1;
        if_id_write = 1'b1;
        control_mux = 1'b1;

        // If the current instruction is reading from memory and its destination register matches either of the source registers of the current instruction in ID
        if (id_ex_memread && ((id_ex_rt == if_id_rs) || (id_ex_rt == if_id_rt))) begin
            // Stall the pipeline
            pc_write = 1'b0;    // Stop fetching new instructions
            if_id_write = 1'b0; // Keep the current instruction trapped in the ID stage
            control_mux = 1'b0; // Stop the control signals to EX so it pauses
        end
    end
endmodule
