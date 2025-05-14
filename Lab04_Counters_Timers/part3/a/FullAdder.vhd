LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY FullAdder IS
    PORT (
        a     : IN  STD_LOGIC;   
        b     : IN  STD_LOGIC;   
        c     : IN  STD_LOGIC;   
        sum   : OUT STD_LOGIC;   
        carry : OUT STD_LOGIC    
    );
END FullAdder;


ARCHITECTURE behavior OF FullAdder IS
   
    COMPONENT mult2to1 IS
        PORT (
            input  : IN  std_logic_vector(1 DOWNTO 0);  
            sel    : IN  STD_LOGIC;                      
            output : OUT STD_LOGIC                       
        );
    END COMPONENT;

    
    SIGNAL s : STD_LOGIC;

BEGIN
    
    s <= a XOR b;

   
    sum <= s XOR c;

    
    mux : mult2to1
        PORT MAP (
            input(0) => b,      
            input(1) => c,      
            sel      => s,     
            output   => carry   
        );

END behavior;