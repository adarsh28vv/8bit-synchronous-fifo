# 8-bit Synchronous FIFO (Verilog)

A small RTL project implementing an 8-bit-wide, 8-entry synchronous FIFO. It is intended as a learning project demonstrating RTL design and simulation-based functional checks.

## Features

- 8-bit data width and 8 storage entries
- Synchronous, active-high reset
- Read and write pointers with wrap-around
- `full` and `empty` status flags
- Occupancy tracking
- Support for simultaneous accepted read and write operations
- Testbench checks reset status, fill/drain behavior, FIFO ordering, and pointer wrap-around

## Files

- `fifo.v` — synthesizable FIFO RTL
- `tb_fifo.v` — Verilog testbench

## Run the testbench

With Icarus Verilog installed, run these commands from this directory:

```bash
iverilog -g2012 -o fifo_sim fifo.v tb_fifo.v
vvp fifo_sim
```

Expected final message:

```text
PASS: FIFO basic functionality tests completed successfully.
```

You can also open both files in ModelSim or QuestaSim, compile them, and run `tb_fifo`.

## Interface

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | Clock; state changes on rising edge |
| `rst` | Input | Synchronous active-high reset |
| `wr_en` | Input | Requests a write when FIFO is not full |
| `rd_en` | Input | Requests a read when FIFO is not empty |
| `din[7:0]` | Input | Write data |
| `dout[7:0]` | Output | Registered read data |
| `full` | Output | High when all entries are occupied |
| `empty` | Output | High when no entries are occupied |

## Design notes

A write is accepted only when `wr_en` is high and `full` is low. A read is accepted only when `rd_en` is high and `empty` is low. When both operations are accepted on the same clock edge, one item is read and one item is written, so occupancy remains unchanged.

This repository is a portfolio learning project. Before using it as evidence of a completed course or industry project, review the RTL, run the testbench in your simulator, and make sure you can explain the design and its limitations.
