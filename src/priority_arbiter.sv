`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 03:59:04 PM
// Design Name: 
// Module Name: priority_arbiter
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


/*

Problem Statement:

Build a priority arbiter module.
It takes N request signals (req[N-1:0]) as inputs.
It outputs a grant signal (grant[N-1:0]) where exactly one grant is HIGH, corresponding to the highest-priority request (priority = lowest index).
If multiple requests are HIGH, grant the lowest index one.
If no request is active, no grant should be asserted (all zeros).

Requirements:
N should be parameterized (not hardcoded).
Synchronous: grant decision updated on the positive edge of clk.
Reset (reset_n, active low) should clear all grants.

Example Behavior (N = 4)
req	      grant
4'b0000	4'b0000
4'b0001	4'b0001
4'b1010	4'b0010
4'b1100	4'b0100
(req[1] gets priority over req[2], etc.)

*/

module priority_arbiter #(
    parameter int N = 4
) (
    input logic clk,
    input logic reset_n,
    input logic [N-1:0] req,
    output logic [N-1:0] grant   
);
    
    logic [$clog2(N)-1:0] count;
    always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        grant <= '0;
        count <= 0;
    end else begin
        count <= 0;
        for (int i = 0; i < N; i++) begin
            if (req[i]) begin
                count <= i;
                break;
            end
        end

        grant <= '0;
        if (req != 0) begin
            grant[count] <= 1;
        end
    end
end
    
endmodule 
