`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:22:28 PM
// Design Name: 
// Module Name: if_stage_tb
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


module if_stage_tb;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] next_pc;
    logic [31:0] instr_fetched;

    logic [31:0] id_instr;
    logic [31:0] id_pc_plus4;

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

    instr_mem imem_dut (
        .addr(pc_out),
        .instr(instr_fetched)
    );

    if_id_reg ifid_dut (
        .clk(clk),
        .reset(reset),
        .if_instr(instr_fetched),
        .if_pc_plus4(next_pc),
        .id_instr(id_instr),
        .id_pc_plus4(id_pc_plus4)
    );

    // 10 ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;

        // Hold reset
        #12;
        reset = 0;

        // Right after reset release:
        // pc_out should be 0, instr_fetched should be mem[0]
        #1;
        if (pc_out !== 32'd0)
            $display("ERROR: Expected pc_out = 0 after reset, got %0d", pc_out);
        else
            $display("PASS: PC starts at 0");

        if (instr_fetched !== 32'h20080005)
            $display("ERROR: Expected first fetched instruction = 0x20080005, got %h", instr_fetched);
        else
            $display("PASS: First instruction fetched correctly");

        if (next_pc !== 32'd4)
            $display("ERROR: Expected next_pc = 4, got %0d", next_pc);
        else
            $display("PASS: next_pc = pc + 4 works");

        // After first active clock edge:
        // IF/ID should latch first instruction and PC+4
        #9;
        if (id_instr !== 32'h20080005 || id_pc_plus4 !== 32'd4)
            $display("ERROR: Cycle 1 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Cycle 1 latched first instruction");

        // After second clock:
        // pc_out should be 4, fetched instr should be second instruction,
        // IF/ID should latch second instruction
        #10;
        if (pc_out !== 32'd4)
            $display("ERROR: Expected pc_out = 4, got %0d", pc_out);
        else
            $display("PASS: PC moved to 4");

        if (id_instr !== 32'h2009000A || id_pc_plus4 !== 32'd8)
            $display("ERROR: Cycle 2 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Cycle 2 latched second instruction");

        // After third clock
        #10;
        if (pc_out !== 32'd8)
            $display("ERROR: Expected pc_out = 8, got %0d", pc_out);
        else
            $display("PASS: PC moved to 8");

        if (id_instr !== 32'h01095020 || id_pc_plus4 !== 32'd12)
            $display("ERROR: Cycle 3 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Cycle 3 latched third instruction");

        // After fourth clock
        #10;
        if (pc_out !== 32'd12)
            $display("ERROR: Expected pc_out = 12, got %0d", pc_out);
        else
            $display("PASS: PC moved to 12");

        if (id_instr !== 32'h01285822 || id_pc_plus4 !== 32'd16)
            $display("ERROR: Cycle 4 failed. id_instr = %h, id_pc_plus4 = %0d", id_instr, id_pc_plus4);
        else
            $display("PASS: Cycle 4 latched fourth instruction");

        // Reset again during operation
        reset = 1;
        #10;
        if (pc_out !== 32'd0 || id_instr !== 32'd0 || id_pc_plus4 !== 32'd0)
            $display("ERROR: Reset during operation failed. pc_out = %0d, id_instr = %h, id_pc_plus4 = %0d",
                     pc_out, id_instr, id_pc_plus4);
        else
            $display("PASS: Reset clears IF stage correctly");

        $display("IF stage integration testbench complete.");
        $stop;
    end

endmodule
