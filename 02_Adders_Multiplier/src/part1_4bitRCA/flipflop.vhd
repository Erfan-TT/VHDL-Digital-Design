LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY flipflop IS
    PORT (
        D      : IN  STD_LOGIC;   
        Clock  : IN  STD_LOGIC;   
        Resetn : IN  STD_LOGIC;   
        Q      : OUT STD_LOGIC    
    );
END flipflop;


ARCHITECTURE Behavior OF flipflop IS
BEGIN
    
    PROCESS (Clock, Resetn)
    BEGIN
        
        IF Resetn = '0' THEN
            Q <= '0';  
        
      
        ELSIF rising_edge(Clock) THEN
            Q <= D;  
        END IF;
    END PROCESS;
END Behavior;