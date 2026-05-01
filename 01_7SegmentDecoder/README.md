# Project 01 — 7-Segment Display Decoder & Display Systems

VHDL designs for driving 7-segment displays on the DE1-SoC board, progressing from a basic character decoder to a full binary-to-BCD converter.

---

## Overview

This project explores combinational logic design through four incremental parts, each building on the previous one. All designs target the DE1-SoC FPGA board and were simulated with ModelSim before deployment via Quartus Prime.

---

## Project Structure

```
01_7SegmentDecoder/
├── src/
│   ├── Part1_seven_segment_decoder/   # Basic character decoder
│   ├── Part2_muxing_seven_segment/    # Word display with mux + shifter
│   ├── Part3_binary2decimal_converter/ # 4-bit binary → decimal (0–15)
│   └── Part4_binary2BCD_converter/    # 6-bit binary → BCD (0–63)
├── docs/
│   └── 01_REPORT.pdf                  # Full report with figures
└── README.md
```

---

## Part 1 — Seven-Segment Character Decoder

A simple combinational decoder that maps a 3-bit input to a 7-segment display pattern, producing the characters **H**, **E**, **L**, and **O**.

| Input (`C`) | Display |
|:-----------:|:-------:|
| `000`       | H       |
| `001`       | E       |
| `010`       | L       |
| `011`       | O       |
| others      | blank   |

**Source files:**
- `decoder7.vhd` — 3-bit to 7-segment decoder (IF-ELSIF chain)
- `decoder7_tb.vhd` — Testbench exercising all 8 input combinations

---

## Part 2 — Multiplexed Word Display with Circular Shifter

Displays a selectable 5-character word across five 7-segment displays (HEX0–HEX4) and supports circular shifting of the characters.

### Architecture

```
SW[1:0] → MUX → 15-bit word → SHIFTER → 5 × decoder7 → HEX0–HEX4
              (select word)    SW[4:2]
                              (shift amount)
```

- **`mux.vhd`** — 2-bit select chooses one of four words: HELLO, CEPPO, CELLO, FEPPO (each encoded as a 15-bit vector of five 3-bit character codes).
- **`shifter.vhd`** — Barrel-style circular shifter controlled by `SW[4:2]`, rotating the 15-bit word by 0–4 character positions.
- **`decoder7.vhd`** — Extended decoder supporting 7 characters (H, E, L, O, C, P, F).
- **`part2.vhd`** — Top-level structural entity wiring mux → shifter → 5 decoders.
- **`tb_Part2.vhd`** — Testbench verifying all four words and multiple shift amounts.

---

## Part 3 — 4-Bit Binary to Decimal Converter

Converts a 4-bit binary input (0–15) into a two-digit decimal display on HEX1 (tens) and HEX0 (ones).

### Architecture

The design uses a **comparator + correction** approach:

1. **`comparator.vhd`** — Checks if the input `v > 9`; outputs flag `z`.
2. **`circuitA.vhd`** — Subtracts 2 from the lower 3 bits (part of the tens-digit correction).
3. **`circuitB.vhd`** — Drives HEX1 to display `1` when `z = '1'`, or `0` otherwise.
4. **`mux.vhd`** — 2-to-1 bit-level multiplexer selects between raw and corrected bits based on `z`.
5. **`decoder7.vhd`** — 4-bit to 7-segment decoder for digits 0–9.
6. **`bin2dec.vhd`** — Top-level structural entity connecting all components.
7. **`part3_tb.vhd`** — Testbench verifying representative values (0, 1, 2, 3, 4, 7, 11, 15).

---

## Part 4 — 6-Bit Binary to BCD Converter

Extends the conversion to handle 6-bit binary inputs (0–63), displaying two decimal digits on HEX1 (tens) and HEX0 (ones).

### Architecture

- **`circuitA.vhd`** — Iterative subtraction of 10 to extract the tens digit; the remainder gives the ones digit.
- **`decoder7.vhd`** — Same 4-bit to 7-segment decoder as Part 3.
- **`bin2bcd.vhd`** — Top-level structural entity: `circuitA` → two `decoder7` instances.
- **`bin_to_BCD_tb.vhd`** — Testbench with 8 cases covering boundary values (0, 5, 10, 15, 19, 20, 35, 51).

---

## Tools & Target

| Tool           | Purpose                        |
|----------------|--------------------------------|
| Quartus Prime  | Synthesis, place & route       |
| ModelSim       | Functional & timing simulation |
| DE1-SoC Board  | FPGA deployment & verification |

---

## How to Use

1. Open the desired part's project in **Quartus Prime**.
2. Compile and run **Analysis & Synthesis**.
3. Simulate using **ModelSim** with the provided testbench.
4. Program the DE1-SoC board to verify on hardware.

---

## Report

The full report with circuit diagrams, simulation waveforms, and analysis is available in [`docs/01_REPORT.pdf`](docs/01_REPORT.pdf).
