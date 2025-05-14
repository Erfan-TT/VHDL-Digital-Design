LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_carry_select IS
END tb_carry_select;

ARCHITECTURE behavior OF tb_carry_select IS

    COMPONENT carry_sellect
        PORT (
            ain      : IN  std_logic_vector(15 DOWNTO 0);
            bin      : IN  std_logic_vector(15 DOWNTO 0);
            cin      : IN  std_logic;
            Clock    : IN  std_logic;
            Resetn   : IN  std_logic;
            sout     : OUT std_logic_vector(15 DOWNTO 0);
            overflow : OUT std_logic
        );
    END COMPONENT;

    -- Signals for DUT
    SIGNAL ain, bin : std_logic_vector(15 DOWNTO 0) := (others => '0');
    SIGNAL cin      : std_logic := '0';
    SIGNAL Clock    : std_logic := '0';
    SIGNAL Resetn   : std_logic := '0';
    SIGNAL sout     : std_logic_vector(15 DOWNTO 0) := (others => '0');
    SIGNAL overflow : std_logic;

BEGIN

    -- DUT Instantiation
    uut: carry_sellect
        PORT MAP (
            ain      => ain,
            bin      => bin,
            cin      => cin,
            Clock    => Clock,
            Resetn   => Resetn,
            sout     => sout,
            overflow => overflow
        );

    -- Clock generation (100 MHz)
Clock_process : PROCESS
BEGIN
    LOOP
        Clock <= '0';
        WAIT FOR 5 ns;
        Clock <= '1';
        WAIT FOR 5 ns;
    END LOOP;
END PROCESS;


    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Hold reset low
        Resetn <= '0';
        WAIT FOR 25 ns;

        -- Release reset
        Resetn <= '1';

        -- Test Case 1: 5 + 3
        ain <= x"0005";
        bin <= x"0003";
        cin <= '0';
        WAIT FOR 40 ns;

        -- Test Case 2: -1 + 1
        ain <= x"FFFF";  -- -1 in 2's complement
        bin <= x"0001";
        cin <= '0';
        WAIT FOR 40 ns;

        -- Test Case 3: Large values (overflow expected)
        ain <= x"7000";
        bin <= x"7000";
        cin <= '0';
        WAIT FOR 40 ns;

        -- Test Case 4: Add with cin = 1
        ain <= x"0002";
        bin <= x"0002";
        cin <= '1';
        WAIT FOR 40 ns;

        -- Finish simulation
        WAIT;
    END PROCESS;

END behavior;
