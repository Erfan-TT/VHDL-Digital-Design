LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sixteen_bit_counter IS
    PORT (
        SW        : IN  std_logic_vector(9 DOWNTO 0);  -- SW(1): Enable, SW(0): Reset (active high)
        KEY       : IN  std_logic_vector(3 downto 0);  -- KEY(0): Clock
        HEX0,
        HEX1,
        HEX2,
        HEX3      : OUT std_logic_vector(6 DOWNTO 0);  -- 7-segment outputs
        count_out : OUT std_logic_vector(15 DOWNTO 0)  -- 16-bit counter output
    );
END sixteen_bit_counter;

ARCHITECTURE structural OF sixteen_bit_counter IS

    COMPONENT Tflip_flop IS
        PORT (
            clk    : IN  std_logic;
            clear  : IN  std_logic;
            toggle : IN  std_logic;
            q_out  : OUT std_logic
        );
    END COMPONENT;

    COMPONENT seven_seg_dec IS
        PORT (
            s   : IN  std_logic_vector(3 DOWNTO 0);
            hex : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL counter_value : std_logic_vector(15 DOWNTO 0);
    SIGNAL carry_chain   : std_logic_vector(14 DOWNTO 0);  -- Only 15 needed
    SIGNAL clk           : std_logic;
    SIGNAL reset_n       : std_logic;
    SIGNAL enable        : std_logic;

BEGIN
    -- Control signal mapping
    clk      <= KEY(0);
    enable   <= SW(1);
    reset_n  <= NOT SW(0);  -- SW(0) is active-high; convert to active-low

    -- First T flip-flop
    tff_0 : Tflip_flop
        PORT MAP (
            clk    => clk,
            clear  => reset_n,
            toggle => enable,
            q_out  => counter_value(0)
        );

    -- Carry signal for second stage
    carry_chain(0) <= enable AND counter_value(0);

    -- Generate T flip-flops from bit 1 to 15
    gen_counter : FOR i IN 1 TO 15 GENERATE
        tff : Tflip_flop
            PORT MAP (
                clk    => clk,
                clear  => reset_n,
                toggle => carry_chain(i - 1),
                q_out  => counter_value(i)
            );

        -- Generate carry chain for i < 15
        carry_gen : IF i < 15 GENERATE
            carry_chain(i) <= carry_chain(i - 1) AND counter_value(i);
        END GENERATE carry_gen;
    END GENERATE gen_counter;

    -- Output assignment
    count_out <= counter_value;

    -- 7-segment decoders (using your "seven_seg_dec" entity with ports s and hex)
    seg0 : seven_seg_dec PORT MAP (s => counter_value(3 DOWNTO 0),   hex => HEX0);
    seg1 : seven_seg_dec PORT MAP (s => counter_value(7 DOWNTO 4),   hex => HEX1);
    seg2 : seven_seg_dec PORT MAP (s => counter_value(11 DOWNTO 8),  hex => HEX2);
    seg3 : seven_seg_dec PORT MAP (s => counter_value(15 DOWNTO 12), hex => HEX3);

END structural;
