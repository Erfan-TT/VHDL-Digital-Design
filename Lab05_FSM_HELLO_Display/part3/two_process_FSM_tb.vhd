LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity two_process_FSM_tb is 
end two_process_FSM_tb;

architecture mytest of two_process_FSM_tb is

    component two_process_FSM is
        port (
            SW   : in  std_logic_vector(9 downto 0);
            KEY  : in  std_logic_vector(3 downto 0);
            LEDR : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Signals for testbench
    signal clk       : std_logic := '0';
    signal reset_tb  : std_logic := '0';
    signal w_tb      : std_logic := '0';
    signal SW_tb     : std_logic_vector(9 downto 0);
    signal LEDR_tb   : std_logic_vector(9 downto 0);
    signal KEY_tb    : std_logic_vector(3 downto 0);

begin

    -- Combine reset and w into SW vector
    SW_tb <= "00000000" & w_tb & reset_tb;

    -- Assign KEY vector: bits 3?1 are '0', bit 0 is the clock
    KEY_tb <= "000" & clk;

    -- Clock generation process (20 ns period)
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Apply reset for 1 cycle
        reset_tb <= '0';  -- Active low
        wait for 20 ns;
        reset_tb <= '1';

        -- Wait one cycle after reset
        wait for 20 ns;

        -- Apply four 0s (should trigger z)
        w_tb <= '0'; wait for 80 ns;

        -- Apply four 1s (should trigger z)
        w_tb <= '1'; wait for 80 ns;

        -- Apply random pattern (no z expected)
        w_tb <= '0'; wait for 20 ns;
        w_tb <= '1'; wait for 20 ns;
        w_tb <= '0'; wait for 20 ns;
        w_tb <= '1'; wait for 20 ns;

        -- Apply another four 0s (should trigger z again)like previous parts
        w_tb <= '0'; wait for 80 ns;

        wait;
    end process;

    -- Instantiate the FSM
    uut: two_process_FSM 
        port map (
            SW   => SW_tb,
            KEY  => KEY_tb,
            LEDR => LEDR_tb
        );

end mytest;

