LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux5to1_tb IS
END mux5to1_tb;

ARCHITECTURE test OF mux5to1_tb IS
    SIGNAL S   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL X   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Y   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
    SIGNAL M   : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Component Declaration
    COMPONENT mux5to1
        PORT (
            S   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            X   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            Y   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            M   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Instantiate the MUX
    DUT: mux5to1 PORT MAP (S => S, X => X, Y => Y, M => M);

    -- Test process
    PROCESS
    BEGIN
        -- Test each select input
        S <= "000"; WAIT FOR 10 ns; -- Should select "101"
        S <= "001"; WAIT FOR 10 ns; -- Should select "010"
        S <= "010"; WAIT FOR 10 ns; -- Should select "111"
        S <= "011"; X <= "100"; WAIT FOR 10 ns; -- Should select X = "100"
        S <= "100"; Y <= "011"; WAIT FOR 10 ns; -- Should select Y = "011"
        
        -- End simulation
        WAIT;
    END PROCESS;
END test;
