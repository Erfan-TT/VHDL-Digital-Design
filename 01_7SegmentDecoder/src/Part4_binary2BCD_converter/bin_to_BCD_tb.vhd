LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bin_to_BCD_tb IS
END bin_to_BCD_tb;

ARCHITECTURE test OF bin_to_BCD_tb IS

    -- Component under test
    COMPONENT bin2bcd
        PORT (
            v    : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
            HEX1 : OUT STD_LOGIC_VECTOR(0 TO 6);  -- Tens place
            HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)   -- Ones place
        );
    END COMPONENT;

    -- Signals for simulation
    SIGNAL v    : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL HEX1 : STD_LOGIC_VECTOR(0 TO 6);
    SIGNAL HEX0 : STD_LOGIC_VECTOR(0 TO 6);

BEGIN

    -- Instantiate the binary-to-BCD converter
    uut: bin2bcd PORT MAP (v => v, HEX1 => HEX1, HEX0 => HEX0);

    -- Stimulus process
    PROCESS
    BEGIN
        -- Test Case 1: Binary 0 (000000) -> BCD (0, 0)
        v <= "000000"; WAIT FOR 100 ns;
        
        -- Test Case 2: Binary 5 (000101) -> BCD (0, 5)
        v <= "000101"; WAIT FOR 100 ns;
        
        -- Test Case 3: Binary 10 (001010) -> BCD (1, 0)
        v <= "001010"; WAIT FOR 100 ns;
        
        -- Test Case 4: Binary 15 (001111) -> BCD (1, 5)
        v <= "001111"; WAIT FOR 100 ns;
        
        -- Test Case 5: Binary 19 (010011) -> BCD (1, 9)
        v <= "010011"; WAIT FOR 100 ns;
        
        -- Test Case 6: Binary 20 (010100) -> BCD (2, 0)
        v <= "010100"; WAIT FOR 100 ns;
        
        -- Test Case 7: Binary 35 (100011) -> BCD (3, 5)
        v <= "100011"; WAIT FOR 100 ns;
        
        -- Test Case 8: Binary 51 (110011) -> BCD (5, 1)
        v <= "110011"; WAIT FOR 100 ns;
        
        -- End simulation
        WAIT;
    END PROCESS;

END test;
