`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Matthew Bernardino
// Professor Anshul
// ECPE 192
// Description: test bench for top_level module to verify decode and execute path
//////////////////////////////////////////////////////////////////////////////////


// testbench to test decode and execute modules
module decode_ex_tb();

    // input variables
    reg clk;
    reg rst;
    reg stall;
    reg clear;

    reg [31:0] instruction_in;
    reg [31:0] pc_plus4_in;

    reg wb_reg_write;
    reg [4:0]  wb_write_reg;
    reg [31:0] wb_write_value;

    // output variables
    wire mem_to_reg_out;
    wire reg_write_out;
    wire mem_read_out;
    wire mem_write_out;
    wire branch_out;
    wire jump_out;

    wire [31:0] pc_plus4_out;
    wire [31:0] alu_result_out;
    wire [31:0] rt_value_out;
    wire [31:0] imm_extend_out;
    wire [4:0]  write_reg_out;
    wire check_out;

    // instantiate DUT
    top_level top_inst(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .clear(clear),
        .instruction_in(instruction_in),
        .pc_plus4_in(pc_plus4_in),
        .wb_reg_write(wb_reg_write),
        .wb_write_reg(wb_write_reg),
        .wb_write_value(wb_write_value),
        .mem_to_reg_out(mem_to_reg_out),
        .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .branch_out(branch_out),
        .jump_out(jump_out),
        .pc_plus4_out(pc_plus4_out),
        .alu_result_out(alu_result_out),
        .rt_value_out(rt_value_out),
        .imm_extend_out(imm_extend_out),
        .write_reg_out(write_reg_out),
        .check_out(check_out)
    );

    // clock setup
    always #20 clk = ~clk; // 40 ns total, 20 ns high and 20ns low

    initial begin
        
        // set all variables to 0
        clk = 0;
        rst = 0;
        stall = 0;
        clear = 0;
        instruction_in = 32'd0;
        pc_plus4_in = 32'd0;
        wb_reg_write = 0;
        wb_write_reg = 5'd0;
        wb_write_value = 32'd0;
        #40;

        // reset register file and pipeline values
        rst = 1;
        #40;
        rst = 0;
        #40;

        // preload register 1 with decimal 10
        wb_reg_write = 1;
        wb_write_reg = 5'd1;
        wb_write_value = 32'd10;
        #40;
        wb_reg_write = 0;
        #40;

        // preload register 2 with decimal 3
        wb_reg_write = 1;
        wb_write_reg = 5'd2;
        wb_write_value = 32'd3;
        #40;
        wb_reg_write = 0;
        #40;

        // preload register 4 with decimal 15
        wb_reg_write = 1;
        wb_write_reg = 5'd4;
        wb_write_value = 32'd15;
        #40;
        wb_reg_write = 0;
        #40;

        // preload register 5 with decimal 15
        wb_reg_write = 1;
        wb_write_reg = 5'd5;
        wb_write_value = 32'd15;
        #40;
        wb_reg_write = 0;
        #40;

        // preload register 6 with hex F0F0
        wb_reg_write = 1;
        wb_write_reg = 5'd6;
        wb_write_value = 32'h0000_F0F0;
        #40;
        wb_reg_write = 0;
        #40;

        // TEST 1: ADD  r3 = r1 + r2 = 13
        instruction_in = {6'b000000, 5'd1, 5'd2, 5'd3, 5'd0, 6'b100000};
        pc_plus4_in = 32'h0000_0004;
        #40;

        // TEST 2: SUB  r7 = r1 - r2 = 7
        instruction_in = {6'b000000, 5'd1, 5'd2, 5'd7, 5'd0, 6'b100010};
        pc_plus4_in = 32'h0000_0008;
        #40;

        // TEST 3: AND  r8 = r1 & r2 = 2
        instruction_in = {6'b000000, 5'd1, 5'd2, 5'd8, 5'd0, 6'b100100};
        pc_plus4_in = 32'h0000_000C;
        #40;

        // TEST 4: OR  r9 = r1 | r2 = 11
        instruction_in = {6'b000000, 5'd1, 5'd2, 5'd9, 5'd0, 6'b100101};
        pc_plus4_in = 32'h0000_0010;
        #40;

        // TEST 5: ADDI  r10 = r1 + 5 = 15
        instruction_in = {6'b001000, 5'd1, 5'd10, 16'd5};
        pc_plus4_in = 32'h0000_0014;
        #40;

        // TEST 6: ORI  r11 = r6 | 00FF
        instruction_in = {6'b001101, 5'd6, 5'd11, 16'h00FF};
        pc_plus4_in = 32'h0000_0018;
        #40;

        // TEST 7: LW address calculation  r12, 8(r1)
        instruction_in = {6'b100011, 5'd1, 5'd12, 16'd8};
        pc_plus4_in = 32'h0000_001C;
        #40;

        // TEST 8: SW address calculation  r2, 12(r1)
        instruction_in = {6'b101011, 5'd1, 5'd2, 16'd12};
        pc_plus4_in = 32'h0000_0020;
        #40;

        // TEST 9: BEQ equal check  r4 == r5
        instruction_in = {6'b000100, 5'd4, 5'd5, 16'd4};
        pc_plus4_in = 32'h0000_0024;
        #40;

        // TEST 10: J instruction
        instruction_in = {6'b000010, 26'd16};
        pc_plus4_in = 32'h0000_0028;
        #40;

        // TEST 11: stall hold
        stall = 1;
        instruction_in = {6'b001000, 5'd1, 5'd13, 16'd20};
        pc_plus4_in = 32'h0000_002C;
        #40;
        stall = 0;
        #40;

        // TEST 12: clear pipeline register
        clear = 1;
        #40;
        clear = 0;
        #40;

        #40 $finish;
    end

    // monitor output
    always @(clk, rst, stall, clear, instruction_in, pc_plus4_in, wb_reg_write, wb_write_reg, wb_write_value,
             mem_to_reg_out, reg_write_out, mem_read_out, mem_write_out, branch_out, jump_out,
             pc_plus4_out, alu_result_out, rt_value_out, imm_extend_out, write_reg_out, check_out)
             
        $monitor("Time=%0t clk=%0b rst=%0b stall=%0b clear=%0b instr=%h pc+4=%h wb_we=%0b wb_reg=%0d wb_val=%0d | alu_out=%0d write_reg=%0d rt_val=%0d imm_ext=%h branch=%0b jump=%0b mem_rd=%0b mem_wr=%0b reg_wr=%0b zero=%0b",
                 $time, clk, rst, stall, clear, instruction_in, pc_plus4_in, wb_reg_write, wb_write_reg, wb_write_value,
                 alu_result_out, write_reg_out, rt_value_out, imm_extend_out, branch_out, jump_out,
                 mem_read_out, mem_write_out, reg_write_out, check_out);
    

endmodule