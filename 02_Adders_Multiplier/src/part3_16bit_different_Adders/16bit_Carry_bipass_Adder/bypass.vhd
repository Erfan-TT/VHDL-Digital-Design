LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY bypass IS
    PORT (
        ain      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input A
        bin      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input B
        cin      : IN  std_logic;                     -- Carry input
        Clock    : IN  std_logic;                     -- Clock signal
        Resetn   : IN  std_logic;                     -- Active-low reset
        sout     : OUT std_logic_vector(15 DOWNTO 0);  -- 16-bit sum output
        overflow : OUT std_logic                     -- Overflow flag
);
 
END bypass;


ARCHITECTURE behavior OF bypass IS

    COMPONENT propagate IS  
	 
	 PORT (
	  apin	 : IN std_logic_vector (3 downto 0);
	  bpin 	 : IN std_logic_vector (3 downto 0);
	  pout 	 : out std_logic
	 
	 );
	 
	 END COMPONENT;
	 
	 COMPONENT bit_Full_Adder is 
	     PORT (
        ain      : IN  std_logic_vector(3 DOWNTO 0);  
        bin      : IN  std_logic_vector(3 DOWNTO 0);  
        cin      : IN  std_logic;                     -- Carry input
        sout     : OUT std_logic_vector(3 DOWNTO 0);  -- 4-bit sum output
        overflow : OUT std_logic                     -- Overflow flag
			);
			
		END COMPONENT;
		
		COMPONENT mult2to1 IS
		    PORT (
        input  : IN  std_logic_vector(1 DOWNTO 0);  -- Two input signals
        sel    : IN  STD_LOGIC;                     -- Select signal
        output : OUT STD_LOGIC                      -- Output signal
    );
	 
		END COMPONENT;
		
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
            a     : IN  std_logic;   -- Input bit a
            b     : IN  std_logic;   -- Input bit b
            c     : IN  std_logic;   -- Carry input
            sum   : OUT std_logic;   -- Sum output
            carry : OUT std_logic    -- Carry output
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
    SIGNAL QA, QB : std_logic_vector(15 DOWNTO 0);   -- Conversion from signed to std_logic_vector
    SIGNAL QS   : std_logic_vector(15 DOWNTO 0);       -- Sum from the full adder chain (before re-registering)
    SIGNAL internalcarry : std_logic_vector(3 DOWNTO 0);
    SIGNAL internalcarryselected : std_logic_vector(4 DOWNTO 0);	 
    
	 SIGNAL propagation : std_logic_vector(3 DOWNTO 0);
	 
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

	 
	 internalcarryselected(0) <= cin;
	 
	 prop0 : propagate
	 port map (
	 apin => QA(3 downto 0),
	 bpin => QB(3 downto 0),
	 pout => propagation(0)
	 );
	 
	 	 prop1 : propagate
	 port map (
	 apin => QA(7 downto 4),
	 bpin => QB(7 downto 4),
	 pout => propagation(1)
	 );
	 
	 	 prop2 : propagate
	 port map (
	 apin => QA(11 downto 8),
	 bpin => QB(11 downto 8),
	 pout => propagation(2)
	 );
	 
	 	 prop3 : propagate
	 port map (
	 apin => QA(15 downto 12),
	 bpin => QB(15 downto 12),
	 pout => propagation(3)
	 );

	 
	 

	 add0 : bit_Full_Adder
	 port map (
	 ain => QA(3 downto 0),
	 bin => QB(3 downto 0),
	 sout => QS(3 downto 0),
	 cin => internalcarryselected(0),
	 overflow => internalcarry(0)
	 );
	 
	 	 add1 : bit_Full_Adder
	 port map (
	 ain => QA(7 downto 4),
	 bin => QB(7 downto 4),
	 sout => QS(7 downto 4),
	 	 cin => internalcarryselected(1),
		  overflow => internalcarry(1)
	 );
	 
	 	 add2: bit_Full_Adder
	 port map (
	 ain => QA(11 downto 8),
	 bin => QB(11 downto 8),
	 sout => QS(11 downto 8),
	 	 cin => internalcarryselected(2),
		  overflow => internalcarry(2)
	 
	 );
	 
	 	 add3: bit_Full_Adder
	 port map (
	 ain => QA(15 downto 12),
	 bin => QB(15 downto 12),
	 sout => QS(15 downto 12),
	 	 cin => internalcarryselected(3),
		  overflow => internalcarry(3)
	 );	 
	 
	 
	 

	     mux0 : mult2to1
        PORT MAP (
            input(0) => internalcarry(0),      
            input(1) => internalcarryselected(0),      
            sel      => propagation(0),      
            output   => internalcarryselected(1)    
        );


	     mux1 : mult2to1
        PORT MAP (
            input(0) => internalcarry(1),      
            input(1) => internalcarryselected(1),      
            sel      => propagation(1),      
            output   => internalcarryselected(2)    
        );
	 
	     mux2 : mult2to1
        PORT MAP (
            input(0) => internalcarry(2) ,      
            input(1) => internalcarryselected(2),      
            sel      => propagation(2),      
            output   => internalcarryselected(3)    
        );	 
	 
	 
	     mux3 : mult2to1
        PORT MAP (
            input(0) => internalcarry(3),      
            input(1) => internalcarryselected(3),      
            sel      => propagation(3),      
            output   => internalcarryselected(4)    
        );	 
	 
	 
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


    ff0 : flipflop PORT MAP (
        D      => internalcarryselected(4),
        Clock  => Clock,
        Resetn => Resetn,
        Q      => overflow
    );



END behavior;

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 