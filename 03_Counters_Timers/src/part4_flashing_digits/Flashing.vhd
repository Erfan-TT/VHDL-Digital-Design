LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Flashing IS
    PORT (
        CLOCK_50 : IN  std_logic;                      -- 50 MHz clock
        SW       : IN  std_logic_vector(1 DOWNTO 0);   -- SW(1): Enable, SW(0): Reset
        HEX0     : OUT std_logic_vector(6 DOWNTO 0)    -- Display digit 0-9
    );
END Flashing;

ARCHITECTURE structural OF Flashing IS

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

    SIGNAL counter_50M    : std_logic_vector(25 DOWNTO 0);
    SIGNAL carry_50M      : std_logic_vector(24 DOWNTO 0);
    SIGNAL clear_50M      : std_logic;

    SIGNAL counter_digit  : std_logic_vector(3 DOWNTO 0);
    SIGNAL carry_digit    : std_logic_vector(2 DOWNTO 0);

    SIGNAL reset_n        : std_logic;
    SIGNAL reset_next     : std_logic := '0';
    SIGNAL enable         : std_logic;

    SIGNAL one_hz_tick    : std_logic;
    SIGNAL clear_digit    : std_logic;


BEGIN
    -- Input mappings

    reset_n <=  SW(0);  -- Active-low Reset (SW0)
    enable  <= SW(1);
    clear_50M <= reset_n OR reset_next;

    -------------------------------------------------------------------
    -- 26-bit Counter for 1 Hz Tick (Counts to 50,000,000)
    -------------------------------------------------------------------
    -- First flip-flop
    tff_0_50M : Tflip_flop
        PORT MAP (
            clk    => CLOCK_50,
            clear  => clear_50M,
            toggle => enable,
            q_out  => counter_50M(0)
        );
    carry_50M(0) <= enable AND counter_50M(0);


	-- Generate flip-flops from bit 1 to 25
	gen_counter_50M : FOR i IN 1 TO 25 GENERATE
		 tff : Tflip_flop
			  PORT MAP (
					clk    => CLOCK_50,
					clear  => clear_50M,
					toggle => carry_50M(i - 1),
					q_out  => counter_50M(i)
			  );
	END GENERATE;

	-- Generate carry logic only for 1 to 24
	gen_carry_50M : FOR i IN 1 TO 24 GENERATE
		 carry_50M(i) <= carry_50M(i - 1) AND counter_50M(i);
	END GENERATE;

   -- Generate 1Hz pulse when counter_50M reaches 50 million (binary: "10111110101111000010000000")
--    one_hz_tick <= '1' WHEN counter_50M = "10111110101111000010000000" ELSE '0';

   -- In order to simulate, we use 50 "00000000000000000000110010"
    one_hz_tick <= '1' WHEN counter_50M = "00000000000000000000110010" ELSE '0';


	 process(CLOCK_50)
	begin
		 if rising_edge(CLOCK_50) then
			  if one_hz_tick = '1' then
					reset_next <= '1';
			  else
					reset_next <= '0';
			  end if;
		 end if;
	end process;

    -------------------------------------------------------------------
    -- 4-bit Counter to count 0–9, incremented every 1 Hz
    -------------------------------------------------------------------
    -- First flip-flop
    tff_0_digit : Tflip_flop
        PORT MAP (
            clk    => CLOCK_50,
            clear  => clear_digit,
            toggle => one_hz_tick,
            q_out  => counter_digit(0)
        );
    carry_digit(0) <= one_hz_tick AND counter_digit(0);


		-- Bits 1 to 3
		gen_counter_digit : FOR i IN 1 TO 3 GENERATE
			 tff : Tflip_flop
				  PORT MAP (
						clk    => CLOCK_50,
						clear  => clear_digit,
						toggle => carry_digit(i - 1),
						q_out  => counter_digit(i)
				  );
		END GENERATE;


		-- Carry logic for bits 1 and 2 only (since carry_digit has only 3 bits)
		gen_carry_digit : FOR i IN 1 TO 2 GENERATE
			 carry_digit(i) <= carry_digit(i - 1) AND counter_digit(i);
		END GENERATE;


    -------------------------------------------------------------------
    -- Reset digit counter after 9
    -------------------------------------------------------------------

	 clear_digit <= '1' WHEN reset_n = '1' OR (counter_digit = "1010" AND one_hz_tick = '1') ELSE '0';


    -------------------------------------------------------------------
    -- Display Digit on HEX0
    -------------------------------------------------------------------
    seg_display : seven_seg_dec
        PORT MAP (
            s   => counter_digit,
            hex => HEX0
        );

END structural;
