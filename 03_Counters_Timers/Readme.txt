========================================================================
Project: Sequential Digital Circuits in VHDL (Counters & Timers)
Target Platform: DE1-SoC FPGA Board
Language: VHDL
========================================================================

Description:
------------
This project contains a series of sequential digital logic designs implemented in VHDL. It demonstrates progression from basic gate-level latches to complex, finite-state machine (FSM) controlled timing systems. The designs explore both structural and behavioral modeling styles, component reusability, clock division, and interfacing with real hardware (switches, push-buttons, LEDs, and seven-segment displays) on the DE1-SoC development board.

Directory Structure:
--------------------
The source code is organized into five parts within the `src/` directory:

* src/part1_SR_LAtch/
  A structural implementation of a gated SR latch using fundamental logic gates. Includes a testbench verifying set, reset, hold, and invalid states.

* src/part2_16bit_synchronous_counter/
  A structural 16-bit synchronous counter built by cascading custom T flip-flop components. Includes synchronous carry-chain logic and a seven-segment decoder for output display.

* src/part3_counter_behavioural/
  A behavioral version of the 16-bit synchronous counter. This version leverages VHDL arithmetic operators and a single synchronous process, relying on the synthesis tool to infer the necessary hardware.

* src/part4_flashing_digits/
  A digit flasher that counts from 0 to 9 and repeats. It demonstrates clock division by taking the board's 50 MHz clock and dividing it down to generate a 1 Hz tick for the modulo-10 counter.

* src/Part5_Reaction_Timer
  A complete reaction timer system using an FSM. It waits for a user-defined delay, lights an LED, measures the user's reaction time in milliseconds using a 1 kHz tick generator, and displays the final elapsed time on seven-segment displays via a binary-to-BCD (Double Dabble) converter.

Simulation and Verification:
----------------------------
Each module has been simulated using ModelSim. Testbenches are provided to verify the functional correctness of the designs before synthesis in Quartus Prime.

Hardware Interface (General DE1-SoC):
-------------------------------------
* KEY(0): Clock input or Reset (active-low)
* KEY(3): Stop button (for the reaction timer)
* SW: Configuration switches (enables, resets, or delay values)
* HEX0 - HEX3: Seven-segment displays for visual output
* LEDR: Status indicators
