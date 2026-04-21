`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:08:49 PM
// Design Name: 
// Module Name: instr_mem
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


module instr_mem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] mem [0:255];

    initial begin
        // Initialize data
        mem[0]  = 32'h20080005; // addi $t0, $zero, 5 (Put 5 in $t0 - Reg 8)
        mem[1]  = 32'h34090003; // ori  $t1, $zero, 3 (Put 3 in $t1 - Reg 9)
        
        // Test math
        mem[2]  = 32'h01095020; // add  $t2, $t0, $t1 ($t2 (Reg 10) = 5 + 3 = 8)
        mem[3]  = 32'h01095822; // sub  $t3, $t0, $t1 ($t3 (Reg 11) = 5 - 3 = 2)
        mem[4]  = 32'h01096024; // and  $t4, $t0, $t1 ($t4 (Reg 12) = 5 AND 3 = 1)
        mem[5]  = 32'h01096825; // or   $t5, $t0, $t1 ($t5 (Reg 13) = 5 OR 3 = 7)
        
        // Test memory and stalling for forwarding
        mem[6]  = 32'hAC0A0000; // sw   $t2, 0($zero) (Store 8 into memory address 0)
        mem[7]  = 32'h8C0E0000; // lw   $t6, 0($zero) (Load from memory address 0 into $t6 - Reg 14 = 8)
        mem[8]  = 32'h01C97820; // add  $t7, $t6, $t1 ($t7 (Reg 15) = 8 + 3 = 11) - Testing hazard unit
        
        // Test branch and jump
        mem[9]  = 32'h114E0002; // beq  $t2, $t6, 2    (If $t2(8) == $t6(8), skip the next 2 instructions)
        mem[10] = 32'h20080063; // addi $t0, $zero, 99 (Should be skipped)
        mem[11] = 32'h20090063; // addi $t1, $zero, 99 (Should be skipped)
        
        // Jump the next instruction
        mem[12] = 32'h0800000E; // j    address 14     (Jump past the next instruction)
        mem[13] = 32'h200A0063; // addi $t2, $zero, 99 (Should be skipped)
        
        // End of test
        mem[14] = 32'h0800000E; // j    address 14     (Loop to stop the program)
        
        // Initialize a few extra remaining memory slots to 0
        for (integer i = 15; i < 32; i++) begin
            mem[i] = 32'd0;
        end
    end

    // Word-aligned addressing: addr[31:2]
    assign instr = mem[addr[31:2]];

endmodule
