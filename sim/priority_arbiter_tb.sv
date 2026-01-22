`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:14:54 PM
// Design Name: 
// Module Name: priority_arbiter_tb
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 04:07:42 PM
// Design Name: 
// Module Name: priority_encoder_tb
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



module priority_arbiter_tb ();

    localparam int N = 4;
    localparam int NUM_TESTS = 3;
    
    logic clk=0, reset_n=1;
    logic [N-1:0] req, grant;
    logic [N-1:0] req_data[NUM_TESTS-1:0];
    
    priority_arbiter #(
        .N(N)
    ) DUT (
        .clk(clk),
        .reset_n(reset_n),
        .req(req),
        .grant(grant)
    );
    
    always #5 clk=~clk; 
    
    initial begin
        req_data = '{4'b0001, 4'b1001, 4'b0000};
        reset_n = 1'b0;
        req = '0;
        @(posedge clk);
         @(posedge clk);
        reset_n = 1'b1;
        @(posedge clk);
        @(posedge clk);
        req = '0;       // keep req 0 for a cycle
        @(posedge clk);
        @(posedge clk);
        req = '0;
        @(posedge clk); // still zero
        
        for (int i=0; i<NUM_TESTS; i++) begin
            $display("%t | req:%b", $time, req);
            req = req_data[i];
            @(posedge clk);
            $display("grant:%b", grant);
        end
        #50;
        $finish();
    end
    
   function automatic logic [N-1:0] expected_grant(input logic [N-1:0] req);
        expected_grant = '0;
        for(int i=0; i<N; i++) begin
            if(req[i] == 1) begin
                expected_grant[i] = 1'b1;
                break;
            end
        end
    endfunction 
    
    property p_reset_behavior;
        @(posedge clk)
        (!reset_n) |-> (grant == '0);
    endproperty
    
    property p_one_hot_grant;
        @(posedge clk) disable iff (!reset_n)
        ($countones(grant) <= 1);    
    endproperty
    
    property p_priority_grant;
        @(posedge clk) disable iff (!reset_n)
        (grant == expected_grant(req));
    endproperty
    
    property p_all_req_bits_zero;
        @(posedge clk) disable iff (!reset_n)
        (!req |-> !grant);
    endproperty
    
    property p_grant_stability;
        @(posedge clk) disable iff (!reset_n)
        (($past(req) == req) |-> ($past(grant) == grant));
    endproperty
    
    
    // Assertions
    assert property (p_reset_behavior)
        else $error(1, "[prio_encoder_tb][reset_behavior] Assertion Failed: Grant not initialized to zero upon reset -- \n\t req=%b grant=%b, time=%0t", req, grant, $time);
    assert property (p_one_hot_grant)
        else $error(1, "[prio_encoder_tb][one_hot_grant] Assertion Failed: Multiple requests granted -- \n\t req=%b grant=%b, time=%0t", req, grant, $time);
    assert property (p_priority_grant)
        else $error(1, "[prio_encoder_tb][priority_grant] Assertion Failed: Mismatched between expected and realized grant -- \n\t req=%b grant=%b expected_grant=%b, time=%0t", req, grant, expected_grant(req),  $time);
    assert property (p_all_req_bits_zero)
        else $error(1, "[prio_encoder_tb][all_req_bits_zero] Assertion Failed: Non-zero grant for zero requests -- \n\t req=%b grant=%b, time=%0t", req, grant, $time);
    assert property (p_grant_stability)
        else $error(1, "[prio_encoder_tb][all_req_bits_zero] Assertion Failed: Non-zero grant for zero requests -- \n\t req=%b grant=%b, time=%0t", req, grant, $time);
        
endmodule

