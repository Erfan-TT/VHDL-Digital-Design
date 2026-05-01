LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_flashing IS
END tb_flashing;

ARCHITECTURE behavior OF tb_flashing IS

    -- Component Declaration
    COMPONENT Flashing
        PORT (
            CLOCK_50 : IN  std_logic;
            SW       : IN  std_logic_vector(1 DOWNTO 0);
            HEX0     : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for testbench
    SIGNAL CLOCK_50_tb : std_logic := '0';
    SIGNAL SW_tb       : std_logic_vector(1 DOWNTO 0) := (others => '0');
    SIGNAL HEX0_tb     : std_logic_vector(6 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Flashing
        PORT MAP (
            CLOCK_50 => CLOCK_50_tb,
            SW       => SW_tb,
            HEX0     => HEX0_tb
        );

    -- Simple Clock Generation (50 MHz)
    Clock_process : PROCESS
    BEGIN
        CLOCK_50_tb <= '0';
        WAIT FOR 10 ns;
        CLOCK_50_tb <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Stimulus Process
    stim_proc: PROCESS
    BEGIN
        -- Start with Reset and Enable Low
        SW_tb(0) <= '1';  -- Reset active
        SW_tb(1) <= '0';  -- Disable
        WAIT FOR 100 ns;

        -- Release Reset and Enable Counting
        SW_tb(0) <= '0';  -- Reset inactive
        SW_tb(1) <= '1';  -- Enable
        WAIT FOR 20 us;   -- Run for 20 microseconds to see digits 0?9 and reset

        -- Optional: Stop simulation
        WAIT;
    END PROCESS;

END behavior;

