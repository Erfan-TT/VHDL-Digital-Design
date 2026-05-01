library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparator is
  port (
    v : in  std_logic_vector(3 downto 0);
    z : out std_logic
  );
end comparator;

architecture behave of comparator is
begin
  process (v) 
  begin
    -- If v > "1001" (decimal 9), then z='1'
    if v > "1001" then
      z <= '1';
    else
      z <= '0';
    end if;
  end process;

end behave;
