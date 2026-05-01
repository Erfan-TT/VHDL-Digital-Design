LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity propagate is
    PORT (
        apin : IN std_logic_vector(3 downto 0);
        bpin : IN std_logic_vector(3 downto 0);
        pout : OUT std_logic
    );
end entity;

architecture behavior of propagate is
    signal Pint : std_logic_vector(3 downto 0);
begin

    Pint(0) <= apin(0) XOR bpin(0);
    Pint(1) <= apin(1) XOR bpin(1);
    Pint(2) <= apin(2) XOR bpin(2);
    Pint(3) <= apin(3) XOR bpin(3);

    pout <= Pint(0) and Pint(1) and Pint(2) and Pint(3);

end behavior;
