LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity declaration for a 4-bit Adder/Subtractor with registered inputs and outputs
ENTITY bit_Full_Adder IS
    PORT (
        ain      : IN  std_logic_vector(3 DOWNTO 0);
        bin      : IN  std_logic_vector(3 DOWNTO 0);
        Op       : IN  STD_LOGIC;   -- 0: addition, 1: subtraction
        Clock    : IN  STD_LOGIC;
        Resetn   : IN  STD_LOGIC;
        sout     : OUT std_logic_vector(3 DOWNTO 0);
        overflow : OUT STD_LOGIC
    );
END bit_Full_Adder;

ARCHITECTURE behavior OF bit_Full_Adder IS
    COMPONENT regn IS
        PORT (
            R      : IN  std_logic_vector(3 DOWNTO 0);
            Clock  : IN  STD_LOGIC;
            Resetn : IN  STD_LOGIC;
            Q      : OUT std_logic_vector(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT FullAdder IS
        PORT (
            a     : IN  STD_LOGIC;
            b     : IN  STD_LOGIC;
            c     : IN  STD_LOGIC;
            sum   : OUT STD_LOGIC;
            carry : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT flipflop IS
        PORT (
            D      : IN  STD_LOGIC;
            Clock  : IN  STD_LOGIC;
            Resetn : IN  STD_LOGIC;
            Q      : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL QA, QB : std_logic_vector(3 DOWNTO 0);
    SIGNAL RS     : std_logic_vector(3 DOWNTO 0);
    SIGNAL internalcarry : std_logic_vector(4 DOWNTO 0);
    SIGNAL internaloverflow : STD_LOGIC;
    SIGNAL B_modified : std_logic_vector(3 DOWNTO 0);
    SIGNAL cin : STD_LOGIC;

BEGIN
    -- Use 2's complement logic for subtraction
    B_modified <= bin WHEN Op = '0' ELSE NOT bin;
    cin <= Op;
    internalcarry(0) <= cin;

    -- Register inputs
    regnA : regn PORT MAP (ain, Clock, Resetn, QA);
    regnB : regn PORT MAP (bin, Clock, Resetn, QB);

    -- Perform 4-bit addition/subtraction
    FA0 : FullAdder PORT MAP (QA(0), B_modified(0), internalcarry(0), RS(0), internalcarry(1));
    FA1 : FullAdder PORT MAP (QA(1), B_modified(1), internalcarry(1), RS(1), internalcarry(2));
    FA2 : FullAdder PORT MAP (QA(2), B_modified(2), internalcarry(2), RS(2), internalcarry(3));
    FA3 : FullAdder PORT MAP (QA(3), B_modified(3), internalcarry(3), RS(3), internalcarry(4));

    -- Signed overflow detection for 2's complement
    internaloverflow <= internalcarry(4) XOR internalcarry(3);

    -- Register overflow
    ff0 : flipflop PORT MAP (internaloverflow, Clock, Resetn, overflow);

    -- Registered output
    regnS : regn PORT MAP (RS, Clock, Resetn, sout);

END behavior;
