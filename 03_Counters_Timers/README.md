# Project 03 — Counters & Timers

Sequential digital logic designs in VHDL — from a gate-level SR latch to a complete FSM-controlled reaction timer — all targeting the DE1-SoC FPGA board.

---

## Overview

This project explores sequential circuit design through five incremental parts. It demonstrates progression from basic gate-level latches to complex FSM-controlled timing systems, covering both structural and behavioural modelling styles, component reusability, clock division, and real hardware interfacing (switches, push-buttons, LEDs, and 7-segment displays) on the DE1-SoC board.

---

## Project Structure

```
03_Counters_Timers/
├── src/
│   ├── part1_SR_LAtch/                    # Gated SR latch
│   ├── part2_16bit_synchronous_counter/   # Structural counter (T flip-flops)
│   ├── part3_counter_behavioural/         # Behavioural counter
│   ├── part4_flashing_digits/             # 0–9 digit flasher with clock divider
│   └── Part5_Reaction_Timer/              # FSM reaction timer with BCD display
├── docs/
│   ├── Report.pdf                         # Full report with waveforms
│   └── images/                            # Extracted report figures
└── README.md
```

---

## Part 1 — Gated SR Latch

A **structural** implementation of a gated SR latch using fundamental logic gates (AND, NOR).

```
S ──┐
    AND──S_g──NOR──Qa ──→ Q
Clk─┤         ╲╱
    AND──R_g──NOR──Qb
R ──┘
```

- Cross-coupled NOR gates form the latch core.
- Gating AND gates enable set/reset only when `Clk = '1'`.
- The `keep` attribute is applied to internal signals to prevent Quartus from optimising away the feedback loop during synthesis.

**Source files:**
- `SRLatch.vhd` — Structural gate-level latch
- `SRLatch_tb.vhd` — Testbench verifying set, reset, hold, and invalid (S=R=1) states

---

## Part 2 — 16-Bit Synchronous Counter (Structural)

A 16-bit binary counter built by cascading **T flip-flop** components with a synchronous carry chain.

### Architecture

```
Enable ──→ T₀ ─carry→ T₁ ─carry→ T₂ ─carry→ ... ─carry→ T₁₅
             │          │          │                    │
             ▼          ▼          ▼                    ▼
           Q[0]       Q[1]       Q[2]      ...       Q[15]
                                                        │
                          count_out[15:0] ──→ 4 × seven_seg_dec ──→ HEX0–HEX3
```

- **`Tflip_flop.vhd`** — T flip-flop with synchronous clear and toggle enable.
- **Carry chain:** `carry(i) = carry(i-1) AND Q(i)` — ensures each stage only toggles when all lower bits are `1`.
- **`FOR GENERATE`** loop instantiates bits 1–15 with their carry logic.
- Four `seven_seg_dec` instances display the 16-bit count in hexadecimal on HEX0–HEX3.

**Key files:** `sixteen_bit_counter.vhd` (top), `Tflip_flop.vhd`, `seven_seg_dec.vhd`, `sixteen_bit_counter_tb.vhd`

**Board mapping:** `KEY(0)` = clock, `SW(0)` = reset (active-high), `SW(1)` = enable.

---

## Part 3 — 16-Bit Synchronous Counter (Behavioural)

A functionally equivalent 16-bit counter written in a **behavioural** style — a single synchronous process using VHDL arithmetic (`Q <= Q + 1`), letting the synthesis tool infer the necessary hardware.

```vhdl
process (KEY, SW(0))
begin
    if (SW(0) = '0') then
        Q <= (others => '0');        -- asynchronous reset
    elsif rising_edge(KEY) then
        if SW(1) = '1' then
            Q <= Q + 1;              -- count up
        end if;
    end if;
end process;
```

This contrasts with Part 2's structural approach — same behaviour, dramatically simpler code, but less control over the resulting hardware.

**Key files:** `sixteen_bit_counterv2.vhd` (top), `seven_seg_dec.vhd`, `sixteen_bit_counterv2_tb.vhd`

---

## Part 4 — Flashing Digit (0–9)

A modulo-10 digit counter that increments once per second and displays on HEX0, demonstrating **clock division** from 50 MHz to 1 Hz.

### Architecture

