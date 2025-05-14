LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY mult2to1_4bit IS
    PORT (
        input0  : IN  std_logic_vector(3 DOWNTO 0);  
		  input1  : IN  std_logic_vector(3 DOWNTO 0);
        sel    : IN  STD_LOGIC;                     
        output : OUT std_logic_vector(3 DOWNTO 0)   
    );
END mult2to1_4bit;


ARCHITECTURE behavior OF mult2to1_4bit IS
BEGIN
 
    PROCESS (sel, input0, input1)
    BEGIN
        IF sel = '0' THEN
            output <= input0; 
        ELSE
            output <= input1;  
        END IF;
    END PROCESS;
END behavior;