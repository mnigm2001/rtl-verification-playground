`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:01:50 PM
// Design Name: 
// Module Name: rotating_arbiter
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

`include "arbiter_pkg.sv"

module rotating_arbiter #(
    parameter int N = 4
)(
    input logic clk,
    input logic reset_n,
    input logic grant_ack,
    input logic [N-1:0] req,
    output logic [N-1:0] grant
);
    import arbiter_pkg::*;
    
    // FSM state register
    arb_state_t   state;
    
    logic [$clog2(N)-1:0] prev_idx;
    logic [$clog2(N)-1:0] grant_idx;
    logic idx_found;
    
    
    // -------------- STATE CONTROL -------------- //
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= COMPUTE;
        end else begin
            case (state)
                WAIT_ACK: if (grant_ack)   state <= COMPUTE;
                COMPUTE: if (idx_found)   state <= WAIT_ACK;
            endcase
        end
    end
    
     // -------------- OUTPUT & POINTER UPDATE -------------- //
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            grant <= '0;
            prev_idx <= '0;
        end else begin
            case (state)
                WAIT_ACK: begin
                    grant <= grant;
                    prev_idx <= prev_idx;
                end
                COMPUTE: begin
                    grant <= '0;
                    if (idx_found) begin
                        grant[grant_idx] <= 1;
                        prev_idx <= grant_idx;
                    end
                end
            endcase
        end
    end
    
    // -------------- COMBINATIONAL SEARCH -------------- //
    always_comb begin
        idx_found = 0;
        for (int i=0; i<N; i++) begin
            automatic int rotated_idx = (prev_idx + i + 1) % (N);
            if ((req[rotated_idx] == 1) && !idx_found) begin
                grant_idx = rotated_idx;
                idx_found = 1;
            end
        end
    end
    
    /*
    Reset Clears Grant and State
    On reset (async or sync, as you've defined), grant must immediately go to all-zeros, and internal pointer (prev_idx) must be set to its defined reset value.
    */
     property p_reset_behavior;
       @(posedge clk)
       !reset_n |-> ##0 (grant == '0 && prev_idx == '0 && state == COMPUTE);
    endproperty 
    
    /*
    One-Hot or Zero Grant
    At every clock edge (outside of reset), grant must be either exactly one bit high (if there is at least one request) or entirely zero (if no requests).
    */
    property p_one_hot_grant;
        @(posedge clk) disable iff (!reset_n)
        $onehot0(grant);
    endproperty 
    
    /*
        Grant-Ack Handshake
        Once grant goes to a non-zero value, it must remain unchanged until grant_ack == 1.
        Conversely, while in the "COMPUTE" state (grant_ack seen), grant_ack must be low.
        
        
        i really made this --> "grant_ack must be low in COMPUTE"
    */
    property p_compute_ack;
        @(posedge clk) disable iff (!reset_n)
        state == COMPUTE |-> grant_ack == 0;
    endproperty
    
    /*
    Rotate Priority on Ack
    When grant_ack == 1, the next cycle's grant must be issued to the first request starting at index (prev_idx + 1) % N.
    Confirm that if two requests are high, the one at that rotated start index wins.
    
    ALTERNATIVE:
        Include condition in disable condition:
            @(posedge clk) disable iff (!reset_n || grant_ack) --> only check in COMPUTE and not while waiting.
    */
    function logic[N-1:0] expected_grant(input logic [N-1:0] req, input logic [$clog2(N)-1:0] prev_idx);
        expected_grant = '0;
        for (int i=0; i<N; i++) begin
            automatic int rotated_idx = (prev_idx+1+i) % (N);
            if (req[rotated_idx] == 1) begin
                expected_grant[rotated_idx] = 1; 
                break;
            end    
        end
    endfunction
    property p_expected_grant;
        @(posedge clk) disable iff (!reset_n)
        (state == COMPUTE && grant_ack == 0) |=> grant == expected_grant(req, prev_idx);
    endproperty
    
    /*
    Stable Grant During WAIT_ACK
    While in the WAIT_ACK state (grant_sent == 1 && grant_ack == 0), confirm that grant remains identical from cycle to cycle (no glitches).
    
    ALTERNATIVE:
        Include condition in disable condition:
            @(posedge clk) disable iff (!reset_n || state!=WAIT_ACK) --> DISABLE if state not in wait_ack
    */
    property p_stable_in_wait;
        @(posedge clk) disable iff (!reset_n)
        (state == WAIT_ACK && grant_ack == 0) |-> $stable(grant);
    endproperty
    
    /*
    Valid Grant Index
    Confirm that the index of the granted bit is always within 0 … N-1 (never an out-of-range index).
    */
    property p_valid_grant_idx;
        @(posedge clk) disable iff (!reset_n)
        (grant_idx >= 0) && (grant_idx < N);
    endproperty
    
    /*
    Sequence of ACK and New REQUEST
    If a new request arrives in the same cycle that grant_ack is sampled, verify the arbiter still honors the old grant until the next COMPUTE, then correctly considers the new req.
    
     This nearly duplicates the stable-grant check, and it's asking "if new req in WAIT_ACK, old grant holds"
• Better to fold into your stable-grant property, or target it specifically when req toggles. |
    */
    property p_wait_ack_new_req;
        @(posedge clk) disable iff (!reset_n)
        (state == WAIT_ACK && grant_ack == 1) |-> $stable(grant);
    endproperty
endmodule
