LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2to1 IS
    PORT (
        S   : IN  STD_LOGIC;                      -- 1-bit select input
        X   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- 4-bit input X (SW[3:0])
        Y   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- 4-bit input Y (SW[7:4])
        M   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)    -- 4-bit output M (LEDR[3:0])
    );
END mux2to1;

ARCHITECTURE Behavior OF mux2to1 IS
BEGIN
    -- Multiplexer logic using concurrent assignments
    M(0) <= (NOT S AND X(0)) OR (S AND Y(0));
    M(1) <= (NOT S AND X(1)) OR (S AND Y(1));
    M(2) <= (NOT S AND X(2)) OR (S AND Y(2));
    M(3) <= (NOT S AND X(3)) OR (S AND Y(3));
END Behavior;
