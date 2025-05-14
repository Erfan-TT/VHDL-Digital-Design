library ieee;
use ieee.std_logic_1164.all;

entity OneHot_FSMv2 is
    port (
        clk     : in  std_logic;   -- KEY0 (clock)
        reset_n : in  std_logic;   -- SW0 (active-low synchronous reset)
        w       : in  std_logic;   -- SW1 (input)
        z       : out std_logic    -- LEDR0 (output)
    );
end OneHot_FSMv2;

architecture modified_onehot of OneHot_FSMv2 is
    signal y : std_logic_vector(8 downto 0) := (others => '0');  -- y8..y0
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                y <= (others => '0');  -- Reset to state A (all 0s)
            else
                y <= (others => '0');  -- Clear previous state (simulate one-hot)

                if y = "000000000" then
                    -- FSM is in reset state (A), start new sequence
                    if w = '1' then
                        y(1) <= '1';  -- A → B
                    else
                        y(5) <= '1';  -- A → F
                    end if;
                else
                    -- FSM is active, proceed with transitions
                    y(1) <= w and y(0);         -- A → B
                    y(2) <= w and y(1);         -- B → C
                    y(3) <= w and y(2);         -- C → D
                    y(4) <= w and y(3);         -- D → E (z = 1)

                    y(5) <= (not w) and y(0);   -- A → F
                    y(6) <= (not w) and y(5);   -- F → G
                    y(7) <= (not w) and y(6);   -- G → H
                    y(8) <= (not w) and y(7);   -- H → I (z = 1)
                end if;
            end if;
        end if;
    end process;

    -- Output is 1 in state E or I (detected 4 consecutive 1s or 0s)
    z <= y(4) or y(8);
end modified_onehot;
