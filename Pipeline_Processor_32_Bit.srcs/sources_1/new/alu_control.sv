`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2026 08:30:47 AM
// Design Name: 
// Module Name: alu_control
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
// description: This module uses the opcode from the previous modules to determine the r-type instruction operation function to be done.
// determines lw, sw, addi, add, sub, or, and based on 6 bit funct field in r type instruction 32 bit address


module alu_control(
    input logic [2:0] alu_op, // 3 bit operation code of type of instruction like and, add, sub 
    input logic [5:0] funct_op, // 6 bit identifier for what operation is apart of the 32 bit instruction
    output logic [3:0] alu_ctrl_signal // 4 bit setup for control signal that goes into alu, exact command into ALU for operation to execute
    );
    
    // tells alu what operation will be done
    logic [3:0] ctrl_AND = 4'b0000;
    logic [3:0] ctrl_OR = 4'b0001;
    logic [3:0] ctrl_SUB = 4'b0110;
    logic [3:0] ctrl_ADD = 4'b0010;
    logic [3:0] ctrl_NOP = 4'b1111; // do nothing, usually used to allow time for other operations to finish before continuing
                                    // like when a register is being updated and then read next line.
    
    // the instruction type filter depending on the type of function
    logic [2:0] OPcode_ADD = 3'b000; // addi, lw, sw
    logic [2:0] OPcode_SUB = 3'b001; // beq
    logic [2:0] OPcode_Rtype = 3'b010; // function type for specifics of r-type instruction functions
    logic [2:0] OPcode_ORI = 3'b011;    // ori
    
    always_comb begin
        case(alu_op)
          
          OPcode_ADD: alu_ctrl_signal = ctrl_ADD; // lw, sw, addi, addition is done
          
          OPcode_SUB: alu_ctrl_signal = ctrl_SUB; // subtract two registers
          
          OPcode_ORI: alu_ctrl_signal = ctrl_OR; // ori uses bitwise or 
          
          OPcode_Rtype: begin // rtype instruction has a lot of options so we specify
                case(funct_op)     
                   // funct_op for ADD
                   6'b100000: alu_ctrl_signal = ctrl_ADD;
        
                   // funct_op for SUB
                   6'b100010: alu_ctrl_signal = ctrl_SUB;
        
                   // funct_op for AND
                   6'b100100: alu_ctrl_signal = ctrl_AND;
        
                   // funct_op for OR
                   6'b100101: alu_ctrl_signal = ctrl_OR; 
                   
                   default:   alu_ctrl_signal = ctrl_NOP; // output nop if no operation is available
                   
                endcase
                
          end
            
          default:   alu_ctrl_signal = ctrl_NOP; // output nop if no operation is available
            
        endcase
           
    end
    
endmodule
