

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity circuitA is
  port (
    v : in std_logic_vector(5 downto 0);  -- 6-bit binary input (0-63)
    tens : out std_logic_vector(3 downto 0);  -- Tens place
    ones : out std_logic_vector(3 downto 0)   -- Ones place
  );
end circuitA;

architecture behave of circuitA is
begin
  process (v)
    variable temp : std_logic_vector(5 downto 0);
    variable t, o : std_logic_vector(3 downto 0);
  begin
    temp := v;
    t := (others => '0');  -- Initialize tens to 0
    o := temp(3 downto 0); -- Initialize ones as lower 4 bits

    -- Subtract 10 repeatedly to get the tens digit
    if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 10
    if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 20
    if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 30
    if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 40
    if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 50
	 if temp >= "001010" then t := t + "0001"; temp := temp - "001010"; end if; -- 60

    -- Remaining value is the ones place
    o := temp(3 downto 0);

    tens <= t;
    ones <= o;
  end process;
end behave;
