`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:00:41 PM
// Design Name: 
// Module Name: pc_tb
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


module pc_tb;

    logic clk;
    logic reset;
    logic [31:0] next_pc;
    logic [31:0] pc_out;

    pc dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initial values
        reset   = 1;
        next_pc = 32'd0;

        // Hold reset for a little bit
        #12;
        reset = 0;

        // Test 1: basic increment-style updates
        next_pc = 32'd4;
        #10;
        if (pc_out !== 32'd4)
            $display("ERROR: Expected pc_out = 4, got %0d", pc_out);
        else
            $display("PASS: pc_out = 4");

        next_pc = 32'd8;
        #10;
        if (pc_out !== 32'd8)
            $display("ERROR: Expected pc_out = 8, got %0d", pc_out);
        else
            $display("PASS: pc_out = 8");

        next_pc = 32'd12;
        #10;
        if (pc_out !== 32'd12)
            $display("ERROR: Expected pc_out = 12, got %0d", pc_out);
        else
            $display("PASS: pc_out = 12");

        // Test 2: jump to arbitrary address
        next_pc = 32'd100;
        #10;
        if (pc_out !== 32'd100)
            $display("ERROR: Expected pc_out = 100, got %0d", pc_out);
        else
            $display("PASS: pc_out = 100");

        // Test 3: reset in middle of operation
        reset = 1;
        #10;
        if (pc_out !== 32'd0)
            $display("ERROR: Expected pc_out = 0 after reset, got %0d", pc_out);
        else
            $display("PASS: reset works");

        reset = 0;
        next_pc = 32'd16;
        #10;
        if (pc_out !== 32'd16)
            $display("ERROR: Expected pc_out = 16, got %0d", pc_out);
        else
            $display("PASS: pc_out = 16 after reset release");

        $display("PC testbench complete.");
        $stop;
    end

endmodule
