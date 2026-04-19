`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:59:23 PM
// Design Name: 
// Module Name: writeback_mux
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


// Chooses either the ALU result or memory result to send back to the register file
module writeback_mux (
    input  logic        mem_to_reg,     // 1 = Mem, 0 = ALU
    input  logic [31:0] alu_result,     // ALU result
    input  logic [31:0] read_data,      // Memory result
    output logic [31:0] write_data_out  // Output to be sent to the register file
);

    // If mem_to_reg = 1, output is read_data. Otherwise, output is alu_result
    assign write_data_out = (mem_to_reg) ? read_data : alu_result;

endmodule
