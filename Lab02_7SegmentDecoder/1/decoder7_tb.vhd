LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY decoder7_tb IS
END decoder7_tb;

ARCHITECTURE testbench OF decoder7_tb IS
    SIGNAL C : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL HEX0 : STD_LOGIC_VECTOR(0 TO 6);

    COMPONENT decoder7
        PORT (
            C : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
        );
    END COMPONENT;

BEGIN
    UUT: decoder7 PORT MAP (C, HEX0);
    
    PROCESS
    BEGIN
        -- Test all input combinations
        C <= "000"; WAIT FOR 10 ns;
        C <= "001"; WAIT FOR 10 ns;
        C <= "010"; WAIT FOR 10 ns;
        C <= "011"; WAIT FOR 10 ns;
        C <= "100"; WAIT FOR 10 ns;
        C <= "101"; WAIT FOR 10 ns;
        C <= "110"; WAIT FOR 10 ns;
        C <= "111"; WAIT FOR 10 ns;
        
        -- End simulation
        WAIT;
    END PROCESS;
END testbench;