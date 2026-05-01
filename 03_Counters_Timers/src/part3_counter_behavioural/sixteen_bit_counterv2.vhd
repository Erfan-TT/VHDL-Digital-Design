-- Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity
entity sixteen_bit_counterv2 is
    port (
        SW        : in  std_logic_vector(1 downto 0);   -- SW(0)=reset (active-low), SW(1)=enable
        KEY       : in  std_logic;   -- KEY(0)=clock
        HEX0, 
        HEX1, 
        HEX2, 
        HEX3      : out std_logic_vector(6 downto 0);   -- 7-segment displays
        count_out : out std_logic_vector(15 downto 0)   -- 16-bit counter output
    );
end sixteen_bit_counterv2;

-- Architecture (Behavioral)
architecture behavioral of sixteen_bit_counterv2 is

    -- Use unsigned for arithmetic
    signal Q : unsigned(15 downto 0) := (others => '0');

	 component seven_seg_dec is
	     PORT (
        s   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 4-bit input
        hex : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- 7-segment output
    );
	 end component;
	 
	 
begin

    -- Synchronous Process
    process (KEY, SW(0))
    begin
        -- Active-low reset
        if (SW(0) = '0') then
            Q <= (others => '0');
        elsif rising_edge(KEY) then
            if SW(1) = '1' then
                Q <= Q + 1;
            end if;
        end if;
    end process;

    -- Output assignment
    count_out <= std_logic_vector(Q);

    -- 7-Segment Decoders (correct port names for "seven_seg_dec")
    seg0: entity seven_seg_dec
        port map (
            s   => std_logic_vector(Q(3 downto 0)),
            hex => HEX0
        );

    seg1: entity seven_seg_dec
        port map (
            s   => std_logic_vector(Q(7 downto 4)),
            hex => HEX1
        );

    seg2: entity seven_seg_dec
        port map (
            s   => std_logic_vector(Q(11 downto 8)),
            hex => HEX2
        );

    seg3: entity seven_seg_dec
        port map (
            s   => std_logic_vector(Q(15 downto 12)),
            hex => HEX3
        );

end behavioral;
