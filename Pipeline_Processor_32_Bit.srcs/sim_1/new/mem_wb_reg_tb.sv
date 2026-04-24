`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:12:10 PM
// Design Name: 
// Module Name: mem_wb_reg_tb
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


module mem_wb_reg_tb;
    // Register for inputs
    reg clk, reset;
    reg wb_regwrite_in, wb_memtoreg_in;
    reg [31:0] read_data_in, alu_result_in;
    reg [4:0] write_reg_in;
        
    // Wire for outputs
    wire wb_regwrite_out, wb_memtoreg_out;
    wire [31:0] read_data_out, alu_result_out;
    wire [4:0] write_reg_out;
    
    // Connect testbench to the design
    mem_wb_reg dut (.*); 

    // Create and toggle the clock every 5 ns
    always #5 clk = ~clk;

    initial begin
        // Log changes
        $monitor("Time=%0t | clk=%b rst=%b | in_read=%0d in_alu=%0d | out_read=%0d out_alu=%0d", $time, clk, reset, read_data_in, alu_result_in, read_data_out, alu_result_out);
        
        // Initialize inputs and activate reset signal
        clk = 0; reset = 1; 
        wb_regwrite_in = 0; wb_memtoreg_in = 0;
        read_data_in = 0; alu_result_in = 0; write_reg_in = 0;
        #10; 
        
        // Test 1: Disable reset and put data in
        // Read data is 500, ALU result is 42, register is 10
        reset = 0;
        read_data_in = 32'd500; alu_result_in = 32'd42; write_reg_in = 5'd10;
        wb_regwrite_in = 1; wb_memtoreg_in = 1;
        #10; 

        // Test 2: Activate reset signal, outputs should reset to 0
        reset = 1;
        #10;

        $finish;
    end
endmodule
