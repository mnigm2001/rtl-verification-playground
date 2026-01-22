`timescale 1ns/1ps
`include "arbiter_pkg.sv"

module rotating_arbiter_assertions #(
    parameter int N = 4
)(
    input  logic                 clk,
    input  logic                 reset_n,
    input  logic [N-1:0]         req,
    input  logic [N-1:0]         grant,
    input  logic                 grant_ack,
    input  logic [$clog2(N)-1:0] prev_idx,
    input  arbiter_pkg::arb_state_t state
);
  import arbiter_pkg::*;

  // 1) Reset clears everything
  property RESET_CLEARS_STATE;
    @(negedge clk) disable iff (reset_n)
      (grant == '0) && (prev_idx == '0) && (state == COMPUTE);
  endproperty
  assert property (RESET_CLEARS_STATE)
    else $error("[rot_arb][RESET] State not cleared");

  // 2) Grant is one-hot or zero
  property ONEHOT0_GRANT;
    @(posedge clk) disable iff (!reset_n)
      $onehot0(grant);
  endproperty
  assert property (ONEHOT0_GRANT)
    else $error("[rot_arb][ONEHOT0] Invalid grant: %b", grant);

  // 3) No grant without any request
  property NO_REQ_NO_GRANT;
    @(posedge clk) disable iff (!reset_n)
      (req == '0) |=> (grant == '0);
  endproperty
  assert property (NO_REQ_NO_GRANT)
    else $error("[rot_arb][NO_REQ] Grant non-zero when req==0");

  // 4) Stable grant during WAIT_ACK
  property STABLE_IN_WAIT;
    @(posedge clk) disable iff (!reset_n)
      (($past(state) == WAIT_ACK) && (state == WAIT_ACK)) |-> $stable(grant);
  endproperty
  assert property (STABLE_IN_WAIT)
    else $error("[rot_arb][STABLE] Grant changed in WAIT_ACK");

  // 5) Rotate priority in COMPUTE
  function automatic logic [N-1:0] expected_grant_fn(
    input logic [N-1:0]         req_i,
    input logic [$clog2(N)-1:0] prev_idx_i
  );
    expected_grant_fn = '0;
    for (int j = 1; j <= N; j++) begin
      int idx = (prev_idx_i + j) % N;
      if (req_i[idx]) begin
        expected_grant_fn[idx] = 1'b1;
        break;
      end
    end
  endfunction

  property ROTATE_IN_COMPUTE;
    @(posedge clk) disable iff (!reset_n || grant_ack || state != COMPUTE)
      ##1 (grant == expected_grant_fn(req, prev_idx));
  endproperty
  assert property (ROTATE_IN_COMPUTE)
    else $error("[rot_arb][ROTATE] grant=%b expected=%b",
                 grant, expected_grant_fn(req, prev_idx));

endmodule : rotating_arbiter_assertions
