library ieee;
use ieee.std_logic_1164.all;

entity circuitB is
  port (
    z : in  std_logic;
    d1 : out std_logic_vector(0 to 6)
  );
end circuitB;

architecture behave of circuitB is
begin
  process (z)  
  begin 
    if (z = '1') then  
      d1 <= "1111001";
    else
      d1 <= "0000001";
    end if;  
  end process;
end behave;
