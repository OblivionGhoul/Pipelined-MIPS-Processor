`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 01:29:50 PM
// Design Name: 
// Module Name: Pipeline_Processor_32_Bit_tb
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


module Pipeline_Processor_32_Bit_tb;
    // Inputs
    logic clk;
    logic reset;

    // Connect the testbench to the design
    Pipeline_Processor_32_Bit dut (.clk(clk), .reset(reset));

    // Create a clock and toggle every 5 ns (10 ns cycle)
    always #5 clk = ~clk;

    // Create a string variable to hold the command name
    string current_command;

    // Decode the instruction currently in the WB stage
    always_comb begin
        // Override after branch and jump instruction
        if (dut.mem_wb_regwrite && dut.mem_wb_write_reg == 5'd24) begin
            current_command = "add  $t8, $t0, $t1";
        end 
        else if (dut.mem_wb_regwrite && dut.mem_wb_write_reg == 5'd25) begin
            current_command = "sub  $t9, $t8, $t0";
        end
        // If $t9 equals 3, the forwarding test is done
        else if (dut.reg_inst.registers[25] == 32'd3) begin
            // Print infinite loop
            current_command = "j    17 (Infinite Loop)";
        end 
        // WB 4 stages behind fetch (PC - 16)
        else begin
            case(dut.pc_out - 32'd16)
                32'd0:  current_command = "addi $t0, $zero, 5";
                32'd4:  current_command = "ori  $t1, $zero, 3";
                32'd8:  current_command = "add  $t2, $t0, $t1";
                32'd12: current_command = "sub  $t3, $t0, $t1";
                32'd16: current_command = "and  $t4, $t0, $t1";
                32'd20: current_command = "or   $t5, $t0, $t1";
                32'd24: current_command = "sw   $t2, 0($zero)";
                32'd28: current_command = "lw   $t6, 0($zero)";
                32'd32: current_command = "add  $t7, $t6, $t1";
                32'd36: current_command = "addi $t3, $zero, -5";
                32'd40: current_command = "beq  $t2, $t6, 2";
                32'd44: current_command = "addi $t0, $zero, 99 (Skipped)";
                32'd48: current_command = "addi $t1, $zero, 99 (Skipped)";
                32'd52: current_command = "j    15 (Jump to PC 60)";
                32'd56: current_command = "addi $t2, $zero, 99 (Skipped)";
                default: current_command = "Pipeline Filling / NOP";
            endcase
        end
    end

    initial begin
        // Monitor time, PC, command string, and 10 temp registers
        $monitor("Time=%-6t | PC=%-2d | %-31s | $t0=%-2d $t1=%-2d $t2=%-2d $t3=%-2d $t4=%-2d $t5=%-2d $t6=%-2d $t7=%-2d $t8=%-2d $t9=%-2d", 
            $time,
            dut.pc_out,
            current_command,
            $signed(dut.reg_inst.registers[8]),  // $t(0)
            $signed(dut.reg_inst.registers[9]),  // $t(1)
            $signed(dut.reg_inst.registers[10]), // $t(2)
            $signed(dut.reg_inst.registers[11]), // $t(3)
            $signed(dut.reg_inst.registers[12]), // $t(4)
            $signed(dut.reg_inst.registers[13]), // $t(5)
            $signed(dut.reg_inst.registers[14]), // $t(6)
            $signed(dut.reg_inst.registers[15]), // $t(7)
            $signed(dut.reg_inst.registers[24]), // $t(8)
            $signed(dut.reg_inst.registers[25])  // $t(9)
        );

        // Initialize inputs and activate reset
        clk = 0;
        reset = 1;

        // Deactivate reset after 2 clock cycles
        #20;
        reset = 0;

        // Run for 24 clock cycles
        #240

        $finish;
    end

endmodule
