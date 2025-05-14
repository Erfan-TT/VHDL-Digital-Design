LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LED_Switch_tb IS
END LED_Switch_tb;

ARCHITECTURE test OF LED_Switch_tb IS
    -- Declare signals to connect with DUT (Device Under Test)
    SIGNAL SW  : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL LEDR: STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Component declaration
    COMPONENT LED_switch_control
        PORT(
            SW  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            LEDR: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;
    
BEGIN
    -- Connect signals to the component
    DUT: LED_switch_control PORT MAP (SW => SW, LEDR => LEDR);

    -- Test process
    PROCESS
    BEGIN
        -- Test Case 1: All switches off
        SW <= "0000000000";
        WAIT FOR 10 ns;
        
        -- Test Case 2: SW[0] ON
        SW <= "0000000001";
        WAIT FOR 10 ns;

        -- Test Case 3: SW[9:0] Alternating pattern
        SW <= "1010101010";
        WAIT FOR 10 ns;

        -- Test Case 4: All switches ON
        SW <= "1111111111";
        WAIT FOR 10 ns;

        -- End simulation
        WAIT;
    END PROCESS;
END test;
