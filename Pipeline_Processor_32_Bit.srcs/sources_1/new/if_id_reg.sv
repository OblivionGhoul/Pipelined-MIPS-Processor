`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 08:14:06 PM
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] if_instr,
    input  logic [31:0] if_pc_plus4,
    output logic [31:0] id_instr,
    output logic [31:0] id_pc_plus4
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            id_instr    <= 32'd0;
            id_pc_plus4 <= 32'd0;
        end
        else begin
            id_instr    <= if_instr;
            id_pc_plus4 <= if_pc_plus4;
        end
    end

endmodule
