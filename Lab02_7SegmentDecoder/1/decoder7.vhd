LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder7 IS
    PORT (
        C : IN STD_LOGIC_VECTOR(0 to 2);  -- 3-bit input
        HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)  -- 7-bit output for 7-segment display
    );
END decoder7;

ARCHITECTURE Behavior OF decoder7 IS
BEGIN
    PROCESS (C)
    BEGIN
		  HEX0 <= "1111111";	-- Reducing undefined errors in the Time simulation
        IF C = "000" THEN HEX0 <= "1001000"; -- Display 'H'
        ELSIF C = "001" THEN HEX0 <= "0110000"; -- Display 'E'
        ELSIF C = "010" THEN HEX0 <= "1110001"; -- Display 'L'
        ELSIF C = "011" THEN HEX0 <= "0000001"; -- Display 'O'
        ELSE HEX0 <= "1111111"; -- Default blank
        END IF;
    END PROCESS;
END Behavior;