```
CLOCK_50 ──→ [26-bit counter (structural T-FF chain)] ──→ 1 Hz tick
                                                              │
                                                              ▼
                                            [4-bit mod-10 counter] ──→ seven_seg_dec ──→ HEX0
```

1. **26-bit clock divider** — A structural counter (same T flip-flop chain as Part 2) counts up to 50,000,000. When the terminal count is reached, a single-cycle `one_hz_tick` pulse is generated and the counter resets.
2. **4-bit digit counter** — Another structural T flip-flop chain, clocked by the 1 Hz tick, counts 0→9 and wraps back to 0 (modulo-10 reset when reaching `1010`).
3. For **simulation**, the terminal count is reduced to 50 to make waveforms observable.

**Key files:** `Flashing.vhd` (top), `Tflip_flop.vhd`, `seven_seg_dec.vhd`, `tb_flashing.vhd`

---

## Part 5 — Reaction Timer

A complete reaction-time measurement system controlled by a **3-state FSM**. It waits for a configurable delay, lights an LED, measures the user's reaction in milliseconds, and displays the result in decimal on four 7-segment displays.

### FSM States

```
         ┌──────────┐     delay elapsed     ┌──────────┐    KEY3 pressed    ┌──────────┐
Reset ──→│ WAITING  │ ─────────────────────→ │ COUNTING │ ─────────────────→ │ STOPPED  │
         │ LED off  │                        │ LED on   │                    │ LED off  │
         │ wait++   │                        │ ms++     │                    │ display  │
         └──────────┘                        └──────────┘                    └──────────┘
                                                                                  │
                                                              KEY0 reset ◄────────┘
```

### Components

| Module | Function |
|--------|----------|
| **`reaction.vhd`** | Top-level entity: FSM + 1 kHz tick generator (50 MHz ÷ 50,000) + signal wiring |
| **`BCD.vhd`** | 16-bit binary → 4-digit BCD converter using the **Double Dabble** (shift-and-add-3) algorithm |
| **`seven_seg_dec.vhd`** | 4-bit to 7-segment decoder for digits 0–9 |

### How It Works

1. **WAITING** — On reset, the FSM counts 1 kHz ticks until the wait counter matches the delay value set on `SW[7:0]`. This provides a user-configurable delay of 0–255 ms.
2. **COUNTING** — The LED turns on and a 16-bit millisecond counter starts incrementing on every 1 kHz tick.
3. **STOPPED** — When the user presses `KEY3`, the LED turns off and the elapsed time is frozen. The `binary_to_bcd` module converts the 16-bit count to four BCD digits, which are displayed on HEX0–HEX3 (units to thousands of milliseconds).
4. **Reset** — Pressing `KEY0` returns to the WAITING state.

**Key files:** `reaction.vhd` (top), `BCD.vhd`, `seven_seg_dec.vhd`, `reaction_tb.vhd`

---

## Hardware Mapping (DE1-SoC)

| Board Resource | Signal | Function |
|---|---|---|
| `CLOCK_50` | 50 MHz | System clock (Parts 4 & 5) |
| `KEY(0)` | Active-low | Clock (Parts 1–3) / Reset (Parts 4–5) |
| `KEY(3)` | Active-low | Stop button (Part 5) |
| `SW[0]` | Switch | Reset / Clear |
| `SW[1]` | Switch | Enable |
| `SW[7:0]` | Switches | Delay value for reaction timer (Part 5) |
| `HEX0`–`HEX3` | 7-seg | Counter / timer display |
| `LEDR` | LED | Reaction timer indicator (Part 5) |

---

## Tools & Target

| Tool | Purpose |
|------|---------|
| Quartus Prime | Synthesis, place & route |
| ModelSim | Functional simulation |
| DE1-SoC Board | FPGA deployment & hardware testing |

---

## How to Use

1. Open the desired part's Quartus project in **Quartus Prime**.
2. Compile the design.
3. Simulate with **ModelSim** using the provided `*_tb.vhd` testbench.
4. For Parts 4 & 5: adjust the clock divider terminal count for simulation vs. hardware.
5. Program the DE1-SoC board to verify on hardware.

---

## Report

The full report with circuit diagrams, simulation waveforms, and analysis is available in [`docs/Report.pdf`](docs/Report.pdf).
