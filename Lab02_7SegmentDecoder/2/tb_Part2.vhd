LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tb_Part2 IS
-- No ports as this is a test bench
END tb_Part2;

ARCHITECTURE behavior OF tb_Part2 IS

  -- Component declaration for the Unit Under Test (UUT)
  COMPONENT Part2
    PORT (
      SW   : IN  STD_LOGIC_VECTOR(4 downto 0);
      HEX0 : OUT STD_LOGIC_VECTOR(0 to 6);
      HEX1 : OUT STD_LOGIC_VECTOR(0 to 6);
      HEX2 : OUT STD_LOGIC_VECTOR(0 to 6);
      HEX3 : OUT STD_LOGIC_VECTOR(0 to 6);
      HEX4 : OUT STD_LOGIC_VECTOR(0 to 6)
    );
  END COMPONENT;

  -- Signal declarations to connect to the UUT
  SIGNAL SW   : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
  SIGNAL HEX0 : STD_LOGIC_VECTOR(0 to 6);
  SIGNAL HEX1 : STD_LOGIC_VECTOR(0 to 6);
  SIGNAL HEX2 : STD_LOGIC_VECTOR(0 to 6);
  SIGNAL HEX3 : STD_LOGIC_VECTOR(0 to 6);
  SIGNAL HEX4 : STD_LOGIC_VECTOR(0 to 6);

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: Part2 PORT MAP (
    SW   => SW,
    HEX0 => HEX0,
    HEX1 => HEX1,
    HEX2 => HEX2,
    HEX3 => HEX3,
    HEX4 => HEX4
  );

  -- Stimulus process: Apply test vectors to SW
  stim_proc: PROCESS
  BEGIN
    -- the first two bits to choose the word, the other three to shift the word:

     -- Test case 1: All zeros, meaning the result should be "HELLO", "1001000"
    SW <= "00000";
    WAIT for 10 ns;

    -- Test case 2: shifting Hello to "ELLOH"
    SW <= "00001";
    WAIT for 10 ns;

    -- Test case 3: shifting Hello to "LLOHE"
    SW <= "00010";
    WAIT for 10 ns;

    -- Test case 4: shifting Hello to "LOHEL"
    SW <= "00011";
    WAIT for 10 ns;

    -- Test case 5: shifting Hello to "OHELL"
    SW <= "00100";
    WAIT for 10 ns;

    -- Test case 6: choosing the word CEPPO shifting to "PPOCE"
    SW <= "01010";
    WAIT for 10 ns;

    -- Test case 7: choosing the word CELLO, no shifting as 101 is treated like the defult based on the truth table.
    SW <= "10101";
    WAIT for 10 ns;

    -- Test case 8: choosing the word FEPPO, no shifting as 111 is treated like the defult based on the truth table.
    SW <= "11111";
    WAIT for 10 ns;



    WAIT;  -- Wait forever - simulation ends here.
  END PROCESS;

END behavior;
