LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY LED_switch_control IS
    PORT ( 
        SW  : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Switches (inputs)
        LEDR: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)  -- LEDs (outputs)
    );
END LED_switch_control;

ARCHITECTURE Behavior OF LED_Switch_control IS
BEGIN
    LEDR <= SW;  -- Directly map switches to LEDs
END Behavior;
