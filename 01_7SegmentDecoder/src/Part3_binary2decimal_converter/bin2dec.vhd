library ieee;
use ieee.std_logic_1164.all;

entity bin2dec is
  port (
    v  : in  std_logic_vector(3 downto 0); -- 4-bit binary input
    HEX1 : out std_logic_vector(0 to 6); -- 7-seg display for ten
    HEX0 : out std_logic_vector(0 to 6)  -- 7-seg display for ones
  );
end bin2dec;

architecture structural of bin2dec is

  -- Internal signals
  signal z : std_logic;
  signal m : std_logic_vector(3 downto 0);
  signal n : std_logic_vector(2 downto 0);

  --  components
  component comparator is
    port (
      v : in  std_logic_vector(3 downto 0);
      z : out std_logic
    );
  end component;

  component circuitA is
    port (
      v : in  std_logic_vector(2 downto 0);
      m : out std_logic_vector(2 downto 0)
    );
  end component;

  component circuitB is
    port (
      z : in  std_logic;
      d1 : out std_logic_vector(0 to 6)
    );
  end component;

  component mux is
    port (
      A, B : in std_logic;
      sel  : in std_logic;
      M    : out std_logic
    );
  end component;

  component decoder7 is
    port (
      C       : in  std_logic_vector(3 downto 0);
      Display : out std_logic_vector(0 to 6)
    );
  end component;
  

begin

  u_comparator: comparator port map (v => v, z => z);

  u_circuitA: circuitA port map (v => v(2 downto 0), m => n);
	 
  u_circuitB: circuitB port map (z => z, d1 => HEX1);

  dec: decoder7 port map (C => m, Display => HEX0);
 
  M3: mux port map (A => v(3), B => '0', sel => z, M => m(3));
  M2: mux port map (A => v(2), B => n(2), sel => z, M => m(2));
  M1: mux port map (A => v(1), B => n(1), sel => z, M => m(1));
  M0: mux port map (A => v(0), B => n(0), sel => z, M => m(0));

end structural;
