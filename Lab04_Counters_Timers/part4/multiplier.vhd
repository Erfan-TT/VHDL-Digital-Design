LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY multiplier IS
    PORT (
        SW     : IN  std_logic_vector(7 DOWNTO 0);  -- SW3-0: A, SW7-4: B
        KEY    : IN  std_logic_vector(1 DOWNTO 0);    -- KEY(0)=Reset (active low), KEY(1)=Clock
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector(6 DOWNTO 0);
        output : OUT std_logic_vector(7 DOWNTO 0)
    );
END multiplier;

ARCHITECTURE structural OF multiplier IS
    COMPONENT seven_seg_dec IS
        PORT ( s: IN std_logic_vector(3 DOWNTO 0); hex: OUT std_logic_vector(6 DOWNTO 0) );
    END COMPONENT;
    COMPONENT regn IS
        PORT ( R: IN std_logic_vector(3 DOWNTO 0); Clock, Resetn: IN std_logic; Q: OUT std_logic_vector(3 DOWNTO 0) );
    END COMPONENT;
    COMPONENT FullAdder IS
        PORT ( a, b, c: IN std_logic; sum, carry: OUT std_logic );
    END COMPONENT;

    SIGNAL A, B : std_logic_vector(3 DOWNTO 0);
    SIGNAL p00, p01, p02, p03, p10, p11, p12, p13,
           p20, p21, p22, p23, p30, p31, p32, p33 : std_logic;
    SIGNAL C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11 : std_logic;
    SIGNAL s2, s4, s5, s7, s10 : std_logic;
    SIGNAL prod : std_logic_vector(7 DOWNTO 0);
BEGIN
    -- Register inputs A and B
    regA: regn PORT MAP ( R => SW(3 DOWNTO 0), Clock => KEY(1), Resetn => KEY(0), Q => A );
    regB: regn PORT MAP ( R => SW(7 DOWNTO 4), Clock => KEY(1), Resetn => KEY(0), Q => B );

    -- Generate partial products
    p00 <= A(0) and B(0); p01 <= A(0) and B(1); p02 <= A(0) and B(2); p03 <= A(0) and B(3);
    p10 <= A(1) and B(0); p11 <= A(1) and B(1); p12 <= A(1) and B(2); p13 <= A(1) and B(3);
    p20 <= A(2) and B(0); p21 <= A(2) and B(1); p22 <= A(2) and B(2); p23 <= A(2) and B(3);
    p30 <= A(3) and B(0); p31 <= A(3) and B(1); p32 <= A(3) and B(2); p33 <= A(3) and B(3);

    prod(0) <= p00;
    FA1: FullAdder PORT MAP ( a => p01, b => p10, c => '0', sum => prod(1), carry => C1 );
    FA2: FullAdder PORT MAP ( a => p02, b => p11, c => p20, sum => s2, carry => C2 );
    FA3: FullAdder PORT MAP ( a => s2, b => C1, c => '0', sum => prod(2), carry => C3 );
    FA4: FullAdder PORT MAP ( a => p03, b => p12, c => p21, sum => s4, carry => C4 );
    FA5: FullAdder PORT MAP ( a => s4, b => p30, c => C2, sum => s5, carry => C5 );
    FA6: FullAdder PORT MAP ( a => s5, b => C3, c => '0', sum => prod(3), carry => C6 );
    FA7: FullAdder PORT MAP ( a => p13, b => p22, c => p31, sum => s7, carry => C7 );
    FA8: FullAdder PORT MAP ( a => s7, b => C4, c => C5, sum => prod(4), carry => C8 );
    FA9: FullAdder PORT MAP ( a => C6, b => C7, c => '0', sum => prod(5), carry => C9 );
    FA10: FullAdder PORT MAP ( a => p23, b => p32, c => C8, sum => s10, carry => C10 );
    FA11: FullAdder PORT MAP ( a => s10, b => C9, c => '0', sum => prod(6), carry => C11 );
    FA12: FullAdder PORT MAP ( a => p33, b => C10, c => C11, sum => prod(7), carry => open );

    output <= prod;

    display_A: seven_seg_dec PORT MAP ( s => A, hex => HEX0 );
    display_B: seven_seg_dec PORT MAP ( s => B, hex => HEX1 );
    display_lower: seven_seg_dec PORT MAP ( s => prod(3 DOWNTO 0), hex => HEX2 );
    display_upper: seven_seg_dec PORT MAP ( s => prod(7 DOWNTO 4), hex => HEX3 );
    HEX4 <= "1111111"; HEX5 <= "1111111";
END structural;

KEY(1) => Clock, KEY(0) => Resetn
