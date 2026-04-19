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
        // Example program
        mem[0] = 32'h20080005; // addi $t0, $zero, 5
        mem[1] = 32'h2009000A; // addi $t1, $zero, 10
        mem[2] = 32'h01095020; // add  $t2, $t0, $t1
        mem[3] = 32'h01285822; // sub  $t3, $t1, $t0
        mem[4] = 32'h08000004; // j    address 4

        // Initialize remaining memory to 0
        mem[5]   = 32'd0;
        mem[6]   = 32'd0;
        mem[7]   = 32'd0;
        mem[8]   = 32'd0;
        mem[9]   = 32'd0;
        mem[10]  = 32'd0;
        mem[11]  = 32'd0;
        mem[12]  = 32'd0;
        mem[13]  = 32'd0;
        mem[14]  = 32'd0;
        mem[15]  = 32'd0;
        mem[16]  = 32'd0;
        mem[17]  = 32'd0;
        mem[18]  = 32'd0;
        mem[19]  = 32'd0;
        mem[20]  = 32'd0;
        mem[21]  = 32'd0;
        mem[22]  = 32'd0;
        mem[23]  = 32'd0;
        mem[24]  = 32'd0;
        mem[25]  = 32'd0;
        mem[26]  = 32'd0;
        mem[27]  = 32'd0;
        mem[28]  = 32'd0;
        mem[29]  = 32'd0;
        mem[30]  = 32'd0;
        mem[31]  = 32'd0;
        // Remaining locations default fine for most simulators,
        // but you can expand this if your class expects every entry initialized.
    end

    // Word-aligned addressing: addr[31:2]
    assign instr = mem[addr[31:2]];

endmodule