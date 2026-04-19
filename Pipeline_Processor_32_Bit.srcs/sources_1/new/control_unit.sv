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
// description: the control unit decodes the opcode and directs it to what needs to be used
// to turn on and off components with the control signals to make the path for the instruction to be executed.

module control_unit(
    // create variables ip and op
    input logic [5:0] opcode,
    output logic reg_dst,   // destination write back rd or rt
    output logic alu_src,   // second input rt or immediate value
    output logic mem_to_reg,// write memory back to reg
    output logic reg_write, // register file write enable
    output logic mem_read,  // read enable
    output logic mem_write, // write enable
    output logic branch,
    output logic jump,
    output logic [2:0] alu_op //alu control operation to be done
    
    );
    
    logic [2:0] OPcode_ADD = 3'b000; // addi, lw, sw
    logic [2:0] OPcode_SUB = 3'b001; // beq
    logic [2:0] OPcode_Rtype = 3'b010; // function type for specifics of r-type instruction functions
    logic [2:0] OPcode_ORI = 3'b011;    // ori
    
    
    always_comb begin 
    
    // set all variables to 0 to begin
        reg_dst    = 1'b0;
        alu_src    = 1'b0;
        mem_to_reg = 1'b0;
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_op     = OPcode_ADD; 
        
        case(opcode)
            6'b000000: begin  // rtype: add, sub, and, or opcode
                reg_dst   = 1'b1; // result written into rd 
                alu_src   = 1'b0; // not immediate value, comes from rt value
                reg_write = 1'b1; //  enable write to register file
                alu_op    = OPcode_Rtype; 
            end
            
            6'b001000: begin  // addi opcode
                reg_dst   = 1'b0; // result written into rt
                alu_src   = 1'b1; // second input comes from immediate value
                reg_write = 1'b1; // enable write to register file
                alu_op    = OPcode_ADD;
            end
            
            6'b001101: begin  // ORI opcode
                reg_dst   = 1'b0; // result written into rt
                alu_src   = 1'b1; // second input comes from immediate value
                reg_write = 1'b1; // enable write to register file
                alu_op    = OPcode_ORI;
            end
            
            6'b100011: begin  // LW opcode
                reg_dst   = 1'b0; // result written into rt
                alu_src   = 1'b1; // second input comes from immediate value
                reg_write = 1'b1; // enable write to register file
                mem_to_reg = 1'b1; // write data from memory to the register
                mem_read = 1'b1;    // read the data from the memory
                alu_op    = OPcode_ADD;
            end
            
            6'b101011: begin  // SW opcode
                alu_src   = 1'b1; // second input comes from immediate value
                mem_write = 1'b1; // write data from memory to the register
                alu_op    = OPcode_ADD;
            end
            
            6'b000100: begin  // BEQ opcode
                branch   = 1'b1; // might branch so do a check
                alu_op    = OPcode_SUB; // subtract rs and rd values, if the values are 0 then branch condition is done, if not continue to next line
            end
            
            6'b000010: begin  // J opcode
                jump   = 1'b1; // jump does not use other components
            end
            
            default: begin
                // if error opcode want all set to x to show unknowna nd easy error identification
                reg_dst    = 1'bx;
                alu_src    = 1'bx;
                mem_to_reg = 1'bx;
                reg_write  = 1'bx;
                mem_read   = 1'bx;
                mem_write  = 1'bx;
                branch     = 1'bx;
                jump       = 1'bx;
                alu_op     = 3'bxxx;
            end
        endcase
    end
        
endmodule
