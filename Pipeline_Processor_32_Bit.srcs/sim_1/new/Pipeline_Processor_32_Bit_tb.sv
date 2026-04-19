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

    initial begin
        // Monitor the PC and the 4 registers we care about ($t0, $t1, $t2, $t3)
        // Note: $t0 is register 8, $t1 is 9, $t2 is 10, $t3 is 11.
        $monitor("Time=%0t | PC=%0d | $t0(8)=%0d | $t1(9)=%0d | $t2(10)=%0d | $t3(11)=%0d", 
                 $time, dut.pc_out,
                 dut.reg_inst.registers[8], 
                 dut.reg_inst.registers[9], 
                 dut.reg_inst.registers[10], 
                 dut.reg_inst.registers[11]);

        // Initialize inputs and activate reset
        clk = 0;
        reset = 1;

        // Deactivate reset after 2 clock cycles to flush the pipeline
        #20;
        reset = 0;

        // Allow the processor to run for 15 clock cycles.
        // Because of the pipeline, it takes 5 cycles for the FIRST instruction
        // to finish, then 1 instruction finishes every cycle after that.
        #150;

        $finish;
    end

endmodule
