LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity declaration for a 1-bit 2-to-1 multiplexer
ENTITY mult2to1 IS
    PORT (
        input  : IN  std_logic_vector(1 DOWNTO 0);  -- Two input signals
        sel    : IN  STD_LOGIC;                     -- Select signal
        output : OUT STD_LOGIC                      -- Output signal
		  
		  
		  
    );
END mult2to1;

-- Architecture definition for the multiplexer
ARCHITECTURE behavior OF mult2to1 IS
BEGIN
    -- Process to select the output based on the select signal
    PROCESS (sel, input)
    BEGIN
        IF sel = '0' THEN
            output <= input(0);  -- Select the first input when sel is '0'
        ELSE
            output <= input(1);  -- Select the second input when sel is '1'
        END IF;
    END PROCESS;
END behavior;