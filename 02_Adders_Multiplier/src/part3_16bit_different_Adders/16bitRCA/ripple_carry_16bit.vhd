LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ripple_carry_16bit IS
    PORT (
        ain      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input A
        bin      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input B
        cin      : IN  std_logic;                     -- Carry input
        Clock    : IN  std_logic;                     -- Clock signal
        Resetn   : IN  std_logic;                     -- Active-low reset
        sout     : OUT std_logic_vector(15 DOWNTO 0);  -- 16-bit sum output
        overflow : OUT std_logic                     -- Overflow flag
);
 
END ripple_carry_16bit;


ARCHITECTURE behavior OF ripple_carry_16bit IS
    
    
    COMPONENT regn IS
        GENERIC ( N : integer := 16 );
        PORT (
            R      : IN  signed(N-1 DOWNTO 0);
            Clock  : IN  std_logic;
            Resetn : IN  std_logic;
            Q      : OUT signed(N-1 DOWNTO 0)
        );
    END COMPONENT;

    
    COMPONENT FullAdder IS
        PORT (
            a     : IN  std_logic;   
            b     : IN  std_logic;   
            c     : IN  std_logic;   
            sum   : OUT std_logic;   
            carry : OUT std_logic    
        );
    END COMPONENT;

    
    COMPONENT flipflop IS
        PORT (
            D      : IN  std_logic;
            Clock  : IN  std_logic;
            Resetn : IN  std_logic;
            Q      : OUT std_logic
        );
    END COMPONENT;

    -- Internal signals.

    SIGNAL QA_s, QB_s, QS_s : signed(15 DOWNTO 0);  -- Registered signed inputs and sum
	
    -- Signals to interface with the bit-level full adder chain:
    SIGNAL QA, QB : std_logic_vector(15 DOWNTO 0);   -- Conversion from signed to std_logic_vector
    SIGNAL QS   : std_logic_vector(15 DOWNTO 0);       -- Sum from the full adder chain (before re-registering)
    
    SIGNAL internalcarry : std_logic_vector(16 DOWNTO 0);  -- Carry signals between Full Adders
    SIGNAL internaloverflow : std_logic;              -- Overflow flag

BEGIN

    regnA : regn 
        GENERIC MAP ( N => 16 )
        PORT MAP (
            R      => signed(ain),   -- Convert ain to signed
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QA_s           -- Registered signed output for A
        );

    regnB : regn 
        GENERIC MAP ( N => 16 )
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
  -- Set initial carry input
internalcarry(0) <= cin;

-- Generate full adder chain
GEN_FORLOOP : FOR i IN 0 TO 15 GENERATE
    FAx : FullAdder
        PORT MAP (
            a     => QA(i),
            b     => QB(i),
            c     => internalcarry(i),
            sum   => QS(i),
            carry => internalcarry(i+1)
        );
END GENERATE GEN_FORLOOP;




    -- Register the raw sum from the full adder chain.
    regnS : regn 
        GENERIC MAP ( N => 16 )
        PORT MAP (
            R      => signed(QS),   -- Convert QS to signed for registering
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QS_s          -- Registered signed sum
        );

    -- Convert the registered signed sum back to std_logic_vector for output and display.
    sout <= std_logic_vector(QS_s);

    -- Correct signed overflow detection: compare the carry into and out of the MSB.
    internaloverflow <= internalcarry(16) xor internalcarry(15);

    ff0 : flipflop PORT MAP (
        D      => internaloverflow,
        Clock  => Clock,
        Resetn => Resetn,
        Q      => overflow
    );



END behavior;
