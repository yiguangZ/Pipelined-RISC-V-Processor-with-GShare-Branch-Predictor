# Pipelined RISC-V Processor with GShare Branch Predictor

This project implements a 5-stage pipelined RISC-V processor with an integrated dynamic branch prediction mechanism using a Global History Register (GHR) and Pattern History Table (PHT), based on the GShare strategy. The design includes a Branch Target Buffer (BTB) for jump and branch target caching, enabling speculative execution and improved performance under control hazards.

## 🚀 Features

- **5-stage RISC-V Pipeline**
  - Fetch (IF), Decode (ID), Execute (EX), Memory (MEM), Writeback (WB)
- **Branch Prediction**
  - Global History Register (GHR)
  - Pattern History Table (PHT) with 2-bit saturating counters
  - Branch Target Buffer (BTB) with associative storage
  - Misprediction detection and GHR reset logic
- **Forwarding and Hazard Control**
  - Basic data hazard mitigation using forwarding logic
  - Stalling and flushing support
- **Testbench**
  - Performance metrics including CPI, branch/jump misprediction rate, and register state inspection

## 🧠 How It Works

- **BTB** stores recently seen branch/jump PCs and their target addresses.
- **GHR** stores the global taken/not-taken history and is updated speculatively in the fetch stage.
- **PHT** uses the XOR of the PC and GHR to index a 2-bit saturating counter and predict if a branch will be taken.
- If mispredicted, the processor flushes incorrect stages and resets the GHR to maintain accurate global history.

## 📂 File Structure

- `ucsbece154b_datapath.v` — Implements the full processor datapath with branch predictor integration.
- `ucsbece154b_branch.v` — Contains the GHR, PHT, and BTB logic for branch prediction.
- `ucsbece154b_top_tb.v` — Testbench to evaluate processor correctness and performance.

## 📈 Example Outputs

- Final register state
- Branch/jump misprediction rates
- Cycle count and CPI

## 🛠️ Configuration

The predictor parameters can be customized by changing:
```verilog
parameter NUM_BTB_ENTRIES = 32;
parameter NUM_GHR_BITS = 5;
