# Project 04 — FSM "HELLO" Scrolling Display

A finite state machine that scrolls the word **HELLO** across six 7-segment displays on the DE1-SoC board, shifting one character per second using a pipeline of registers.

---

## Overview

This project implements a Moore-type FSM that sequentially outputs the characters **H → E → L → L → O → (blank)** and then continuously loops, creating an infinite scrolling effect across HEX0–HEX5. The scroll rate is governed by a 1 Hz pulse derived from the 50 MHz on-board clock. The design demonstrates FSM design, pipeline register chains, and clock division in VHDL.

---

## Project Structure

```
04_FSM_HELLO_Display/
├── src/
│   ├── Hello_FSM.vhd          # Top-level FSM + pipeline
│   ├── Hello_FSM_tb.vhd       # Testbench
│   ├── one_hz_counter.vhd     # Clock divider (50 MHz → 1 Hz)
│   ├── seven_bit_register.vhd # 7-bit register with enable & reset
│   └── Hello_fsm.qpf          # Quartus project file
├── docs/
│   └── 04.docx                # Report with waveforms
└── README.md
```

---

## Architecture

### Block Diagram

```
                         ┌─────────────────────────────────────────┐
  CLOCK_50 ──→ 1 Hz     │              FSM Controller             │
               Counter ──┤  S_H → S_E → S_L1 → S_L2 → S_O →     │
                  │      │  S_BLANK → S_LOOP (feeds back stage5)   │
  KEY(0)  ──→ Reset      │                                         │
                         └──────────┬──────────────────────────────┘
                                    │ char_input (7-bit segment code)
                                    ▼
              ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
              │ Reg0 │→ │ Reg1 │→ │ Reg2 │→ │ Reg3 │→ │ Reg4 │→ │ Reg5 │─┐
              └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘ │
                 ▼         ▼         ▼         ▼         ▼         ▼     │
               HEX0      HEX1     HEX2      HEX3     HEX4      HEX5    │
                                                                         │
                              (feedback in S_LOOP state) ◄───────────────┘
```

### Components

#### `Hello_FSM.vhd` — Top-Level Entity

- **FSM States:** `S_H`, `S_E`, `S_L1`, `S_L2`, `S_O`, `S_BLANK`, `S_LOOP`
- **State Register:** Updates on the rising edge of `CLOCK_50`, gated by the 1 Hz pulse.
- **Output Logic:** Maps each state to a 7-segment constant (`SEG_H`, `SEG_E`, `SEG_L`, `SEG_O`, `SEG_SPACE`). In `S_LOOP`, the last pipeline stage's output (`stage5`) is fed back as the next input, creating the continuous scroll.
- **Pipeline:** Six `seven_bit_register` instances form a shift chain. On each 1 Hz tick, every register latches its predecessor's output, shifting all characters one position to the left.

#### `one_hz_counter.vhd` — Clock Divider

- Counts rising edges of the 50 MHz clock up to **49,999,999** (for hardware) to produce a single-cycle `TC` pulse every second.
- For **simulation**, the terminal count is reduced to **9** so the scrolling effect is visible in a short waveform window.
- Includes synchronous clear and enable inputs.

#### `seven_bit_register.vhd` — Pipeline Register

- 7-bit register with synchronous reset and clock enable.
- Loads input `R` into output `Q` on the rising clock edge when `enable = '1'`.

---

## 7-Segment Encoding

| Character | Segment Code (active low) |
|:---------:|:-------------------------:|
| H         | `0001001`                 |
| E         | `0000110`                 |
| L         | `1000111`                 |
| O         | `1000000`                 |
| (blank)   | `1111111`                 |

---

## Simulation

The testbench (`Hello_FSM_tb.vhd`) exercises the design as follows:

1. Generate a 50 MHz clock (20 ns period).
2. Assert active-low reset (`KEY(0) = '0'`) for 100 ns.
3. Release reset and observe the scrolling pattern on HEX0–HEX5.
4. Optionally re-assert reset to verify restart behavior.

With the simulation-friendly counter (terminal count = 9), characters shift every 10 clock cycles, making the waveform easy to inspect.

---

## Hardware Mapping (DE1-SoC)

| Board Resource | Signal        | Function               |
|----------------|---------------|------------------------|
| `CLOCK_50`     | 50 MHz clock  | System clock           |
| `KEY(0)`       | Active-low    | Synchronous reset      |
| `HEX0`–`HEX5` | 7-seg outputs | Character display      |

---

## Tools & Target

| Tool           | Purpose                              |
|----------------|--------------------------------------|
| Quartus Prime  | Synthesis, place & route             |
| ModelSim       | Functional simulation                |
| DE1-SoC Board  | FPGA deployment & hardware testing   |

---

## How to Use

1. Open `Hello_fsm.qpf` in **Quartus Prime**.
2. Compile the design.
3. Simulate with **ModelSim** using `Hello_FSM_tb.vhd`.
4. For hardware deployment, change the terminal count in `one_hz_counter.vhd` back to `49999999` for a real 1 Hz pulse.
5. Program the DE1-SoC board and observe "HELLO" scrolling across the displays.

---

## Report

The full report with FSM state diagrams, simulation waveforms, and hardware verification details is available in [`docs/04.docx`](docs/04.docx).
