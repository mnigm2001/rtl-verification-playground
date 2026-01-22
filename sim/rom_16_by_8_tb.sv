`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:04:49 PM
// Design Name: 
// Module Name: rom_16_by_8_tb
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



module rom_16_by_8_tb ();
    
    localparam int WIDTH = 8;
    localparam int DEPTH = 16;

    logic clk=0;
    logic [$clog2(DEPTH)-1:0] addr = 0;
    logic [WIDTH-1:0] data_o;
    
    rom_16_by_8 DUT (
        .clk(clk),
        .addr(addr),
        .data_o(data_o)
    );
    
    logic [WIDTH-1:0] rom_copy [0:DEPTH-1]; // Shadow copy captured in first pass
    logic trigger_check;
    
    ROM_immutability_checker #(
        .WIDTH(8), 
        .DEPTH(16)
    ) rom_checker (
        .clk(clk),
        .observed_rom(rom_copy),
        .trigger_check(trigger_check)
    );
    
    
    always #5 clk = ~clk;
    
    initial begin
        
        @(posedge clk);
        trigger_check = 0;
    
        #100;
        for (int i=0; i<DEPTH; i++) begin
            addr = i;
            @(posedge clk);
            $display("%0t | data_o[%0d] = 0x%0h", $time, i, data_o);
            
            // Populate ROM copy for checker
            rom_copy[i] = data_o;
        end
        
        @(posedge clk);
        trigger_check = 1;
        
        #100;
        $finish;
    end
endmodule



module ROM_immutability_checker #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
) (
    input logic clk,
    input logic [WIDTH-1:0] observed_rom [0:DEPTH-1],
    input logic trigger_check
);
    logic [WIDTH-1:0] baseline_rom [0:DEPTH-1];
    bit initialized = 0;
    
    always @(posedge clk) begin
        if(!initialized) begin
            for (int i=0; i<DEPTH; i++)
                baseline_rom[i] <= observed_rom[i];
            initialized <= 1;
        end else if (trigger_check) begin
            for (int i=0; i<DEPTH; i++) begin
                assert (baseline_rom[i] == observed_rom[i])
                    else $fatal("%0t | ROM immutability violated at index %0d: expected %h, got %h", $time, i, baseline_rom[i], observed_rom[i]);
            end
        end
            
    
    end
    
endmodule 