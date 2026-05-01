LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY regn IS
    GENERIC ( N : integer := 4 );
    PORT (
        R      : IN  signed(N-1 DOWNTO 0);
        Clock  : IN  std_logic;
        Resetn : IN  std_logic;
        Q      : OUT signed(N-1 DOWNTO 0)
    );
END regn;

ARCHITECTURE Behavior OF regn IS
BEGIN
    PROCESS (Clock, Resetn)
    BEGIN
        IF (Resetn = '0') THEN
            Q <= (OTHERS => '0');
		  -- RISING EDGE OF THE CLOCK
        ELSIF (Clock'EVENT AND Clock = '1') THEN
            Q <= R;
        END IF;
    END PROCESS;
END Behavior;
