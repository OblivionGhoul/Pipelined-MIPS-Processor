`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 01:15:36 PM
// Design Name: 
// Module Name: imm_handle
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
// Matthew Bernardino
// description: Takes the immediate field 16 bit value and sign extends to 32 bits, 
// only ORI uses zero extension, rest use sign extension

module imm_handle(
    input logic [31:0] instruction32, // instruction address 32 bit
    output logic [31:0] imm_extend // extended value output
    );
    
    logic [5:0] opcode; // opcode of instruction that uses extension
    logic [15:0] address_16b; // 16 bit address to convert to 32 bit
    
    assign opcode = instruction32[31:26]; // takes the 6 bits that are relevant to opcode from the 32 bit address
    assign address_16b  = instruction32[15:0]; // takes the 16 bits relevant to sign extend immediate
    
    always_comb begin
        case(opcode)
            6'b001101: begin
                imm_extend = {16'd0, address_16b}; // extend the 16 bit zero address to 32 its, top 16 stay 0 and rest stay the same
            end
            default: begin
                imm_extend = {{16{address_16b[15]}}, address_16b}; // all other op: add, lw, sw, beq, addi
            end                                                    // takes into account negative value if [15]=1 and puts it to top 16 bits
        endcase         
    end
    
endmodule
