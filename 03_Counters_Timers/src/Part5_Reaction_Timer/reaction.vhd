LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reaction IS
    PORT (
        CLOCK_50 : IN  std_logic;
        KEY0     : IN  std_logic;
        KEY3     : IN  std_logic;
        SW       : IN  std_logic_vector(7 DOWNTO 0);
        HEX0, HEX1, HEX2, HEX3 : OUT std_logic_vector(6 DOWNTO 0);
        LED      : OUT std_logic
    );
END reaction;

ARCHITECTURE structural OF reaction IS

    COMPONENT seven_seg_dec IS
        PORT (
            s   : IN  std_logic_vector(3 DOWNTO 0);
            hex : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT binary_to_bcd IS
        PORT (
            binary_in  : IN  std_logic_vector(15 DOWNTO 0);
            digit3     : OUT std_logic_vector(3 DOWNTO 0);
            digit2     : OUT std_logic_vector(3 DOWNTO 0);
            digit1     : OUT std_logic_vector(3 DOWNTO 0);
            digit0     : OUT std_logic_vector(3 DOWNTO 0)
        );
    END COMPONENT;

    TYPE state_type IS (WAITING, COUNTING, STOPPED);
    SIGNAL state : state_type := WAITING;

    SIGNAL clk_div_count : unsigned(15 DOWNTO 0) := (others => '0');
    SIGNAL one_khz_tick  : std_logic := '0';

    SIGNAL wait_counter      : std_logic_vector(7 DOWNTO 0);
    SIGNAL reaction_counter  : std_logic_vector(15 DOWNTO 0);

    SIGNAL reset_pressed     : std_logic;
    SIGNAL stop_pressed      : std_logic;
    SIGNAL led_on            : std_logic := '0';

    SIGNAL d0, d1, d2, d3 : std_logic_vector(3 DOWNTO 0);

BEGIN
    reset_pressed <= NOT KEY0;
    stop_pressed  <= NOT KEY3;
    LED <= led_on;

    -- 1 kHz clock divider using process
    PROCESS(CLOCK_50)
    BEGIN
        IF rising_edge(CLOCK_50) THEN
            IF reset_pressed = '1' THEN
                clk_div_count <= (others => '0');
                one_khz_tick  <= '0';
            ELSIF clk_div_count = to_unsigned(49999, 16) THEN
                clk_div_count <= (others => '0');
                one_khz_tick  <= '1';
            ELSE
                clk_div_count <= clk_div_count + 1;
                one_khz_tick  <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- State machine process
    PROCESS(CLOCK_50)
    BEGIN
        IF rising_edge(CLOCK_50) THEN
            IF reset_pressed = '1' THEN
                wait_counter     <= (others => '0');
                reaction_counter <= (others => '0');
                led_on           <= '0';
                state            <= WAITING;
            ELSE
                CASE state IS
                    WHEN WAITING =>
                        IF (one_khz_tick = '1' AND (unsigned(wait_counter) /= unsigned(SW)))  THEN
                            wait_counter <= std_logic_vector(unsigned(wait_counter) + 1);
                        ELSIF unsigned(wait_counter) = unsigned(SW) THEN
                                led_on <= '1';
                                state  <= COUNTING;
                        END IF;

                    WHEN COUNTING =>
                        IF one_khz_tick = '1' THEN
                            reaction_counter <= std_logic_vector(unsigned(reaction_counter) + 1);
                        END IF;
                        IF stop_pressed = '1' THEN
                            led_on <= '0';
                            state  <= STOPPED;
                        END IF;

                    WHEN STOPPED =>
                        -- Wait for reset to return to WAITING
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- Binary to BCD Conversion + 7-Segment Display
    bcd_converter : binary_to_bcd
        PORT MAP (
            binary_in => reaction_counter,
            digit3    => d3,
            digit2    => d2,
            digit1    => d1,
            digit0    => d0
        );

    seg_display0 : seven_seg_dec PORT MAP(s => d0, hex => HEX0);
    seg_display1 : seven_seg_dec PORT MAP(s => d1, hex => HEX1);
    seg_display2 : seven_seg_dec PORT MAP(s => d2, hex => HEX2);
    seg_display3 : seven_seg_dec PORT MAP(s => d3, hex => HEX3);

END structural;
