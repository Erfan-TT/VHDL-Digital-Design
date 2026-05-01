LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY multiplier_tb IS
END multiplier_tb;

ARCHITECTURE behavior OF multiplier_tb IS
    -- Input signals to the multiplier (SW3–0 for A, SW7–4 for B)
    SIGNAL SW     : std_logic_vector(7 DOWNTO 0);

    -- KEY(0): active-low reset, KEY(1): clock
    SIGNAL KEY    : std_logic_vector(1 DOWNTO 0);

    -- Outputs for the 7-segment displays (not used in testbench validation)
    SIGNAL HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : STD_LOGIC_VECTOR(6 DOWNTO 0);

    -- Output product of the multiplication
    SIGNAL output : std_logic_vector(7 DOWNTO 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: ENTITY work.multiplier
        PORT MAP (
            SW     => SW,
            KEY    => KEY,
            HEX0   => HEX0,
            HEX1   => HEX1,
            HEX2   => HEX2,
            HEX3   => HEX3,
            HEX4   => HEX4,
            HEX5   => HEX5,
            output => output
        );

    -- Test process
    PROCESS
    BEGIN
        
        -- Test Case 1: A = 5, B = 3 → 5 × 3 = 15
        SW <= "00110101"; -- B = 0011 (3), A = 0101 (5)
        KEY <= "01"; WAIT FOR 10 ns; -- Apply reset
        KEY <= "11"; WAIT FOR 20 ns; -- Apply clock pulse

        
        -- Test Case 2: A = 10, B = 4 → 10 × 4 = 40
        SW <= "01001010"; -- B = 0100 (4), A = 1010 (10)
        KEY <= "01"; WAIT FOR 10 ns; -- Reset
        KEY <= "11"; WAIT FOR 20 ns; -- Clock

        
        -- Test Case 3: A = 15, B = 15 → 15 × 15 = 225
        SW <= "11111111"; -- B = 1111 (15), A = 1111 (15)
        KEY <= "01"; WAIT FOR 10 ns;
        KEY <= "11"; WAIT FOR 20 ns;

       
        -- Test Case 4: A = 7, B = 8 → 7 × 8 = 56
        SW <= "10000111"; -- B = 1000 (8), A = 0111 (7)
        KEY <= "01"; WAIT FOR 10 ns;
        KEY <= "11"; WAIT FOR 20 ns;

        -- End of test sequence
        WAIT;
    END PROCESS;
END behavior;
