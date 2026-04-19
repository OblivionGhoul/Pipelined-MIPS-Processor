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
// description: Stores 32 bit registers, reads the values from rt and rs and 
// writes the value into an output register on the clk edge when register write is on

module reg_file(
    input logic clk,
    input logic rst, //reset
    input logic reg_write, // register write enable
    
    input  logic [4:0]  rs_reg, // read register 1 - 5 bits
    input  logic [4:0]  rt_reg, // read register 2 - 5 bits
    input  logic [4:0]  rd_reg, // write register 1 - 5bits     
    input  logic [31:0] write_data, // final 32 bit value address to write into register rd 

    output logic [31:0] rs_value, // 32 bit value stored into rs from rs_reg
    output logic [31:0] rt_value // 32 bit value stored into rt from rt_reg
    );
    
    logic [31:0] registers [0:31]; // 32 registers, 32 bit value
    
    always_ff @(posedge clk) begin // work on high of clk 
       if(rst == 1) begin // reset on
            for(integer i = 0; i<32; i++)
                registers[i] <= 32'd0; // if reset is on, all registers are reset to 0
       end
       
       else begin 
            if(reg_write == 1 && (rd_reg != 5'd0)) begin // if reg write enables and rd reg has data then
                registers[rd_reg] <= write_data; // update write data with rd reg value
            end
            registers[0] <= 32'd0;             // clear register 0, need to always have 0 on reg 0, does not store values
        end
     end
    
    
    always_comb begin // work regardless of clk status
        // clear rs register and rs stored data
        if(rs_reg == 5'd0) begin
            rs_value = 32'd0; 
        end
        else begin
            rs_value = registers[rs_reg]; // else update register rs data if there is data in rs_reg
        end
        
        // clear rt register and rt stored data
        if(rt_reg == 5'd0) begin
            rt_value = 32'd0; 
        end
        else begin
            rt_value = registers[rt_reg];// else update register rt data if there is data in rt_reg
        end
        
     end
    
endmodule
