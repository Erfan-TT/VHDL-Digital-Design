LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity declaration for a D Flip-Flop with asynchronous reset
ENTITY flipflop IS
    PORT (
        D      : IN  STD_LOGIC;   -- Data input
        Clock  : IN  STD_LOGIC;   -- Clock signal
        Resetn : IN  STD_LOGIC;   -- Active-low asynchronous reset
        Q      : OUT STD_LOGIC    -- Output
    );
END flipflop;

-- Architecture definition for the D Flip-Flop
ARCHITECTURE Behavior OF flipflop IS
BEGIN
    -- Process to handle the flip-flop behavior
    PROCESS (Clock, Resetn)
    BEGIN
        -- Asynchronous reset (active low)
        IF Resetn = '0' THEN
            Q <= '0';  -- Clear the output to '0' when reset is active
        
        -- On the rising edge of the clock, update the output with the input
        ELSIF rising_edge(Clock) THEN
            Q <= D;  -- Assign the input D to the output Q
        END IF;
    END PROCESS;
END Behavior;