library ieee;
use ieee.std_logic_1164.all;

entity bin2bcd is
  port (
    v  : in  std_logic_vector(5 downto 0); -- 6-bit binary input
    HEX1 : out std_logic_vector(0 to 6); -- Tens place
    HEX0 : out std_logic_vector(0 to 6)  -- Ones place
  );
end bin2bcd;

architecture structural of bin2bcd is


  -- Internal signals
  signal m0, m1 : std_logic_vector(3 downto 0);

  
  
  -- Components
  component circuitA is
    port (
      v : in std_logic_vector(5 downto 0);
      tens : out std_logic_vector(3 downto 0);
      ones : out std_logic_vector(3 downto 0)
    );
  end component;

  component decoder7 is
    port (
      C       : in std_logic_vector(3 downto 0);
      Display : out std_logic_vector(0 to 6)
    );
  end component;

begin
  -- Convert binary to BCD (Tens and Ones)
  u_circuitA: circuitA port map (v => v, tens => m0, ones => m1);

  -- Display the digits on 7-segment displays
  dec1: decoder7 port map (C => m0, Display => HEX1);
  dec0: decoder7 port map (C => m1, Display => HEX0);

end structural;
