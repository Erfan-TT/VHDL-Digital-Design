LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Dflipf_flop IS
	PORT (D, Clock, Resetn : IN STD_LOGIC;
	Q : OUT STD_LOGIC);
END Dflipf_flop;

ARCHITECTURE Behavior OF Dflipf_flop IS
BEGIN
	PROCESS (Clock, Resetn)
	BEGIN
		IF (Resetn = '0'and rising_edge(Clock)) THEN 
		Q <= '0';
		ELSIF (rising_edge(Clock)) THEN
		Q <= D;
		END IF;	
	END PROCESS;
END Behavior;
--Flip-flop with asynchronous reset