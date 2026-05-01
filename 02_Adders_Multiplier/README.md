# Project 02 — Adders & Multiplier

VHDL implementations of arithmetic data-path elements — from a 4-bit ripple-carry adder to 16-bit advanced adder architectures and a 4-bit array multiplier — all targeting the DE1-SoC FPGA board.

---

## Overview

This project explores the design, simulation, and timing analysis of fundamental arithmetic circuits. Starting with a basic 4-bit signed adder, it scales up to 16-bit adders using three different carry-propagation strategies, and concludes with a combinational array multiplier. All designs use registered inputs/outputs for synchronous operation and were verified in ModelSim before deployment on the DE1-SoC board via Quartus Prime.

---

## Project Structure

```
02_Adders_Multiplier/
├── src/
│   ├── part1_4bitRCA/                          # 4-bit Ripple-Carry Adder
│   ├── part2_4bitAdder_subtractor/             # 4-bit Adder/Subtractor (2's complement)
│   ├── part3_16bit_different_Adders/           # 16-bit adder comparison
│   │   ├── 16bitRCA/                           #   └─ Ripple-Carry Adder
│   │   ├── 16bit_Carry_bipass_Adder/           #   └─ Carry-Bypass Adder
│   │   └── 16bit_carry_select_Adder/           #   └─ Carry-Select Adder
│   └── part4_serial_bit_multiplier/            # 4×4 Array Multiplier
├── docs/
│   └── report_02.docx                          # Full report
└── README.md
```

---

## Part 1 — 4-Bit Signed Ripple-Carry Adder (RCA)

A synchronous 4-bit signed adder with registered inputs and outputs, overflow detection, and 7-segment display output.

### Architecture

```
ain[3:0] → regn → ┐
                   ├→ FA0─FA1─FA2─FA3 → regn → sout[3:0] → 7-seg
bin[3:0] → regn → ┘        ↓
                      C_in⊕C_out → FF → overflow (LEDR9)
```

- **4 Full Adders** chained in ripple-carry fashion; each FA uses a 2-to-1 multiplexer for carry generation.
- **Signed overflow** detected as `C_in(MSB) XOR C_out(MSB)`.
- **2-cycle latency** due to input and output register stages.

**Key files:** `bit_Full_Adder.vhd` (top), `FullAdder.vhd`, `regn.vhd`, `flipflop.vhd`, `mult2to1.vhd`, `seven_seg_dec.vhd`, `bit_Full_Adder_tb.vhd`

### Timing Results

| Metric              | Value       |
|---------------------|-------------|
| Max Frequency       | 471.25 MHz  |
| Critical Path Delay | 9.647 ns    |
| Slack               | +7.878 ns   |

---

## Part 2 — 4-Bit Adder/Subtractor

Extends Part 1 to support subtraction via **2's complement**: when `Op = '1'`, input B is inverted and `1` is injected through the carry-in.

```
Op = '0' → Addition:    S = A + B
Op = '1' → Subtraction: S = A + (NOT B) + 1   (i.e., A − B)
```

All original components (FAs, registers, flip-flop, 7-seg decoder) are reused. The `Op` signal is mapped to `SW8` on the DE1-SoC board.

**Key files:** `bit_Full_Adder.vhd` (top), `FullAdder.vhd`, `regn.vhd`, `flipflop.vhd`, `mult2to1.vhd`, `seven_seg_dec.vhd`, `bit_Full_Adder_tb.vhd`

### Timing Results

| Metric              | Value       |
|---------------------|-------------|
| Max Frequency       | 730.99 MHz  |
| Critical Path Delay | ~4.100 ns   |

---

## Part 3 — 16-Bit Adder Comparison

Three 16-bit adder architectures implemented and compared under identical timing constraints (10 ns clock / 100 MHz).

### 3a. 16-Bit Ripple-Carry Adder

Uses a `FOR GENERATE` loop to instantiate 16 full adders in a chain. Same registered I/O and overflow detection as Part 1, scaled to 16 bits.

**Key file:** `ripple_carry_16bit.vhd`

### 3b. 16-Bit Carry-Bypass Adder

Divides the 16-bit operands into four 4-bit blocks. Each block computes a group **propagate** signal (`p = a XOR b` for all 4 bits, AND'd together). A multiplexer per block selects between the block's computed carry-out or the bypassed carry-in, reducing worst-case carry propagation.

**Key files:** `bypass.vhd` (top), `propagate.vhd`, `bit_Full_Adder.vhd`, `mult2to1.vhd`

### 3c. 16-Bit Carry-Select Adder

Each 4-bit block is **duplicated** — one assumes `C_in = 0`, the other `C_in = 1`. Once the actual carry arrives, a 4-bit multiplexer instantly selects the correct sum and carry-out.

**Key files:** `carry_sellect.vhd` (top), `bit_Full_Adder.vhd`, `mult2to1.vhd`, `mult2to1_4bit.vhd`

### Performance Comparison

| Architecture     | Max Frequency | Critical Path Delay | Slack     |
|------------------|:------------:|:-------------------:|:---------:|
| Ripple-Carry     | 186.22 MHz   | 9.222 ns            | +4.630 ns |
| Carry-Bypass     | 132.08 MHz   | 11.904 ns           | +2.428 ns |
| Carry-Select     | 161.26 MHz   | 10.487 ns           | +3.799 ns |

> **Note:** At 16 bits, the simple RCA outperforms the more complex architectures due to lower routing and logic overhead. The advantages of Carry-Bypass and Carry-Select adders become more pronounced at wider bit-widths.

---

## Part 4 — 4×4 Array Multiplier

A combinational 4-bit × 4-bit unsigned multiplier producing an 8-bit product, using the traditional **paper-and-pencil** multiplication method.

### Architecture

1. **Partial product generation** — 16 AND gates compute `p[i][j] = A[i] AND B[j]`.
2. **Partial product summation** — 12 full adders arranged in a diagonal array accumulate the partial products into an 8-bit result.
3. **Display** — Inputs shown on HEX0–HEX1, product split into upper/lower nibbles on HEX3–HEX2.

```
SW[3:0] → regn → A ─┐
                     ├→ AND array → FA network → prod[7:0] → HEX2/HEX3
SW[7:4] → regn → B ─┘
```

**Key files:** `multiplier.vhd` (top), `FullAdder.vhd`, `regn.vhd`, `seven_seg_dec.vhd`, `multiplier_tb.vhd`

**Testbench cases:** 5×3=15, 10×4=40, 15×15=225, 7×8=56

---

## Tools & Target

| Tool           | Purpose                              |
|----------------|--------------------------------------|
| Quartus Prime  | Synthesis, place & route, timing     |
| ModelSim       | Functional & timing simulation       |
| DE1-SoC Board  | FPGA deployment & hardware testing   |

---

## How to Use

1. Open the desired part's Quartus project.
2. Compile the design (Analysis & Synthesis → Fitter → Assembler).
3. For timing analysis, apply the provided `.sdc` constraint file.
4. Simulate the testbench in **ModelSim**.
5. Program the DE1-SoC board to verify on hardware.

---

## Report

The full report with circuit diagrams, VHDL code screenshots, simulation waveforms, and timing analysis is available in [`docs/report_02.docx`](docs/report_02.docx).
