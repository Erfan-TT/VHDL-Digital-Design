LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux IS
    PORT (
        A,B : in STD_LOGIC;
        sel : in STD_LOGIC;
        M : out STD_LOGIC
    );
END mux;

ARCHITECTURE Behavior OF mux IS
BEGIN
    PROCESS (A,B,sel)
	 BEGIN 
	 
	 IF (sel = '0') THEN M <= A;
	 ELSE M <= B;
	 END IF;
	 END PROCESS;
END Behavior;
