# SystemVerilog Verification Lab (SVA/ABV, UVM Fundamentals)

Learning and portfolio repository focused on RTL verification practices:
SystemVerilog testbenches, assertion-based verification (SVA), and UVM bring-up.

## Contents

- Arbiters
  - Priority arbiter (directed + random stimulus, SVA properties)
  - Rotating / round-robin arbiter (SVA checker module)
- Utility blocks
  - Pulse stretcher (TB + checks)
  - ROM 16x8 (TB + correctness checks)

## Verification Focus

- SVA / ABV: safety properties and protocol invariants (e.g., onehot0 grants, no-grant-without-request, reset behavior, stability during handshakes)
- Debug workflow: assertion failure triage, waveform inspection, iterative refinement of RTL and properties
- UVM fundamentals: `uvm_test` / `run_test()` bring-up (expanding over time)

## Notes

This repo is intentionally small-block focused to practice verification methodology:
spec → checks/properties → stimulus → debug → refine.

## Roadmap

- Add coverage collection and reporting
- Expand UVM to include basic agent/driver/monitor/scoreboard for the arbiter
- Add lint/formal-friendly assertion structure (assume/cover patterns)
