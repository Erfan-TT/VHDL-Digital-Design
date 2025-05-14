library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_hz_counter is
    port (
        Enable : in  std_logic;  -- enables counting
        clk    : in  std_logic;  -- 50 MHz clock
        Clear  : in  std_logic;  -- active-high synchronous reset
        TC     : out std_logic   -- terminal count (1 Hz pulse, held high for 1 sec)
    );
end one_hz_counter;

architecture behavior of one_hz_counter is
    -- Shrink bit width for fast simulation
    signal count : unsigned(3 downto 0) := (others => '0');  -- 4-bit counter: can count up to 15
    signal pulse : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if Clear = '1' then
                count <= (others => '0');
                pulse <= '0';
            elsif Enable = '1' then
                if count = 9 then  -- FASTER simulation pulse (instead of 49999999)
                    count <= (others => '0');
                    pulse <= '1';
                else
                    count <= count + 1;
                    pulse <= '0';
                end if;
            else
                pulse <= '0';  -- hold low if not enabled
            end if;
        end if;
    end process;

    TC <= pulse;

end behavior;
