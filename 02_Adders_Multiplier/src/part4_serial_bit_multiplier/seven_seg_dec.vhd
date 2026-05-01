LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity declaration for the 7-segment decoder
ENTITY seven_seg_dec IS
    PORT (
        s   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 4-bit input
        hex : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- 7-segment output
    );
END seven_seg_dec;

-- Architecture definition for the 7-segment decoder
ARCHITECTURE Behavior OF seven_seg_dec IS
    -- Internal signals for 7-segment display patterns
    SIGNAL zero, one, two, three, four, five, six, seven, eight, nine : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL a, b, c, d, e, f : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
    -- Define the 7-segment patterns for each hexadecimal digit
    zero  <= "1000000";  -- 0
    one   <= "1111001";  -- 1
    two   <= "0100100";  -- 2
    three <= "0110000";  -- 3
    four  <= "0011001";  -- 4
    five  <= "0010010";  -- 5
    six   <= "0000010";  -- 6
    seven <= "1111000";  -- 7
    eight <= "0000000";  -- 8
    nine  <= "0010000";  -- 9
    a     <= "0001000";  -- A
    b     <= "0000011";  -- B
    c     <= "1000110";  -- C
    d     <= "0100001";  -- D
    e     <= "0000110";  -- E
    f     <= "0001110";  -- F

    -- Decode the 4-bit input to the corresponding 7-segment output
    PROCESS (s)
    BEGIN
        CASE s IS
            WHEN "0000" => hex <= zero;   -- 0
            WHEN "0001" => hex <= one;    -- 1
            WHEN "0010" => hex <= two;    -- 2
            WHEN "0011" => hex <= three;  -- 3
            WHEN "0100" => hex <= four;   -- 4
            WHEN "0101" => hex <= five;   -- 5
            WHEN "0110" => hex <= six;    -- 6
            WHEN "0111" => hex <= seven;  -- 7
            WHEN "1000" => hex <= eight;  -- 8
            WHEN "1001" => hex <= nine;   -- 9
            WHEN "1010" => hex <= a;     -- A
            WHEN "1011" => hex <= b;     -- B
            WHEN "1100" => hex <= c;     -- C
            WHEN "1101" => hex <= d;     -- D
            WHEN "1110" => hex <= e;     -- E
            WHEN "1111" => hex <= f;     -- F
            WHEN OTHERS => hex <= zero;  -- Default to 0 for invalid inputs
        END CASE;
    END PROCESS;

END Behavior;