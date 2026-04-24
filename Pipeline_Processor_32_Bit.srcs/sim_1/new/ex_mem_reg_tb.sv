`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:11:45 PM
// Design Name: 
// Module Name: ex_mem_reg_tb
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


module ex_mem_reg_tb;
    // Register for inputs
    reg clk, reset;
    reg wb_regwrite_in, wb_memtoreg_in, m_memread_in, m_memwrite_in;
    reg [31:0] alu_result_in, write_data_in;
    reg [4:0] write_reg_in;
    
    // Wire for outputs
    wire wb_regwrite_out, wb_memtoreg_out, m_memread_out, m_memwrite_out;
    wire [31:0] alu_result_out, write_data_out;
    wire [4:0] write_reg_out;

    // Connect testbench to the design
    ex_mem_reg dut (.*);

    // Create and toggle the clock every 5 ns
    always #5 clk = ~clk;

    initial begin
        // Log changes
        $monitor("Time=%0t | clk=%b rst=%b | in_alu=%0d | out_alu=%0d", $time, clk, reset, alu_result_in, alu_result_out);
        
        // Initialize inputs and reset the register
        clk = 0; 
        reset = 1; 
        wb_regwrite_in=0; wb_memtoreg_in=0; m_memread_in=0; m_memwrite_in=0;
        alu_result_in=0; write_data_in=0; write_reg_in=0;
        #10;
        
        // Test 1: Disable reset and put data in
        // ALU result is 42, write data 99, write at register 7
        reset = 0;
        alu_result_in = 32'd42; write_data_in = 32'd99; write_reg_in = 5'd7;
        m_memwrite_in = 1;
        #10;

        // Test 2: Change ALU result to 100, outputs should change at the next clock rising edge
        alu_result_in = 32'd100;
        #10;
        
        $finish;
    end
endmodule
