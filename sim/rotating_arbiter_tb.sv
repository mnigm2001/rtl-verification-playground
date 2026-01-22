`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:10:22 PM
// Design Name: 
// Module Name: rotating_arbiter_tb
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
`include "rotating_arbiter_assertions.sv"

module rotating_arbiter_tb();
    
    localparam int N=4;
    
    logic                 clk;
    logic                 reset_n;
    logic                 grant_ack;
    logic [N-1:0]         req;
    logic [N-1:0]         grant;
    
    // DUT instantiation
    rotating_arbiter #(.N(N)) DUT (
        .clk       (clk),
        .reset_n   (reset_n),
        .grant_ack (grant_ack),
        .req       (req),
        .grant     (grant)
    );
    
    // Assertions module instantiation
    rotating_arbiter_assertions #(.N(N)) arb_assert (
        .clk       (clk),
        .reset_n   (reset_n),
        .req       (req),
        .grant     (grant),
        .grant_ack (grant_ack),
        .prev_idx  (DUT.prev_idx),
        .state     (DUT.state)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Stimulus task
    task drive_req_ack(input logic [N-1:0] r, input logic ack);
        @(negedge clk);
        req       <= r;
        grant_ack <= ack;
    endtask
    
    // Test sequence
    initial begin
        // Reset
        reset_n <= 1;
        @(posedge clk);
        reset_n <= 0;
        @(posedge clk);
        reset_n <= 1;
    
        // Scenario: single requests, ack handshake
        drive_req_ack(4'b0001, 0);
        drive_req_ack(4'b0001, 1);
        drive_req_ack(4'b1000, 0);
        drive_req_ack(4'b1000, 1);
        drive_req_ack(4'b0010, 0);
        drive_req_ack(4'b0010, 1);
        drive_req_ack(4'b0000, 0);
//        @(negedge clk);
        drive_req_ack(4'b1001, 1);
    
        // Finish
        #20 $finish;
    end
    
    // Monitor
    initial
        $monitor("%0dns | req=%b grant=%b ack=%b state=%0d prev_idx=%0d", $time, req, grant, grant_ack, DUT.state, DUT.prev_idx);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    logic grant_ack, clk=0, reset_n=1;
    logic [N-1:0] req, grant;
    
    rotating_arbiter #(
        .N(N)
    ) DUT (
        .clk(clk),
        .reset_n(reset_n),
        .grant_ack(grant_ack),
        .req(req),
        .grant(grant)
    );
    
    always #5 clk = ~clk;
    
    task nop_t (input int num_cycles);
        begin
            for (int i=0; i<num_cycles; i++)
                @(posedge clk);
        end
    endtask
    
    initial begin
        req = 0;
        grant_ack = 0;
        reset_n = 1;
        @(posedge clk); reset_n = 0;
        @(posedge clk); reset_n = 1;
       
        
//        @(posedge clk); grant_ack = 1'b0; req = 4'b0001; 
//        @(posedge clk); 
//        grant_ack = 1'b0; 
//        req = 4'b1000; 
//        @(posedge clk); 
//        @(posedge clk); 
//        grant_ack = 1'b1; 
//        req = 4'b1000; 
//        @(posedge clk); grant_ack = 1'b0; req = 4'b0010;    


        @(posedge clk); req = 4'b0001; 
        @(posedge clk); grant_ack = 1'b0;
        
        @(posedge clk); grant_ack = 1'b1; req = 4'b1000;
        @(posedge clk); grant_ack = 1'b0;
 
        @(posedge clk); grant_ack = 1'b0; req = 4'b0010;
        @(posedge clk); grant_ack = 1'b0;
        @(posedge clk); grant_ack = 1'b1;
        
        @(posedge clk); grant_ack = 1'b0; req = 4'b0000;
        @(posedge clk); grant_ack = 1'b1;
        nop_t(5);
        
        @(posedge clk); grant_ack = 1'b0; req = 4'b1001;
        @(posedge clk); grant_ack = 1'b1;
        
        #100;
        $finish;
    end
    
    initial begin
        $monitor("%t | req = %b grant = %b grant_ack = %b", $time, req, grant, grant_ack);
    end
    */
endmodule







//        for (int i=0; i<5; i++) begin
//            req = $random;
//            $display("%t | req=%b", $time, req);
//            @(posedge clk);
//            grant_ack = 1;
//            $display("%t | grant_ack=%b grant=%b \n", $time, grant_ack, grant);
//        end

//        @(posedge clk); grant_ack = 1'b0; req = 4'b0001; 
//        @(posedge clk); grant_ack = 1'b1;
        
//        @(posedge clk); grant_ack = 1'b0; req = 4'b1000;
//        @(posedge clk); grant_ack = 1'b1;
 
//        @(posedge clk); grant_ack = 1'b0; req = 4'b0010;
//        @(posedge clk); grant_ack = 1'b0;
//        @(posedge clk); grant_ack = 1'b1;
        
//        @(posedge clk); grant_ack = 1'b0; req = 4'b0000;
//        @(posedge clk); grant_ack = 1'b1;
        
//        @(posedge clk); grant_ack = 1'b0; req = 4'b1001;
//        @(posedge clk); grant_ack = 1'b1;
        
        /*
        | Time  | `req` | `grant_ack` | State Before Edge | State After Edge | `grant` After Edge | Notes                                                       |
| ----- | ----- | ----------- | ----------------- | ---------------- | ------------------ | ----------------------------------------------------------- |
| 0 ns  | 0001  | 0           | COMPUTE           | WAIT\_ACK        | 0001               |         |
| 10 ns | 1000  | 0           | WAIT\_ACK         | COMPUTE        | 0001               |                       |
| 20 ns | 1000  | 1           | COMPUTE**          | WAIT\_ACK          | 1000               |  |
| 30 ns | 0010  | 0           | WAIT\_ACK           | WAIT\_ACK        | 1000               |            |                              |
        */



