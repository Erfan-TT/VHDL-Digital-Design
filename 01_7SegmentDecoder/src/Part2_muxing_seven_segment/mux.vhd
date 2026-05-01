LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux IS
PORT ( sel: IN STD_LOGIC_VECTOR(1 downto 0);
output : OUT STD_LOGIC_VECTOR(14 downto 0));
END mux;
ARCHITECTURE Behavior OF mux IS
BEGIN
    PROCESS (sel)
    BEGIN
        CASE sel IS
            WHEN "00" => output <= "000001010010011"; -- HELLO
            WHEN "01" => output <= "100001101101011"; -- CEPPO 
            WHEN "10" => output <= "100001010010011"; -- CELLO
            WHEN "11" => output <= "110001101101011"; -- FEPPO
        END CASE;
    END PROCESS;
END Behavior;