LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reaction_tb IS
END reaction_tb;

ARCHITECTURE behavior OF reaction_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT reaction
        PORT (
            CLOCK_50 : IN  std_logic;
            KEY0     : IN  std_logic;
            KEY3     : IN  std_logic;
            SW       : IN  std_logic_vector(7 DOWNTO 0);
            HEX0, HEX1, HEX2, HEX3 : OUT std_logic_vector(6 DOWNTO 0);
            LED      : OUT std_logic
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL CLOCK_50_tb : std_logic := '0';
    SIGNAL KEY0_tb     : std_logic := '1';
    SIGNAL KEY3_tb     : std_logic := '1';
    SIGNAL SW_tb       : std_logic_vector(7 DOWNTO 0) := (others => '0');
    SIGNAL HEX0_tb, HEX1_tb, HEX2_tb, HEX3_tb : std_logic_vector(6 DOWNTO 0);
    SIGNAL LED_tb      : std_logic;

    -- Clock period (50 MHz)
    CONSTANT clk_period : time := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: reaction
        PORT MAP (
            CLOCK_50 => CLOCK_50_tb,
            KEY0     => KEY0_tb,
            KEY3     => KEY3_tb,
            SW       => SW_tb,
            HEX0     => HEX0_tb,
            HEX1     => HEX1_tb,
            HEX2     => HEX2_tb,
            HEX3     => HEX3_tb,
            LED      => LED_tb
        );

    -- Clock generation process
    clk_process : PROCESS
BEGIN
    CLOCK_50_tb <= '0';
    WAIT FOR 10 ns;
    CLOCK_50_tb <= '1';
    WAIT FOR 10 ns;
END PROCESS;


    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Apply reset
        KEY0_tb <= '0';  -- Active-low reset
        WAIT FOR 200 ns;
        KEY0_tb <= '1';  -- Release reset

        -- Set a short wait time (e.g., 3 ms)
        SW_tb <= "00000011";  -- 3 milliseconds

        -- Let system run through waiting period
        WAIT FOR 8 ms;

        -- Simulate user pressing KEY3 (stop)
        KEY3_tb <= '0';  -- Active-low press
        WAIT FOR 500 ns;
        KEY3_tb <= '1';  -- Release KEY3

        -- Allow time to observe result
        WAIT FOR 2 ms;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;

