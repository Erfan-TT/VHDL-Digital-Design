library ieee;
use ieee.std_logic_1164.all;

entity OneHot_FSMv2_tb is
end OneHot_FSMv2_tb;

architecture test of OneHot_FSMv2_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component OneHot_FSMv2
        port (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            w       : in  std_logic;
            z       : out std_logic
        );
    end component;

    -- Signals to connect to the UUT
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal w       : std_logic := '0';
    signal z       : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: OneHot_FSMv2
        port map (
            clk     => clk,
            reset_n => reset_n,
            w       => w,
            z       => z
        );

    -- Clock generation: 20ns period
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initial reset
        reset_n <= '0';
        wait for 20 ns;
        reset_n <= '1';

        -- Wait one cycle before applying input
        wait for 20 ns;

        -- Apply 4 consecutive 0s (should activate z at end)
        w <= '0'; wait for 40 ns;  -- 2 cycles
        w <= '0'; wait for 40 ns;  -- 2 more cycles → total 4

        -- Wait a bit
        wait for 40 ns;

        -- Apply 4 consecutive 1s (should activate z at end)
        w <= '1'; wait for 80 ns;

        -- Random pattern (no z expected)
        w <= '0'; wait for 20 ns;
        w <= '1'; wait for 20 ns;
        w <= '0'; wait for 20 ns;
        w <= '1'; wait for 20 ns;

        -- Another 0-0-0-0 to trigger output again
        w <= '0'; wait for 80 ns;

        -- End simulation
        wait;
    end process;

end test;
