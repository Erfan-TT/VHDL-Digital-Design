LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity declaration for a Full Adder
ENTITY FullAdder IS
    PORT (
        a     : IN  STD_LOGIC;   -- Input bit a
        b     : IN  STD_LOGIC;   -- Input bit b
        c     : IN  STD_LOGIC;   -- Input carry bit
        sum   : OUT STD_LOGIC;   -- Output sum bit
        carry : OUT STD_LOGIC    -- Output carry bit
    );
END FullAdder;

-- Architecture definition for the Full Adder
ARCHITECTURE behavior OF FullAdder IS
    -- Component declaration for the 2-to-1 multiplexer
    COMPONENT mult2to1 IS
        PORT (
            input  : IN  std_logic_vector(1 DOWNTO 0);  -- Input vector
            sel    : IN  STD_LOGIC;                      -- Select signal
            output : OUT STD_LOGIC                       -- Output signal
        );
    END COMPONENT;

    -- Internal signal for intermediate sum (a XOR b)
    SIGNAL s : STD_LOGIC;

BEGIN
    -- Calculate intermediate sum (a XOR b)
    s <= a XOR b;

    -- Calculate the final sum (s XOR c)
    sum <= s XOR c;

    -- Instantiate the 2-to-1 multiplexer to calculate the carry
    mux : mult2to1
        PORT MAP (
            input(0) => b,      -- Input 0 of the multiplexer is b
            input(1) => c,      -- Input 1 of the multiplexer is c
            sel      => s,      -- Select signal is the intermediate sum (s)
            output   => carry    -- Output is the carry bit
        );

END behavior;