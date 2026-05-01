LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder7 IS
    PORT (
        C : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Display : OUT STD_LOGIC_VECTOR(0 to 6)
    );
END decoder7;

ARCHITECTURE Behavior OF decoder7 IS
BEGIN
    PROCESS (C)
    BEGIN
		  Display <= "1111111";	-- Reducing undefined errors in the Time simulation
        IF C = "000" THEN Display <= "1001000"; -- Display 'H'
        ELSIF C = "001" THEN Display <= "0110000"; -- Display 'E'
        ELSIF C = "010" THEN Display <= "1110001"; -- Display 'L'
        ELSIF C = "011" THEN Display <= "0000001"; -- Display 'O'
		  ELSIF C = "100" THEN Display <= "0110001"; -- Display 'C'
		  ELSIF C = "101" THEN Display <= "0011000"; -- Display 'P'
		  ELSIF C = "110" THEN Display <= "0111000"; -- Display 'F'
        ELSE Display <= "1111111"; -- Default blank
        END IF;
    END PROCESS;
END Behavior;