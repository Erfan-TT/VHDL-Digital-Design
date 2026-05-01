LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY SRlatch_tb IS
END SRlatch_tb;

ARCHITECTURE behavior OF SRlatch_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT SRlatch
        PORT (
            Clk : IN  STD_LOGIC;
            R   : IN  STD_LOGIC;
            S   : IN  STD_LOGIC;
            Q   : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Signals to connect to the UUT
    SIGNAL Clk : STD_LOGIC := '0';
    SIGNAL R   : STD_LOGIC := '0';
    SIGNAL S   : STD_LOGIC := '0';
    SIGNAL Q   : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: SRlatch PORT MAP (
        Clk => Clk,
        R   => R,
        S   => S,
        Q   => Q
    );

    -- Clock process definition
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            Clk <= '0';
            WAIT FOR clk_period / 2;
            Clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initial conditions
        WAIT FOR 10 ns;  -- Small delay to stabilize the circuit

        -- Test Case 1: Reset the latch (R=1, S=0, Clk=1)
        R <= '1';
        S <= '0';
        WAIT FOR clk_period;
        
        -- Test Case 2: Set the latch (R=0, S=1, Clk=1)
        R <= '0';
        S <= '1';
        WAIT FOR clk_period;

        -- Test Case 3: Hold state (R=0, S=0, Clk=1)
        R <= '0';
        S <= '0';
        WAIT FOR clk_period;

        -- Test Case 4: Invalid state (R=1, S=1, Clk=1)
        R <= '1';
        S <= '1';
        WAIT FOR clk_period;

        -- Test Case 5: Return to a valid state
        R <= '0';
        S <= '1';
        WAIT FOR clk_period;

        -- Stop simulation
        WAIT;
    END PROCESS;

END behavior;
