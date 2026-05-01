LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity declaration for a 4-bit register with reset
ENTITY regn IS
    PORT (
        R      : IN  std_logic_vector(3 DOWNTO 0);  -- 4-bit input
        Clock  : IN  STD_LOGIC;                      -- Clock signal
        Resetn : IN  STD_LOGIC;                      -- Active-low reset signal
        Q      : OUT std_logic_vector(3 DOWNTO 0)    -- 4-bit output
    );
END regn;

-- Architecture definition for the register
ARCHITECTURE Behavior OF regn IS
BEGIN
    -- Process to handle the register behavior
    PROCESS (Clock, Resetn)
    BEGIN
        -- If reset is active (low), clear the output to 0
        IF Resetn = '0' THEN
            Q <= (OTHERS => '0');  -- Set all bits of Q to '0'
        
        -- On the rising edge of the clock, update the output with the input
        ELSIF rising_edge(Clock) THEN
            Q <= R;  -- Assign the input R to the output Q
        END IF;
    END PROCESS;
END Behavior;