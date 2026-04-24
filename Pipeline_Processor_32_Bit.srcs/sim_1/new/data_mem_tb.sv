`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:13:06 PM
// Design Name: 
// Module Name: data_mem_tb
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


module data_mem_tb;
    // Register for inputs
    reg clk;
    reg mem_read, mem_write;
    reg [31:0] address;
    reg [31:0] write_data;
    
    // Wire for output
    wire [31:0] read_data;

    // Connect testbench to the design
    data_mem dut (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), .address(address), .write_data(write_data), .read_data(read_data));

    // Create and toggle the clock every 5 ns
    always #5 clk = ~clk;

    initial begin
        // Log changes
        $monitor("Time=%0t | clk=%b R=%b W=%b Addr=%0d WData=%0d | RData=%0d", $time, clk, mem_read, mem_write, address, write_data, read_data);

        // Initialize inputs
        clk = 0; mem_read = 0; mem_write = 0; address = 0; write_data = 0;
        #10;

        // Test 1: Write data (12345) to memory address 4 (Word 1)
        mem_write = 1;
        address = 32'd4;
        write_data = 32'd12345;
        #10;

        // Test 2: Read data back from memory address 4 (data should be 12345)
        mem_write = 0; // Disable write
        mem_read = 1;  // Enable read
        address = 32'd4;
        #10;

        // Test 3: Read data from empty memory (address 8)
        address = 32'd8;
        #10;

        $finish;
    end
endmodule
