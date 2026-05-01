-- binary_to_bcd.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY binary_to_bcd IS
    PORT (
        binary_in  : IN  std_logic_vector(15 DOWNTO 0);
        digit3     : OUT std_logic_vector(3 DOWNTO 0); -- Thousands
        digit2     : OUT std_logic_vector(3 DOWNTO 0); -- Hundreds
        digit1     : OUT std_logic_vector(3 DOWNTO 0); -- Tens
        digit0     : OUT std_logic_vector(3 DOWNTO 0)  -- Units
    );
END binary_to_bcd;

ARCHITECTURE Behavioral OF binary_to_bcd IS
    SIGNAL bcd : unsigned(19 DOWNTO 0); -- 5 digits x 4 bits = 20 bits
BEGIN
    PROCESS(binary_in)
        VARIABLE temp_bcd : unsigned(19 DOWNTO 0) := (others => '0');
        VARIABLE bin      : unsigned(15 DOWNTO 0);
        VARIABLE digit0_v, digit1_v, digit2_v, digit3_v : unsigned(3 DOWNTO 0);
    BEGIN
        bin := unsigned(binary_in);
        temp_bcd := (others => '0');

        -- Shift and add-3 algorithm (Double Dabble)
        FOR i IN 15 DOWNTO 0 LOOP
            -- Check each 4-bit group and add 3 if >= 5
            digit0_v := temp_bcd(3 DOWNTO 0);
            IF digit0_v > 4 THEN
                digit0_v := digit0_v + 3;
            END IF;
            temp_bcd(3 DOWNTO 0) := digit0_v;

            digit1_v := temp_bcd(7 DOWNTO 4);
            IF digit1_v > 4 THEN
                digit1_v := digit1_v + 3;
            END IF;
            temp_bcd(7 DOWNTO 4) := digit1_v;

            digit2_v := temp_bcd(11 DOWNTO 8);
            IF digit2_v > 4 THEN
                digit2_v := digit2_v + 3;
            END IF;
            temp_bcd(11 DOWNTO 8) := digit2_v;

            digit3_v := temp_bcd(15 DOWNTO 12);
            IF digit3_v > 4 THEN
                digit3_v := digit3_v + 3;
            END IF;
            temp_bcd(15 DOWNTO 12) := digit3_v;

            -- Shift left and bring in next binary bit
            temp_bcd := temp_bcd(18 DOWNTO 0) & bin(15 - i);
        END LOOP;

        bcd <= temp_bcd;
    END PROCESS;

    digit3 <= std_logic_vector(bcd(15 DOWNTO 12)); -- Thousands
    digit2 <= std_logic_vector(bcd(11 DOWNTO 8));  -- Hundreds
    digit1 <= std_logic_vector(bcd(7 DOWNTO 4));   -- Tens
    digit0 <= std_logic_vector(bcd(3 DOWNTO 0));   -- Units

END Behavioral;
