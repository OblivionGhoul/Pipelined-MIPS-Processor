`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:15:01 PM
// Design Name: 
// Module Name: if_id_reg_tb
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


module if_id_reg_tb;

    logic        clk;
    logic        reset;
    logic [31:0] if_instr;
    logic [31:0] if_pc_plus4;
    logic [31:0] id_instr;
    logic [31:0] id_pc_plus4;

    if_id_reg dut (
        .clk(clk),
        .reset(reset),
        .if_instr(if_instr),
        .if_pc_plus4(if_pc_plus4),
        .id_instr(id_instr),
        .id_pc_plus4(id_pc_plus4)
    );

    // 10 ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initial values
        reset       = 1;
        if_instr    = 32'd0;
        if_pc_plus4 = 32'd0;

        // Hold reset
        #12;
        reset = 0;

        // Test 1: first instruction passes through
        if_instr    = 32'h20080005;
        if_pc_plus4 = 32'd4;
        #10;
        if (id_instr !== 32'h20080005 || id_pc_plus4 !== 32'd4)
            $display("ERROR: Test 1 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Test 1");

        // Test 2: second instruction passes through
        if_instr    = 32'h2009000A;
        if_pc_plus4 = 32'd8;
        #10;
        if (id_instr !== 32'h2009000A || id_pc_plus4 !== 32'd8)
            $display("ERROR: Test 2 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Test 2");

        // Test 3: third instruction passes through
        if_instr    = 32'h01095020;
        if_pc_plus4 = 32'd12;
        #10;
        if (id_instr !== 32'h01095020 || id_pc_plus4 !== 32'd12)
            $display("ERROR: Test 3 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Test 3");

        // Test 4: outputs should hold between clock edges
        if_instr    = 32'h01285822;
        if_pc_plus4 = 32'd16;
        #3;
        if (id_instr !== 32'h01095020 || id_pc_plus4 !== 32'd12)
            $display("ERROR: Test 4 failed. Outputs changed before clock edge.");
        else
            $display("PASS: Test 4");

        #7;
        if (id_instr !== 32'h01285822 || id_pc_plus4 !== 32'd16)
            $display("ERROR: Test 4 failed after clock. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Test 4 after clock edge");

        // Test 5: reset clears outputs during operation
        reset = 1;
        #10;
        if (id_instr !== 32'd0 || id_pc_plus4 !== 32'd0)
            $display("ERROR: Test 5 failed. Reset did not clear outputs.");
        else
            $display("PASS: Test 5");

        reset = 0;

        // Test 6: pipeline register works again after reset
        if_instr    = 32'h08000004;
        if_pc_plus4 = 32'd20;
        #10;
        if (id_instr !== 32'h08000004 || id_pc_plus4 !== 32'd20)
            $display("ERROR: Test 6 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Test 6");

        $display("if_id_reg testbench complete.");
        $stop;
    end

endmodule
