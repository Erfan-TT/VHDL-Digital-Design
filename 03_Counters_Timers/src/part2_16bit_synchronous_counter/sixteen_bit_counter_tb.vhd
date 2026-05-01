-- File: tb_sixteen_bit_counter.vhd
-- Test bench for the 16-bit synchronous counter that uses T flip-flops.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sixteen_bit_counter is
end entity;

architecture testbench of tb_sixteen_bit_counter is

    -- Test bench constants and signals
    constant CLK_PERIOD : time := 20 ns;

    signal SW        : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY       : std_logic_vector(3 downto 0) := (others => '0');
    signal HEX0      : std_logic_vector(6 downto 0);
    signal HEX1      : std_logic_vector(6 downto 0);
    signal HEX2      : std_logic_vector(6 downto 0);
    signal HEX3      : std_logic_vector(6 downto 0);
    signal count_out : std_logic_vector(15 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.sixteen_bit_counter
        port map (
            SW        => SW,
            KEY       => KEY,
            HEX0      => HEX0,
            HEX1      => HEX1,
            HEX2      => HEX2,
            HEX3      => HEX3,
            count_out => count_out
        );

    -- Clock Generation
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
    stim_proc: process
    begin
        -- Initial reset and disable
        SW(0) <= '0';  -- Reset active (low)
        SW(1) <= '0';  -- Enable off
        wait for 2 * CLK_PERIOD;

        -- Deassert reset
        SW(0) <= '1';
        wait for CLK_PERIOD;

        -- Enable counting
        SW(1) <= '1';
        wait for 10 * CLK_PERIOD;

        -- Disable counting
        SW(1) <= '0';
        wait for 5 * CLK_PERIOD;

        -- Enable again
        SW(1) <= '1';
        wait for 10 * CLK_PERIOD;

        -- End simulation
        wait for 200 ns;
        assert false report "Simulation finished successfully." severity failure;
    end process stim_proc;

end architecture testbench;
