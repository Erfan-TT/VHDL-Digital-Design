LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Tflip_flop IS
    PORT (
        clk    : IN  std_logic;  -- Clock input
        clear  : IN  std_logic;  -- Active-low asynchronous clear
        toggle : IN  std_logic;  -- Toggle control
        q_out  : OUT std_logic   -- Output
    );
END Tflip_flop;

ARCHITECTURE behavior OF Tflip_flop IS
    SIGNAL q_temp : std_logic := '0';  -- Internal state
BEGIN
    PROCESS (clk, clear)
    BEGIN
        IF clear = '1' THEN
            q_temp <= '0';  -- Asynchronous clear
        ELSIF rising_edge(clk) THEN
            q_temp <= toggle XOR q_temp;  -- Toggle behavior
        END IF;
    END PROCESS;

    q_out <= q_temp;
END behavior;
