LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shifter IS
    PORT (
        input : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
    );
END shifter;

ARCHITECTURE Behavior OF shifter IS
BEGIN
    PROCESS (input, sel)
    BEGIN
        CASE sel IS
            WHEN "000" => output <= input;
            WHEN "001" => output <= input(11 DOWNTO 0) & input(14 DOWNTO 12);
            WHEN "010" => output <= input(8 DOWNTO 0) & input(14 DOWNTO 9);
            WHEN "011" => output <= input(5 DOWNTO 0) & input(14 DOWNTO 6);
            WHEN "100" => output <= input(2 DOWNTO 0) & input(14 DOWNTO 3);
            WHEN OTHERS => output <= input;
        END CASE;
    END PROCESS;
END Behavior;
