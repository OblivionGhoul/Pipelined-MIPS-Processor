`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:58:20 PM
// Design Name: 
// Module Name: data_mem
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


// The data memory that is used by LW (load word) and SW (store word)
module data_mem (
    input  logic        clk,
    input  logic        mem_read,   // 1 if LW
    input  logic        mem_write,  // 1 if SW
    input  logic [31:0] address,    // Address of result
    input  logic [31:0] write_data, // The data that will be stored into memory (for SW)
    output logic [31:0] read_data   // The data that will be retrieved from memory (for LW)
);

    // Array for memory (256 words by 32-bits)
    logic [31:0] memory_array [0:255];

    // Initialize all elements in memory array to 0
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory_array[i] = 32'b0;
        end
    end

    // If mem_read is high, output the data at the address from the memory
    always_comb begin
        if (mem_read) begin
            read_data = memory_array[address >> 2]; // (address >> 2) because MIPS is byte-addressed
        end else begin
            read_data = 32'b0; // If mem_read is low, output remains 0
        end
    end

    // Write data into memory array at positive clock edge
    always_ff @(posedge clk) begin
        if (mem_write) begin
            memory_array[address >> 2] <= write_data;
        end
    end

endmodule
