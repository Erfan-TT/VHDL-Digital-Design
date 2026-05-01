library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sixteen_bit_counterv2_tb is
end entity sixteen_bit_counterv2_tb;

architecture test of sixteen_bit_counterv2_tb is

    -- Test Bench Constants
    constant CLK_PERIOD : time := 20 ns;  -- Adjust as needed for your simulation

    -- Signals to connect to the DUT
    signal SW        : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY       : std_logic_vector(3 downto 0) := (others => '0');
    signal HEX0      : std_logic_vector(6 downto 0);
    signal HEX1      : std_logic_vector(6 downto 0);
    signal HEX2      : std_logic_vector(6 downto 0);
    signal HEX3      : std_logic_vector(6 downto 0);
    signal count_out : std_logic_vector(15 downto 0);

begin

    -- Instantiate the DUT (Design Under Test)
    UUT: entity work.sixteen_bit_counterv2

        port map (
            SW        => SW,
            KEY       => KEY,
            HEX0      => HEX0,
            HEX1      => HEX1,
            HEX2      => HEX2,
            HEX3      => HEX3,
            count_out => count_out
        );

    -- Clock Generation Process
    -- KEY(0) is toggled every half period
    clock_gen: process
    begin
        while true loop
            KEY(0) <= '0';
            wait for CLK_PERIOD / 2;
            KEY(0) <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clock_gen;

    -- Stimulus Process
    -- Applies reset (active low) and toggles enable
    stim_proc: process
    begin
        -- Initially: apply reset (SW(0)='0') and disable counting (SW(1)='0')
        SW(0) <= '0';   -- Reset asserted (active-low)
        SW(1) <= '0';   -- Enable = 0
        wait for 3 * CLK_PERIOD;

        -- Release reset (SW(0)='1')
        SW(0) <= '1';  
        wait for 3 * CLK_PERIOD;

        -- Enable counting (SW(1)='1')
        SW(1) <= '1';
        wait for 10 * CLK_PERIOD;

        -- Disable counting
        SW(1) <= '0';
        wait for 5 * CLK_PERIOD;

        -- Re-enable counting
        SW(1) <= '1';
        wait for 10 * CLK_PERIOD;

        -- Finish simulation
        wait for 200 ns;
        assert false report "Simulation complete." severity failure;
    end process stim_proc;

end architecture test;
