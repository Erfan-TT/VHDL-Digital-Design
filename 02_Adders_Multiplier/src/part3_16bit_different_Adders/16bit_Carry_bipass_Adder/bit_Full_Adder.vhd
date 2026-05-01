LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY bit_Full_Adder IS
    PORT (
        ain      : IN  std_logic_vector(3 DOWNTO 0);  
        bin      : IN  std_logic_vector(3 DOWNTO 0);  
        cin      : IN  std_logic;                     
        sout     : OUT std_logic_vector(3 DOWNTO 0);  
        overflow : OUT std_logic                     
);
 
END bit_Full_Adder;


ARCHITECTURE behavior OF bit_Full_Adder IS
    
    
    
    COMPONENT FullAdder IS
        PORT (
            a     : IN  std_logic;   
            b     : IN  std_logic;   
            c     : IN  std_logic;   
            sum   : OUT std_logic;   
            carry : OUT std_logic    
        );
    END COMPONENT;


    -- Internal signals.
    SIGNAL QA, QB : std_logic_vector(3 DOWNTO 0);   
    SIGNAL QS   : std_logic_vector(3 DOWNTO 0);        
    SIGNAL internalcarry : std_logic_vector(4 DOWNTO 0);    

BEGIN

    QA <= ain;
    QB <= bin;

internalcarry(0) <= cin;

-- Generate full adder chain
GEN_FORLOOP : FOR i IN 0 TO 3 GENERATE
    FAx : FullAdder
        PORT MAP (
            a     => QA(i),
            b     => QB(i),
            c     => internalcarry(i),
            sum   => QS(i),
            carry => internalcarry(i+1)
        );
END GENERATE GEN_FORLOOP;


    sout <= QS;

    overflow <= internalcarry(4) xor internalcarry(3);

END behavior;
