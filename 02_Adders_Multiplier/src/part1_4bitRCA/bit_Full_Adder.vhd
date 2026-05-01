LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY bit_Full_Adder IS
    PORT (
        ain      : IN  std_logic_vector(3 DOWNTO 0);  -- 4-bit input A
        bin      : IN  std_logic_vector(3 DOWNTO 0);  -- 4-bit input B
        cin      : IN  std_logic;                     -- Carry input 
        Clock    : IN  std_logic;                     -- Clock signal
        Resetn   : IN  std_logic;                     -- Active-low reset
        sout     : OUT std_logic_vector(3 DOWNTO 0);  -- 4-bit sum output
        overflow : OUT std_logic;                     -- Overflow flag
        hexout, hex0, hex1 : OUT std_logic_vector(6 DOWNTO 0)   -- 7-segment display outputs
    );
END bit_Full_Adder;


ARCHITECTURE behavior OF bit_Full_Adder IS

    -- Component declaration for a 4-bit register using SIGNED numbers.
    COMPONENT regn IS
        GENERIC ( N : integer := 4 );
        PORT (
            R      : IN  signed(N-1 DOWNTO 0);
            Clock  : IN  std_logic;
            Resetn : IN  std_logic;
            Q      : OUT signed(N-1 DOWNTO 0)
        );
    END COMPONENT;

    -- Component declaration for a Full Adder (bit-level).
    COMPONENT FullAdder IS
        PORT (
            a     : IN  std_logic;   -- Input bit a
            b     : IN  std_logic;   -- Input bit b
            c     : IN  std_logic;   -- Carry input
            sum   : OUT std_logic;   -- Sum output
            carry : OUT std_logic    -- Carry output
        );
    END COMPONENT;

    -- Component declaration for a D Flip-Flop.
    COMPONENT flipflop IS
        PORT (
            D      : IN  std_logic;
            Clock  : IN  std_logic;
            Resetn : IN  std_logic;
            Q      : OUT std_logic
        );
    END COMPONENT;
	 
    -- Component declaration for a seven-segment decoder.
    COMPONENT seven_seg_dec IS
        PORT (
            s   : IN  std_logic_vector(3 DOWNTO 0);
            hex : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Internal signals.
    SIGNAL QA_s, QB_s, QS_s : signed(3 DOWNTO 0);  -- Registered signed inputs and sum
	 
    SIGNAL QA, QB : std_logic_vector(3 DOWNTO 0);   -- Conversion from signed to std_logic_vector
    SIGNAL QS   : std_logic_vector(3 DOWNTO 0);       -- Sum from the full adder chain (before re-registering)
    SIGNAL sum_reg : std_logic_vector(3 DOWNTO 0);    -- Registered sum for display
    SIGNAL internalcarry : std_logic_vector(4 DOWNTO 0);  -- Carry signals between Full Adders
    SIGNAL internaloverflow : std_logic;              -- Overflow flag

BEGIN
    -- Convert the input operands to SIGNED and store them in registers.
    regnA : regn 
        GENERIC MAP ( N => 4 )
        PORT MAP (
            R      => signed(ain),   -- Convert ain to signed
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QA_s           -- Registered signed output for A
        );

    regnB : regn 
        GENERIC MAP ( N => 4 )
        PORT MAP (
            R      => signed(bin),   -- Convert bin to signed
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QB_s           -- Registered signed output for B
        );

    -- Convert the registered signed inputs to std_logic_vector for the full adder chain.
    QA <= std_logic_vector(QA_s);
    QB <= std_logic_vector(QB_s);

    -- Full adder chain for bitwise addition.
    internalcarry(0) <= cin;  -- Initial carry

    FA0 : FullAdder PORT MAP (
        a     => QA(0),
        b     => QB(0),
        c     => internalcarry(0),
        sum   => QS(0),
        carry => internalcarry(1)
    );

    FA1 : FullAdder PORT MAP (
        a     => QA(1),
        b     => QB(1),
        c     => internalcarry(1),
        sum   => QS(1),
        carry => internalcarry(2)
    );

    FA2 : FullAdder PORT MAP (
        a     => QA(2),
        b     => QB(2),
        c     => internalcarry(2),
        sum   => QS(2),
        carry => internalcarry(3)
    );

    FA3 : FullAdder PORT MAP (
        a     => QA(3),
        b     => QB(3),
        c     => internalcarry(3),
        sum   => QS(3),
        carry => internalcarry(4)
    );

    -- Register the raw sum from the full adder chain.
    regnS : regn 
        GENERIC MAP ( N => 4 )
        PORT MAP (
            R      => signed(QS),   -- Convert QS to signed for registering
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QS_s          -- Registered signed sum
        );
    -- Convert the registered signed sum back to std_logic_vector for output and display.
    sum_reg <= std_logic_vector(QS_s);
    sout <= sum_reg;
    -- Correct signed overflow detection: compare the carry into and out of the MSB.
    internaloverflow <= internalcarry(4) xor internalcarry(3);

    ff0 : flipflop PORT MAP (
        D      => internaloverflow,
        Clock  => Clock,
        Resetn => Resetn,
        Q      => overflow
    );

    --the seven-segment decoders

    Decoder0 : seven_seg_dec PORT MAP (
        s   => ain,
        hex => hex0
    );

    Decoder1 : seven_seg_dec PORT MAP (
        s   => bin,
        hex => hex1
    );

    Decoder2 : seven_seg_dec PORT MAP (
        s   => sum_reg,
        hex => hexout
    );

END behavior;
