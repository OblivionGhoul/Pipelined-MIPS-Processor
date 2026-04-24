`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2026 
// Design Name: 
// Module Name: alu
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
// description: This is the actual math and logic that happens, taking in values and executing the decoded instructions
// actual alu module to calculate the output

module alu(
    input logic [31:0] a,
    input logic [31:0] b, // two input variables that are 32 bit values
    input logic [2:0] alu_ctrl_signal, // 4 bit control signal actual math operation to do, add, sub, and, or
    
    output logic [31:0] op, // 32 bit output result
    output logic check // check to make sure result is zero, for beq
    
    );
    
    // tells alu what operation will be done
    logic [2:0] ctrl_AND = 3'b000;
    logic [2:0] ctrl_OR = 3'b001;
    logic [2:0] ctrl_SUB = 3'b011;
    logic [2:0] ctrl_ADD = 3'b100;
    logic [2:0] ctrl_NOP = 3'b101; // do nothing, usually used to allow time for other operations to finish before continuing
                                    // like when a register is being updated and then read next line. 
    
    always_comb begin // update when variables change 
        case (alu_ctrl_signal) 

            //inputs a and b AND operation
            ctrl_AND: op = a & b;

            // inputs a and b OR operation
            ctrl_OR: op = a | b;

            // Add inputs a and b
            ctrl_ADD: op = a + b;

            // Subtract b from a
            ctrl_SUB: op = a - b;

            // Output x if the ctrl signal does not match any operations for easy unknown identifier
            default: op = 32'hXXXX_XXXX; 
            
        endcase
    end
        assign check = (op == 32'd0); // check that when the output is 0, used for BEQ to make sure registers are equal, beq uses subtraction if 0 = branch
endmodule
