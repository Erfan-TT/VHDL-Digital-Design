<p align="center">
  <strong>🔧 VHDL Digital Design — RTL Elements & Architectures</strong>
</p>

<p align="center">
  A comprehensive collection of VHDL designs covering the fundamental RTL building blocks of digital systems — from combinational decoders to pipelined arithmetic units, synchronous counters, and finite state machines — all synthesised, simulated, and verified on the <strong>DE1-SoC FPGA</strong>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Language-VHDL-blue?style=flat-square" alt="VHDL">
  <img src="https://img.shields.io/badge/Board-DE1--SoC-orange?style=flat-square" alt="DE1-SoC">
  <img src="https://img.shields.io/badge/Tool-Quartus%20Prime-purple?style=flat-square" alt="Quartus Prime">
  <img src="https://img.shields.io/badge/Simulation-ModelSim-green?style=flat-square" alt="ModelSim">
</p>

---

## 📖 About

This repository is a **comprehensive project to design, analyse, and verify the core RTL (Register-Transfer Level) elements used in digital systems**. Each module progresses in complexity — starting with pure combinational logic, advancing through synchronous data-path components, and culminating in FSM-controlled systems with real-time I/O. Every design follows a disciplined workflow:

1. **Specification** — define the interface and behaviour  
2. **RTL Implementation** — write structural or behavioural VHDL  
3. **Functional Simulation** — verify with ModelSim testbenches  
4. **Synthesis & Timing Analysis** — compile in Quartus Prime and evaluate critical paths  
5. **Hardware Verification** — deploy on the DE1-SoC board and test with physical I/O  

The project covers the following key digital design concepts:

| Concept | Where |
|---|---|
| Combinational logic & decoders | Project 01 |
| Multiplexers, barrel shifters | Project 01 |
| Binary-to-BCD conversion (iterative & Double Dabble) | Projects 01, 03 |
| Ripple-carry, carry-bypass & carry-select adders | Project 02 |
| 2's complement arithmetic & overflow detection | Project 02 |
| Array multiplication | Project 02 |
| Latches & flip-flops (SR, T, D) | Projects 02, 03 |
| Structural vs. behavioural counter design | Project 03 |
| Clock division (50 MHz → 1 Hz / 1 kHz) | Projects 03, 04 |
| FSM design (Moore machine) | Projects 03, 04 |
| Pipeline register chains | Project 04 |
| Real-time reaction measurement | Project 03 |

---

## 🗂️ Repository Structure

```
VHDL-Digital-Design/
│
├── 01_7SegmentDecoder/           ← 7-seg decoders, mux displays, BCD converters
│   ├── src/
│   │   ├── Part1_seven_segment_decoder/
│   │   ├── Part2_muxing_seven_segment/
│   │   ├── Part3_binary2decimal_converter/
│   │   └── Part4_binary2BCD_converter/
│   ├── docs/
│   └── README.md
│
├── 02_Adders_Multiplier/         ← Arithmetic units: adders & multiplier
│   ├── src/
│   │   ├── part1_4bitRCA/
│   │   ├── part2_4bitAdder_subtractor/
│   │   ├── part3_16bit_different_Adders/
│   │   │   ├── 16bitRCA/
│   │   │   ├── 16bit_Carry_bipass_Adder/
│   │   │   └── 16bit_carry_select_Adder/
│   │   └── part4_serial_bit_multiplier/
│   ├── docs/
│   └── README.md
│
├── 03_Counters_Timers/           ← Sequential logic: counters, timers, reaction game
│   ├── src/
│   │   ├── part1_SR_LAtch/
│   │   ├── part2_16bit_synchronous_counter/
│   │   ├── part3_counter_behavioural/
│   │   ├── part4_flashing_digits/
│   │   └── Part5_Reaction_Timer/
│   ├── docs/
│   └── README.md
│
├── 04_FSM_HELLO_Display/         ← FSM-driven scrolling text display
│   ├── src/
│   ├── docs/
│   └── README.md
│
└── README.md                     ← You are here
```

> Each sub-folder contains its own **README** (or `Readme.txt`) with detailed architecture descriptions, source file guides, and usage instructions.

---

## 🧪 Projects at a Glance

### [Project 01 — 7-Segment Display Decoder & Display Systems](01_7SegmentDecoder/)

Combinational logic designs for driving 7-segment displays, progressing through four parts:

| Part | Design | Key Technique |
|:----:|--------|---------------|
| 1 | Character decoder (H, E, L, O) | IF-ELSIF combinational process |
| 2 | Multiplexed word display with circular shifter | Barrel shifter, structural composition |
| 3 | 4-bit binary → 2-digit decimal converter | Comparator + correction circuit |
| 4 | 6-bit binary → BCD converter | Iterative subtraction |

---

### [Project 02 — Adders & Multiplier](02_Adders_Multiplier/)

Arithmetic data-path elements with registered I/O and timing analysis:

| Part | Design | Key Technique |
|:----:|--------|---------------|
| 1 | 4-bit signed Ripple-Carry Adder | Structural FA chain, signed overflow (C_in ⊕ C_out) |
| 2 | 4-bit Adder / Subtractor | 2's complement via B-inversion + carry-in |
| 3 | 16-bit Adder comparison | RCA vs. Carry-Bypass vs. Carry-Select |
| 4 | 4×4 Array Multiplier | AND partial products + 12-FA summation network |

