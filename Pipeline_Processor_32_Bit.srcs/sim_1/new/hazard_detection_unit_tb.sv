`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:10:25 PM
// Design Name: 
// Module Name: hazard_detection_unit_tb
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


module hazard_detection_unit_tb;
    // Register for inputs
    reg [4:0] if_id_rs;
    reg [4:0] if_id_rt;
    reg [4:0] id_ex_rt;
    reg id_ex_memread;
    
    // Wire for outputs
    wire pc_write;
    wire if_id_write;
    wire control_mux;

    // Connect testbench to the design
    hazard_detection_unit dut (.if_id_rs(if_id_rs), .if_id_rt(if_id_rt), .id_ex_rt(id_ex_rt), .id_ex_memread(id_ex_memread), .pc_write(pc_write), .if_id_write(if_id_write), .control_mux(control_mux));

    initial begin
        // Log changes
        $monitor("Time=%0t | memread=%b id_ex_rt=%d if_id_rs=%d if_id_rt=%d | stall signals(PC,IF/ID,Mux)=%b%b%b", $time, id_ex_memread, id_ex_rt, if_id_rs, if_id_rt, pc_write, if_id_write, control_mux);

        // Test 1: Normal operation (No load in EX stage, no stall)
        id_ex_memread = 0; id_ex_rt = 5'd5; if_id_rs = 5'd5; if_id_rt = 5'd6; 
        #10;
        
        // Test 2: Load instruction, but no matching registers (No stall)
        id_ex_memread = 1; id_ex_rt = 5'd10; if_id_rs = 5'd5; if_id_rt = 5'd6; 
        #10;
        
        // Test 3: Hazard on rs (Stall expected: 000)
        id_ex_memread = 1; id_ex_rt = 5'd5; if_id_rs = 5'd5; if_id_rt = 5'd6; 
        #10;
        
        // Test 4: Hazard on rt (Stall expected: 000)
        id_ex_memread = 1; id_ex_rt = 5'd6; if_id_rs = 5'd5; if_id_rt = 5'd6; 
        #10;

        $finish;
    end
endmodule
