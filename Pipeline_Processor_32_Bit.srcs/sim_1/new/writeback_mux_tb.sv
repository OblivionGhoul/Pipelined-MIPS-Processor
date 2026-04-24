`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:09:48 PM
// Design Name: 
// Module Name: writeback_mux_tb
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


module writeback_mux_tb;
    // Registers for inputs
    reg mem_to_reg;
    reg [31:0] alu_result;
    reg [31:0] read_data;
    
    // Wire for output
    wire [31:0] write_data_out;
    
    // Connect testbench to the design
    writeback_mux dut (.mem_to_reg(mem_to_reg), .alu_result(alu_result), .read_data(read_data), .write_data_out(write_data_out));

    initial begin
        // Log changes
        $monitor("Time=%0t | mem_to_reg=%b alu_result=%0d read_data=%0d | write_data_out=%0d", $time, mem_to_reg, alu_result, read_data, write_data_out);

        // Test Case 1: Select the ALU result (Expected output: 100)
        mem_to_reg = 0; alu_result = 32'd100; read_data = 32'd200; 
        #10;
        
        // Test Case 2: Select Memory data result (Expected output: 200)
        mem_to_reg = 1; alu_result = 32'd100; read_data = 32'd200; 
        #10;
        
        $finish;
    end
endmodule
