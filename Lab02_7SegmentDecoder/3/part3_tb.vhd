library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part3_tb is
end part3_tb;

architecture behavior of part3_tb is
    component bin2dec
        port (
            v    : in  std_logic_vector(3 downto 0);  -- 4-bit binary input
            HEX1 : out std_logic_vector(0 to 6);         -- 7-seg display for tens
            HEX0 : out std_logic_vector(0 to 6)          -- 7-seg display for ones
        );
    end component;

    signal v    : std_logic_vector(3 downto 0);
    signal HEX0, HEX1 : std_logic_vector(0 to 6);  

begin
    uut: bin2dec port map (
        v    => v,
        HEX0 => HEX0,
        HEX1 => HEX1
    );

    process
    begin
        v <= "0000";
        wait for 100 ns;
        v <= "0001";
        wait for 100 ns;
        v <= "0010";
        wait for 100 ns;
        v <= "0011";
        wait for 100 ns;
        v <= "0100";
        wait for 100 ns;
        v <= "0111";
        wait for 100 ns;
        v <= "1011";
        wait for 100 ns;
        v <= "1111";
        wait;
    end process;
end behavior;

