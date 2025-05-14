library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bypass is
end entity;

architecture behavior of tb_bypass is

    -- DUT component declaration
    component bypass
        port (
            ain      : in  std_logic_vector(15 downto 0);
            bin      : in  std_logic_vector(15 downto 0);
            cin      : in  std_logic;
            Clock    : in  std_logic;
            Resetn   : in  std_logic;
            sout     : out std_logic_vector(15 downto 0);
            overflow : out std_logic
        );
    end component;

    -- Signals to connect to DUT
    signal ain, bin, sout : std_logic_vector(15 downto 0) := (others => '0');
    signal cin            : std_logic := '0';
    signal clk, resetn    : std_logic := '0';
    signal overflow       : std_logic;

begin

    -- Instantiate DUT
    uut: bypass
        port map (
            ain      => ain,
            bin      => bin,
            cin      => cin,
            Clock    => clk,
            Resetn   => resetn,
            sout     => sout,
            overflow => overflow
        );

    -- Clock generation: 10 ns period
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset low
        resetn <= '0';
        wait for 20 ns;
        resetn <= '1';

        -- Test 1: 1000 + 1000 = 2000
        ain <= "0000011111010000"; -- 1000
        bin <= "0000011111010000"; -- 1000
        cin <= '0';
        wait for 20 ns;

        -- Test 2: -15000 + -1000 ? overflow
        ain <= "1100100111001000"; -- -15000
        bin <= "1111110001111000"; -- -1000
        wait for 20 ns;

        -- Test 3: 32767 + 1 ? overflow
        ain <= "0111111111111111"; -- 32767
        bin <= "0000000000000001"; -- +1
        wait for 20 ns;

        -- Test 4: -32768 + -1 ? overflow
        ain <= "1000000000000000"; -- -32768
        bin <= "1111111111111111"; -- -1
        wait for 20 ns;

        -- Test 5: 200 - 150 = 50
        ain <= "0000000011001000"; -- +200
        bin <= "1111111100111010"; -- -150
        wait for 20 ns;

        wait;
    end process;

end behavior;

