`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:09:40 PM
// Design Name: 
// Module Name: pulse_stretcher_tb
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



module pulse_stretcher_tb();

    parameter int N=3;
    
    logic clk=0, reset_n=1;
    logic in_pulse=0, out_pulse;    
    
    pulse_stretcher #(
        .N(N)
    ) DUT (
        .clk(clk),
        .reset_n(reset_n),
        .in_pulse(in_pulse),
        .out_pulse(out_pulse)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        reset_n = 1;
        @(posedge clk);
        reset_n = 0;
        @(posedge clk);
        reset_n = 1;
        
        @(posedge clk);
        in_pulse = 1;
        @(posedge clk);
        in_pulse = 0;
        
        for (int i=0; i<5; i++)
            @(posedge clk);
        
        in_pulse = 1;
        @(posedge clk);
        in_pulse = 0;
        
        for (int i=0; i<5; i++)
            @(posedge clk);
        $finish();
    end
endmodule
