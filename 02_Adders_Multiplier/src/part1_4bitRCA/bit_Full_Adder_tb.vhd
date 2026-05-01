LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity declaration for the testbench
ENTITY FourBitFullAdder_tb IS
END FourBitFullAdder_tb;

-- Architecture definition for the testbench
ARCHITECTURE mytest OF FourBitFullAdder_tb IS
    -- Component declaration for the 4-bit Full Adder (FourBitFullAdder)
    COMPONENT FourBitFullAdder IS
        PORT (
            ain      : IN  std_logic_vector(3 DOWNTO 0);  -- 4-bit input A
            bin      : IN  std_logic_vector(3 DOWNTO 0);  -- 4-bit input B
            cin      : IN  STD_LOGIC;                    -- Carry input
            Clock    : IN  STD_LOGIC;                     -- Clock signal
            Resetn   : IN  STD_LOGIC;                     -- Active-low reset
            sout     : OUT std_logic_vector(3 DOWNTO 0);  -- 4-bit sum output
            overflow : OUT STD_LOGIC                      -- Overflow flag
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk     : STD_LOGIC := '0';                     -- Clock signal
    SIGNAL inputC  : STD_LOGIC := '0';                     -- Carry input
    SIGNAL reset   : STD_LOGIC := '1';                     -- Reset signal (active low)
    SIGNAL outputO : STD_LOGIC;                            -- Overflow output
    SIGNAL inputA  : std_logic_vector(3 DOWNTO 0) := "0111"; -- Input A (7 in decimal)
    SIGNAL inputB  : std_logic_vector(3 DOWNTO 0) := "0010"; -- Input B (2 in decimal)
    SIGNAL outputS : std_logic_vector(3 DOWNTO 0);          -- Sum output

BEGIN
    -- Instantiate the 4-bit Full Adder (Unit Under Test)
    uut: FourBitFullAdder PORT MAP (
        ain      => inputA,      -- Connect input A
        bin      => inputB,      -- Connect input B
        cin      => inputC,      -- Connect carry input
        Clock    => clk,         -- Connect clock
        Resetn   => reset,       -- Connect reset
        sout     => outputS,     -- Connect sum output
        overflow => outputO      -- Connect overflow flag
    );

    -- Clock generation process
    PROCESS
    BEGIN
        -- Generate a clock signal with a period of 2 ns (1 ns low, 1 ns high)
        clk <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        WAIT FOR 1 ns;
        clk <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        WAIT FOR 1 ns;
        clk <= '0';
        WAIT FOR 1 ns;
        clk <= '1';
        WAIT FOR 1 ns;

        -- Stop the simulation
        WAIT;
    END PROCESS;

END mytest;