`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:20:39 PM
// Design Name: 
// Module Name: pc_pc_plus4_tb
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


module pc_pc_plus4_tb;

    logic clk;
    logic reset;
    logic [31:0] pc_out;
    logic [31:0] next_pc;

    pc pc_dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    pc_plus4 plus4_dut (
        .pc_in(pc_out),
        .pc_out(next_pc)
    );

    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;

        // Hold reset
        #12;
        reset = 0;

        // After reset, PC should start at 0
        #1;
        if (pc_out !== 32'd0)
            $display("ERROR: Expected pc_out = 0 after reset, got %0d", pc_out);
        else
            $display("PASS: PC starts at 0");

        // 1st clock after reset: PC should become 4
        #9;
        if (pc_out !== 32'd4)
            $display("ERROR: Expected pc_out = 4, got %0d", pc_out);
        else
            $display("PASS: PC incremented to 4");

        // Next clock: PC should become 8
        #10;
        if (pc_out !== 32'd8)
            $display("ERROR: Expected pc_out = 8, got %0d", pc_out);
        else
            $display("PASS: PC incremented to 8");

        // Next clock: PC should become 12
        #10;
        if (pc_out !== 32'd12)
            $display("ERROR: Expected pc_out = 12, got %0d", pc_out);
        else
            $display("PASS: PC incremented to 12");

        // Next clock: PC should become 16
        #10;
        if (pc_out !== 32'd16)
            $display("ERROR: Expected pc_out = 16, got %0d", pc_out);
        else
            $display("PASS: PC incremented to 16");

        // Confirm combinational next_pc value also looks correct
        #1;
        if (next_pc !== 32'd20)
            $display("ERROR: Expected next_pc = 20, got %0d", next_pc);
        else
            $display("PASS: next_pc correctly shows pc_out + 4");

        // Reset again during operation
        reset = 1;
        #10;
        if (pc_out !== 32'd0)
            $display("ERROR: Expected pc_out = 0 after second reset, got %0d", pc_out);
        else
            $display("PASS: Reset works during operation");

        reset = 0;
        #10;
        if (pc_out !== 32'd4)
            $display("ERROR: Expected pc_out = 4 after reset release, got %0d", pc_out);
        else
            $display("PASS: PC resumes counting after reset");

        $display("pc + pc_plus4 integration test complete.");
        $stop;
    end

endmodule