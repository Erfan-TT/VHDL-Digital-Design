LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2to1_4bit_tb IS
END mux2to1_4bit_tb;

ARCHITECTURE test OF mux2to1_4bit_tb IS
    SIGNAL S   : STD_LOGIC := '0';
    SIGNAL X   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Y   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
    SIGNAL M   : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Component Declaration
    COMPONENT mux2to1
        PORT (
            S   : IN  STD_LOGIC;
            X   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            M   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Instantiate the MUX
    DUT: mux2to1 PORT MAP (S => S, X => X, Y => Y, M => M);

    -- Test process
    PROCESS
    BEGIN
        -- Case 1: S = 0, M should be X
        S <= '0'; X <= "1010"; Y <= "0101"; WAIT FOR 10 ns;
        
        -- Case 2: S = 1, M should be Y
        S <= '1'; WAIT FOR 10 ns;

        -- Case 3: S = 0, different X
        S <= '0'; X <= "1100"; WAIT FOR 10 ns;

        -- Case 4: S = 1, different Y
        S <= '1'; Y <= "0011"; WAIT FOR 10 ns;

        -- End simulation
        WAIT;
    END PROCESS;
END test;
