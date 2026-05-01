LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder7 IS
    PORT (
        C : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        Display : OUT STD_LOGIC_VECTOR(0 to 6)
    );
END decoder7;

ARCHITECTURE Behavior OF decoder7 IS
BEGIN
    PROCESS(C)
    BEGIN
        CASE C IS
            WHEN "0000" => Display <= "0000001"; -- 0
            WHEN "0001" => Display <= "1001111"; -- 1
            WHEN "0010" => Display <= "0010010"; -- 2
            WHEN "0011" => Display <= "0000110"; -- 3
            WHEN "0100" => Display <= "1001100"; -- 4
            WHEN "0101" => Display <= "0100100"; -- 5
            WHEN "0110" => Display <= "0100000"; -- 6
            WHEN "0111" => Display <= "0001111"; -- 7
            WHEN "1000" => Display <= "0000000"; -- 8
            WHEN "1001" => Display <= "0000100"; -- 9
            WHEN OTHERS => Display <= "1111111"; -- Blank
        END CASE;
    END PROCESS;
END Behavior;