**16-Bit Adder Performance Comparison:**

| Architecture | Max Freq. | Critical Path | Slack |
|:---|:---:|:---:|:---:|
| Ripple-Carry | 186.22 MHz | 9.222 ns | +4.630 ns |
| Carry-Bypass | 132.08 MHz | 11.904 ns | +2.428 ns |
| Carry-Select | 161.26 MHz | 10.487 ns | +3.799 ns |

---

### [Project 03 — Counters & Timers](03_Counters_Timers/)

Sequential logic designs spanning latches, counters, clock dividers, and a complete reaction-time measurement system:

| Part | Design | Key Technique |
|:----:|--------|---------------|
| 1 | Gated SR Latch | Structural gate-level modelling with `keep` attribute |
| 2 | 16-bit synchronous counter | Structural T flip-flop chain with carry logic (`FOR GENERATE`) |
| 3 | 16-bit counter (behavioural) | Single-process behavioural style (`Q <= Q + 1`) |
| 4 | Flashing digit (0–9) | 26-bit clock divider (50 MHz → 1 Hz) + modulo-10 counter |
| 5 | Reaction Timer | 3-state FSM (WAITING → COUNTING → STOPPED), 1 kHz tick, Double Dabble BCD, 4-digit 7-seg display |

---

### [Project 04 — FSM "HELLO" Scrolling Display](04_FSM_HELLO_Display/)

A Moore-type FSM that scrolls **H E L L O** across six 7-segment displays at 1-second intervals:

- **7 FSM states** control character injection into a 6-stage pipeline of 7-bit registers  
- **1 Hz clock divider** derived from the 50 MHz board clock  
- **Continuous looping** achieved by feeding the last register's output back through the FSM  

---

## 🔩 Reusable Component Library

Throughout the projects, several components are designed once and reused across multiple modules:

| Component | Description | Used In |
|-----------|-------------|---------|
| `FullAdder` | 1-bit full adder (XOR + MUX carry) | Projects 02, 03 |
| `decoder7` / `seven_seg_dec` | 7-segment display decoder | All projects |
| `regn` | N-bit register with synchronous reset | Projects 02, 04 |
| `flipflop` | D flip-flop with active-low reset | Projects 02, 03 |
| `Tflip_flop` | T flip-flop with synchronous clear | Project 03 |
| `mult2to1` | 2-to-1 multiplexer | Project 02 |
| `binary_to_bcd` | 16-bit Double Dabble BCD converter | Project 03 |
| `seven_bit_register` | 7-bit register with enable | Project 04 |
| `one_hz_counter` | 50 MHz → 1 Hz clock divider | Project 04 |

---

## 🛠️ Tools & Platform

| Tool | Role |
|------|------|
| **VHDL** | Hardware description language for all designs |
| **Intel Quartus Prime** | Synthesis, place & route, timing analysis (TimeQuest) |
| **ModelSim** | Functional and timing simulation |
| **DE1-SoC (Cyclone V)** | Target FPGA board with switches, keys, LEDs, 7-segment displays |

---

## 🚀 Getting Started

### Prerequisites

- [Intel Quartus Prime Lite](https://www.intel.com/content/www/us/en/software-kit/825278/intel-quartus-prime-lite-edition-design-software.html) (free edition)
- ModelSim — included with Quartus Prime Lite
- DE1-SoC FPGA board (or any Cyclone V board with minor pin re-assignment)

### Workflow

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/VHDL-Digital-Design.git
cd VHDL-Digital-Design

# 2. Open any project's Quartus file (e.g., Project 04)
#    File → Open Project → 04_FSM_HELLO_Display/src/Hello_fsm.qpf

# 3. Compile the design
#    Processing → Start Compilation

# 4. Simulate in ModelSim
#    Use the testbench file (*_tb.vhd) provided in each src/ directory

# 5. Program the FPGA
#    Tools → Programmer → select the .sof file → Start
```

### Quick Simulation (ModelSim standalone)

```bash
# Example: simulate the 4-bit RCA
cd 02_Adders_Multiplier/src/part1_4bitRCA
vlib work
vcom *.vhd
vsim bit_Full_Adder_tb
run -all
```

---

## 📄 Reports & Documentation

Each project includes a detailed report in its `docs/` folder with:

- ✅ Circuit schematics and block diagrams  
- ✅ VHDL code walkthroughs  
- ✅ ModelSim simulation waveforms  
- ✅ Quartus TimeQuest timing analysis results  
- ✅ DE1-SoC hardware test observations  

| Project | Report |
|---------|--------|
| 01 — 7-Segment Decoder | [`01_7SegmentDecoder/docs/01_REPORT.pdf`](01_7SegmentDecoder/docs/01_REPORT.pdf) |
| 02 — Adders & Multiplier | [`02_Adders_Multiplier/docs/report_02.docx`](02_Adders_Multiplier/docs/report_02.docx) |
| 03 — Counters & Timers | [`03_Counters_Timers/docs/Report.pdf`](03_Counters_Timers/docs/Report.pdf) |
| 04 — FSM HELLO Display | [`04_FSM_HELLO_Display/docs/04.docx`](04_FSM_HELLO_Display/docs/04.docx) |

---

## 📝 License

This project is for **educational purposes**. Feel free to use and adapt the code for learning.

---

<p align="center">
  <em>Designed and implemented for the Digital Systems Electronics course (2024–2025).</em>
</p>
