LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY mult2to1 IS
    PORT (
        input  : IN  std_logic_vector(1 DOWNTO 0);  
        sel    : IN  STD_LOGIC;                     
        output : OUT STD_LOGIC                      
    );
END mult2to1;


ARCHITECTURE behavior OF mult2to1 IS
BEGIN
   
    PROCESS (sel, input)
    BEGIN
        IF sel = '0' THEN
            output <= input(0);  
        ELSE
            output <= input(1); 
        END IF;
    END PROCESS;
END behavior;