LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY bit_Full_Adder_tb IS
END bit_Full_Adder_tb;

ARCHITECTURE sim OF bit_Full_Adder_tb IS
    COMPONENT bit_Full_Adder IS
        PORT (
            ain      : IN  std_logic_vector(3 DOWNTO 0);
            bin      : IN  std_logic_vector(3 DOWNTO 0);
            Op       : IN  std_logic;   -- 0 for addition, 1 for subtraction
            Clock    : IN  std_logic;
            Resetn   : IN  std_logic;
            sout     : OUT std_logic_vector(3 DOWNTO 0);
            overflow : OUT std_logic
        );
    END COMPONENT;

    SIGNAL clk         : std_logic := '0';
    SIGNAL reset       : std_logic := '0';
    SIGNAL ain_sig     : std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL bin_sig     : std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL Op_sig      : std_logic := '0';
    SIGNAL sout_sig    : std_logic_vector(3 DOWNTO 0);
    SIGNAL overflow_sig: std_logic;

    constant clk_period : time := 10 ns;
BEGIN
    -- Instantiate the unit under test
    uut: bit_Full_Adder PORT MAP (
        ain      => ain_sig,
        bin      => bin_sig,
        Op       => Op_sig,
        Clock    => clk,
        Resetn   => reset,
        sout     => sout_sig,
        overflow => overflow_sig
    );

    -- Clock generation
    clk_process: PROCESS
    BEGIN
        clk <= '0'; WAIT FOR clk_period/2;
        clk <= '1'; WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Apply reset pulse
        reset <= '0';
        WAIT FOR 20 ns;
        reset <= '1';
        WAIT FOR 20 ns;

        -- Test Case 1: Addition 7 + 2 = 9
        ain_sig <= "0111";   -- 7
        bin_sig <= "0010";   -- 2
        Op_sig  <= '0';      -- addition
        WAIT FOR 20 ns;

        -- Test Case 2: Subtraction 7 - 2 = 5
        ain_sig <= "0111";   -- 7
        bin_sig <= "0010";   -- 2
        Op_sig  <= '1';      -- subtraction
        WAIT FOR 20 ns;

        -- Test Case 3: Addition 9 + 8 = 17 (Overflow expected)
        ain_sig <= "1001";   -- 9
        bin_sig <= "1000";   -- 8
        Op_sig  <= '0';      -- addition
        WAIT FOR 20 ns;

        -- Test Case 4: Subtraction 2 - 7 = -5 (2's complement)
        ain_sig <= "0010";   -- 2
        bin_sig <= "0111";   -- 7
        Op_sig  <= '1';      -- subtraction
        WAIT FOR 20 ns;

        WAIT;
    END PROCESS;

END sim;
