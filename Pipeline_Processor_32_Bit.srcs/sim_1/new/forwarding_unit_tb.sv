`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:11:06 PM
// Design Name: 
// Module Name: forwarding_unit_tb
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


module forwarding_unit_tb;
    // Register for inputs
    reg [4:0] id_ex_rs, id_ex_rt;
    reg [4:0] ex_mem_rd, mem_wb_rd;
    reg ex_mem_regwrite, mem_wb_regwrite;
    
    // Wire for output
    wire [1:0] forward_a, forward_b;
    
    // Connect testbench to the design
    forwarding_unit dut (.id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt), .ex_mem_rd(ex_mem_rd), .ex_mem_regwrite(ex_mem_regwrite), .mem_wb_rd(mem_wb_rd), .mem_wb_regwrite(mem_wb_regwrite), .forward_a(forward_a), .forward_b(forward_b));

    initial begin
        // Log changes
        $monitor("Time=%0t | rs=%d rt=%d | EXrd=%d EXwr=%b | MEMrd=%d MEMwr=%b | FwdA=%b FwdB=%b", $time, id_ex_rs, id_ex_rt, ex_mem_rd, ex_mem_regwrite, mem_wb_rd, mem_wb_regwrite, forward_a, forward_b);

        // Test 1: No forwarding
        id_ex_rs = 5'd2; id_ex_rt = 5'd3; 
        ex_mem_rd = 5'd4; ex_mem_regwrite = 0; 
        mem_wb_rd = 5'd5; mem_wb_regwrite = 0; 
        #10;

        // Test 2: EX Hazard on ALU input rs (Expected output: FwdA = 10)
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1; 
        #10;
        
        // Test 3: MEM Hazard on ALU input rt (Expected output: FwdA = 10, FwdB = 01)
        mem_wb_rd = 5'd3; mem_wb_regwrite = 1; 
        #10;
        
        // Test 4: Both hazards on ALU input rs, EX should take priority over MEM (Expected output: FwdA = 10)
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1;
        mem_wb_rd = 5'd2; mem_wb_regwrite = 1;
        #10;

        $finish;
    end
endmodule
