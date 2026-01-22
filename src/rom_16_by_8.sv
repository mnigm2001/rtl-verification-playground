`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 03:45:18 PM
// Design Name: 
// Module Name: rom_16_by_8
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
Design a 16x8-bit ROM (16 words, 8 bits each). The ROM should be initialized with a predefined program 
    (e.g., a simple 8-bit counter pattern from 0x00 to 0x0F). The output should be synchronous to a clock input.
Inputs:
clk (1-bit)
addr (4-bit input)

Output:
data_out (8-bit)

Requirement:
Read is synchronous: data_out updates on the rising edge of clk.
*/

`define ROM_INIT_RANDOM_UNSEEDED
//`define ROM_INIT_MEM_FILE

module rom_16_by_8 (
    input logic clk,
    input logic [3:0] addr,
    output logic [7:0] data_o
);
    logic [7:0] ROM [0:15];
    
    // Initialize ROM
    `ifdef ROM_INIT_RANDOM_UNSEEDED
        initial foreach(ROM[i]) ROM[i] = $random;
     `elsif ROM_INIT_MEM_FILE
        initial  begin
            $readmemh("../../../srcs/sources_1/imports/new/rom_init.mem", ROM);
            #10;
            for (int i = 0; i < 16; i++)
                $display("ROM[%0d] = %h", i, ROM[i]);
        end 
     `else
        initial ROM = '{8'h4F, 8'h33, 8'h1A, 8'h03, 8'hDE, 8'hAD, 8'hBE, 8'hEF, 8'hFA, 8'hCE, 8'hAD, 8'hD1, 8'h36, 8'h99, 8'h5A, 8'h81};
     `endif
    
    always @(posedge clk) data_o <= ROM[addr];      

endmodule