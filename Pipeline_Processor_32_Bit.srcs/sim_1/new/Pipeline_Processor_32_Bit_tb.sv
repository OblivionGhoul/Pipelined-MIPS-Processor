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

    // A block to decode the instruction currently in the Writeback stage
    // The WB stage is always 4 cycles behind the Fetch stage (PC - 16)
    always_comb begin
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
            32'd36: current_command = "beq  $t2, $t6, 2";
            32'd48: current_command = "j    14 (Branch Target)";
            32'd56: current_command = "j    14 (Infinite Loop)";
            default: current_command = "Pipeline Filling";
        endcase
    end

    initial begin
        // Monitor time, PC, command string, and 8 temp registers
        $monitor("Time=%0t | PC=%0d | %s | $t0=%0d $t1=%0d $t2=%0d $t3=%0d $t4=%0d $t5=%0d $t6=%0d $t7=%0d", 
                 $time, 
                 dut.pc_out,
                 current_command, 
                 dut.reg_inst.registers[8],  // $t(0)
                 dut.reg_inst.registers[9],  // $t(1)
                 dut.reg_inst.registers[10], // $t(2)
                 dut.reg_inst.registers[11], // $t(3)
                 dut.reg_inst.registers[12], // $t(4)
                 dut.reg_inst.registers[13], // $t(5)
                 dut.reg_inst.registers[14], // $t(6)
                 dut.reg_inst.registers[15]  // $t(7)
                 );

        // Initialize inputs and activate reset
        clk = 0;
        reset = 1;

        // Deactivate reset after 2 clock cycles
        #20;
        reset = 0;

        // Run for 20 clock cycles
        #200

        $finish;
    end

endmodule
