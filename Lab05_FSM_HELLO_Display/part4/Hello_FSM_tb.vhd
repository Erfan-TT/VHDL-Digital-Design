LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hello_FSM_tb IS
END hello_FSM_tb;

ARCHITECTURE mytest OF hello_FSM_tb IS 

    -- DUT component declaration
    COMPONENT hello_FSM IS
        PORT (
            KEY      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            CLOCK_50 : IN  STD_LOGIC;
            HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX3     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX4     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            HEX5     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for testbench
    SIGNAL clk      : STD_LOGIC := '0';
    SIGNAL KEY_tb   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";  -- All unpressed (reset inactive)
    SIGNAL HEX0_tb, HEX1_tb, HEX2_tb, HEX3_tb, HEX4_tb, HEX5_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 20 ns;  -- 50 MHz clock

BEGIN

    -- Instantiate the Device Under Test (DUT)
    uut: hello_FSM
        PORT MAP (
            KEY      => KEY_tb,
            CLOCK_50 => clk,
            HEX0     => HEX0_tb,
            HEX1     => HEX1_tb,
            HEX2     => HEX2_tb,
            HEX3     => HEX3_tb,
            HEX4     => HEX4_tb,
            HEX5     => HEX5_tb
        );

    -- Clock generation process
    clk_process: PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR CLK_PERIOD / 2;
            clk <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Apply active-low reset (KEY(0) = '0')
        KEY_tb(0) <= '0';
        WAIT FOR 100 ns;

        -- Deassert reset (KEY(0) = '1')
        KEY_tb(0) <= '1';

        -- Let simulation run for a while to observe output changes
        WAIT FOR 10 us;

        -- Optional: apply another reset
        KEY_tb(0) <= '0';
        WAIT FOR 100 ns;
        KEY_tb(0) <= '1';

        WAIT; -- stop simulation
    END PROCESS;

END ARCHITECTURE mytest;

