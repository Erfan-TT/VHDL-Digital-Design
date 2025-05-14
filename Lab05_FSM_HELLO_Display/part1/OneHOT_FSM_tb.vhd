library ieee;
use ieee.std_logic_1164.all;

entity tb_OneHot_FSM is
end tb_OneHot_FSM;

architecture behavior of tb_OneHot_FSM is
    -- Component declaration
    component OneHot_FSM
        port (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            w       : in  std_logic;
            z       : out std_logic
        );
    end component;

    -- Signals to connect to the FSM
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal w       : std_logic := '0';
    signal z       : std_logic;

begin
    -- Instantiate the FSM
    uut: OneHot_FSM
        port map (
            clk     => clk,
            reset_n => reset_n,
            w       => w,
            z       => z
        );

    -- Clock generation (20 ns period)
    clk_process: process
    begin
        while now < 500 ns loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process matching the lab waveform
    stim_proc: process
    begin
        -- Initial reset
        reset_n <= '0';
        wait for 20 ns;  -- Reset for 1 clock cycle
        reset_n <= '1';

        -- w = 0 for 4 clocks
        w <= '0'; wait for 80 ns;

        -- w = 1 for 4 clocks
        w <= '1'; wait for 80 ns;

        -- w = 0 for 4 clocks
        w <= '0'; wait for 80 ns;

        -- Continue with high or leave constant for clean ending
        w <= '1'; wait;
    end process;

end behavior;

