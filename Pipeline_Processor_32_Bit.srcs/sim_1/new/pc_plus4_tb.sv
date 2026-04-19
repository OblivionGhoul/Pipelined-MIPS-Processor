`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:04:26 PM
// Design Name: 
// Module Name: pc_plus4_tb
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


module pc_plus4_tb;

    logic [31:0] pc_in;
    logic [31:0] pc_out;

    pc_plus4 dut (
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    initial begin
        // Test 1: base case
        pc_in = 32'd0;
        #5;
        if (pc_out !== 32'd4)
            $display("ERROR: Expected 4, got %0d", pc_out);
        else
            $display("PASS: 0 -> 4");

        // Test 2: normal increment
        pc_in = 32'd4;
        #5;
        if (pc_out !== 32'd8)
            $display("ERROR: Expected 8, got %0d", pc_out);
        else
            $display("PASS: 4 -> 8");

        // Test 3: arbitrary value
        pc_in = 32'd100;
        #5;
        if (pc_out !== 32'd104)
            $display("ERROR: Expected 104, got %0d", pc_out);
        else
            $display("PASS: 100 -> 104");

        // Test 4: max boundary (overflow behavior)
        pc_in = 32'hFFFF_FFFC;
        #5;
        if (pc_out !== 32'h0000_0000)
            $display("ERROR: Expected wrap to 0, got %h", pc_out);
        else
            $display("PASS: overflow wraps correctly");

        // Test 5: random value
        pc_in = 32'd123456;
        #5;
        if (pc_out !== 32'd123460)
            $display("ERROR: Expected 123460, got %0d", pc_out);
        else
            $display("PASS: random test");

        $display("pc_plus4 testbench complete.");
        $stop;
    end

endmodule