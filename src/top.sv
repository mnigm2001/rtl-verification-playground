`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 07:07:00 PM
// Design Name: 
// Module Name: top
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


//module top();
//    logic clk;
//    logic [3:0] addr;
//    logic [7:0] data_o;
    
////    ROM_16_by_8 ROM(
////        .clk(clk),
////        .addr(addr),
////        .data_o(data_o)
////    );


//endmodule

//`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

// Simple UVM test that prints a message in run_phase
class hello_test extends uvm_test;
  `uvm_component_utils(hello_test)

  function new(string name = "hello_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Correct signature: a task, not a function
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);              // call base-class task
    `uvm_info("HELLO_TEST", "UVM is working in Vivado Simulator!", UVM_LOW)
  endtask
endclass

module top;
  initial begin
    run_test("hello_test");
  end
endmodule



/*
✅ Question 2: Configurable Rotating Priority Arbiter
🔧 Design Task:
Implement rotating_arbiter:
Behavior:
Grant only 1-hot
When grant_ack is received, rotate priority:
The next grant begins searching from (current_grant + 1) % N.


🧪 Verification Goals:
Randomly generate req patterns with and without grant_ack.

Write assertions that check:
Grant is always one-hot
Grant matches the rotated priority
On grant_ack, a new requester is chosen with correct rotation
If req is 0, grant must be 0

✅ This tests:
Priority rotation logic
Combinational grant generation with retained internal state
Handling of acknowledge handshake

✅ Question 3: Parameterized Up/Down Counter with Saturation
🔧 Design Task:
Build a module updown_counter that:

Inputs: clk, reset_n, up, down

Parameter: WIDTH, default = 4

Output: logic [WIDTH-1:0] count

Behavior:

If up & ~down: increment unless at max value (2ⁿ-1)

If down & ~up: decrement unless at 0

If both high or both low: hold value

Ports:

verilog
Copy
Edit
module updown_counter #(
    parameter int WIDTH = 4
)(
    input logic clk,
    input logic reset_n,
    input logic up,
    input logic down,
    output logic [WIDTH-1:0] count
);
🧪 Verification Goals:
Randomize up/down inputs

Check with assertions:

Count never exceeds saturation bounds

Count only changes on valid input combinations

Reset initializes correctly

✅ This question tests:

FSM and boundary behavior

Bit-width awareness

TB edge generation and corner case handling

Assertions that guard saturation and stability



*/

/*

logic [$clog2(N)-1:0] prev_grant_idx;
    logic grant_sent;
//    logic [N-1:0] prev_req;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            grant <= '0;
            prev_grant_idx <= '0;
            grant_sent <= 1'b0;
//            prev_req <= '0;
        end else begin
            // State
            // If a req is granted and grant_ack -> set compute_grant
            if ((grant_sent == 1'b1) && (grant_ack == 1'b1))  begin
                grant_sent <= 1'b0;
            end
            
            // N=4 prev=2  req=4'b0101 -- ACK=1 prev
            if ((grant_sent == 1'b0)) begin
                grant <= '0;
                if(|req) begin
                    for (int i=prev_grant_idx; i<N; i++) begin
                        if (req[i] == 1) begin
                            grant[i] <= 1;
                            prev_grant_idx <= i;
                            break;
                        end
                    end
                    grant_sent <= 1'b1;
                end
             end
        end
    end

*/


