LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Dflip_flop IS
	PORT (D, Clock, Resetn : IN STD_LOGIC;
	      Q : OUT STD_LOGIC);
END Dflip_flop;

ARCHITECTURE Behavior OF Dflip_flop IS
BEGIN
	PROCESS (Clock)
	BEGIN
		IF rising_edge(Clock) THEN
			IF (Resetn = '0') THEN  -- synchronous clear
				Q <= '0';
			ELSE
				Q <= D;
			END IF;
		END IF;
	END PROCESS;
END Behavior;
--Flip-flop with synchronous reset