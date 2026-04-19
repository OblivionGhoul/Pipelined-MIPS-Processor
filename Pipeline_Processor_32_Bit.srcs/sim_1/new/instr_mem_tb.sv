`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:10:12 PM
// Design Name: 
// Module Name: instr_mem_tb
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

module instr_mem_tb;

    logic [31:0] addr;
    logic [31:0] instr;

    instr_mem dut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        // Test 1: first instruction
        addr = 32'd0;
        #5;
        if (instr !== 32'h20080005)
            $display("ERROR: Expected 0x20080005, got %h", instr);
        else
            $display("PASS: addr 0 returns first instruction");

        // Test 2: second instruction
        addr = 32'd4;
        #5;
        if (instr !== 32'h2009000A)
            $display("ERROR: Expected 0x2009000A, got %h", instr);
        else
            $display("PASS: addr 4 returns second instruction");

        // Test 3: third instruction
        addr = 32'd8;
        #5;
        if (instr !== 32'h01095020)
            $display("ERROR: Expected 0x01095020, got %h", instr);
        else
            $display("PASS: addr 8 returns third instruction");

        // Test 4: fourth instruction
        addr = 32'd12;
        #5;
        if (instr !== 32'h01285822)
            $display("ERROR: Expected 0x01285822, got %h", instr);
        else
            $display("PASS: addr 12 returns fourth instruction");

        // Test 5: jump instruction
        addr = 32'd16;
        #5;
        if (instr !== 32'h08000004)
            $display("ERROR: Expected 0x08000004, got %h", instr);
        else
            $display("PASS: addr 16 returns jump instruction");

        // Test 6: empty/uninitialized programmed region
        addr = 32'd20;
        #5;
        if (instr !== 32'd0)
            $display("ERROR: Expected 0x00000000, got %h", instr);
        else
            $display("PASS: addr 20 returns 0");

        // Test 7: confirm word alignment behavior
        addr = 32'd1;
        #5;
        if (instr !== 32'h20080005)
            $display("ERROR: Expected addr 1 to map to first word, got %h", instr);
        else
            $display("PASS: addr 1 maps to first instruction");

        addr = 32'd6;
        #5;
        if (instr !== 32'h2009000A)
            $display("ERROR: Expected addr 6 to map to second word, got %h", instr);
        else
            $display("PASS: addr 6 maps to second instruction");

        $display("instr_mem testbench complete.");
        $stop;
    end

endmodule
