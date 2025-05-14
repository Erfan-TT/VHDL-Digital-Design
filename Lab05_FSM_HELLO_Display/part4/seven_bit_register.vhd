library ieee;
use ieee.std_logic_1164.all;

entity seven_bit_register is
    port (
        R      : in  std_logic_vector(6 downto 0);
        reset  : in  std_logic;
        clk    : in  std_logic;
        enable : in  std_logic;
        Q      : out std_logic_vector(6 downto 0)
    );
end seven_bit_register;

architecture behavior of seven_bit_register is
    signal reg : std_logic_vector(6 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reg <= (others => '0');
            elsif enable = '1' then
                reg <= R;
            end if;
        end if;
    end process;

    Q <= reg;
end behavior;
