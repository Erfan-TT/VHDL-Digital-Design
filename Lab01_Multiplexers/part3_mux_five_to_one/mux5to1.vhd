LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux5to1 IS
    PORT (
        S   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);   -- 3 bit select input (SW[8:6])
        X   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);   -- 3 bit input X (SW[5:3])
        Y   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);   -- 3 bit input Y (SW[2:0])
        M   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)    -- 3 bit output M (LEDR[2:0])
    );
END mux5to1;

ARCHITECTURE Behavior OF mux5to1 IS
    -- Declare constant values
    CONSTANT U : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
    CONSTANT V : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT W : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";

BEGIN
    PROCESS(S, X, Y)
    BEGIN
        
        IF S = "000" THEN
            M <= U; -- Select constant "101"
				
				ELSIF S = "001" THEN
            M <= V;  -- Select constant "010"
				
        ELSIF S = "010" THEN
            M <= W;  -- Select constant "111"
				
        ELSIF S = "011" THEN
            M <= X;  -- Select X (SW[5:3])
				
        ELSIF S = "100" THEN
            M <= Y;  -- Select Y (SW[2:0])
				
        ELSE
            M <= Y; -- Other cases, which should be the Y
				
        END IF;
    END PROCESS;

END Behavior;
