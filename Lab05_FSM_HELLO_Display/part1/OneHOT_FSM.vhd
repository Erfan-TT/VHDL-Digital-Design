library ieee;
use ieee.std_logic_1164.all;

entity OneHot_FSM is
    port (
        clk     : in  std_logic;   -- KEY0
        reset_n : in  std_logic;   -- SW0 (active low)
        w       : in  std_logic;   -- SW1
        z       : out std_logic    -- LEDR0
    );
end OneHot_FSM;

architecture Behavioral of OneHot_FSM is
    signal y : std_logic_vector(8 downto 0) := (0 => '1', others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                y <= (0 => '1', others => '0');  -- Reset to state A
            else
                -- Next state logic
                y(0) <= (not w) and (y(0) or y(1) or y(2) or y(3) or y(4) or 
                                y(5) or y(6) or y(7) or y(8));
                y(1) <= w and y(0);
                y(2) <= w and y(1);
                y(3) <= w and y(2);
                y(4) <= w and y(3);
                y(5) <= (not w) and y(0);
                y(6) <= (not w) and y(5);
                y(7) <= (not w) and y(6);
                y(8) <= (not w) and y(7);
            end if;
        end if;
    end process;
    
    z <= y(4) or y(8);  -- Output logic
end Behavioral;
