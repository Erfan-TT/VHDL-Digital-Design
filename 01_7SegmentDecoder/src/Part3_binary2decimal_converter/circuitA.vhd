library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity circuitA is
  port (
    v : in  std_logic_vector(2 downto 0);
    m : out std_logic_vector(2 downto 0)
  );
end circuitA;

architecture behave of circuitA is
begin
  -- Subtract 2 "010" from the three bits
  m <= v - "010";
end behave;
