LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY FullAdder IS
    PORT (
        a     : IN  STD_LOGIC;   -- Input bit a
        b     : IN  STD_LOGIC;   -- Input bit b
        c     : IN  STD_LOGIC;   -- Input carry bit
        sum   : OUT STD_LOGIC;   -- Output sum bit
        carry : OUT STD_LOGIC    -- Output carry bit
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

    -- Instantiate the 2-to-1 multiplexer to calculate the carry
    mux : mult2to1
        PORT MAP (
            input(0) => b,      
            input(1) => c,      
            sel      => s,      -- Select signal is the intermediate sum (s)
            output   => carry    -- Output is the carry bit
        );

END behavior;