`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 05:02:49 PM
// Design Name: 
// Module Name: arbiter_pkg
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


package arbiter_pkg;

  // Shared FSM state type for the rotating arbiter
  typedef enum logic {
    WAIT_ACK = 1'b0,
    COMPUTE  = 1'b1
  } arb_state_t;

endpackage : arbiter_pkg

