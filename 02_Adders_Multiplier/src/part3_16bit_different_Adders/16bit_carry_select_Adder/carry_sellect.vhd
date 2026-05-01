LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY carry_sellect IS
    PORT (
        ain      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input A
        bin      : IN  std_logic_vector(15 DOWNTO 0);  -- 16-bit input B
        cin      : IN  std_logic;                     -- Carry input
        Clock    : IN  std_logic;                     -- Clock signal
        Resetn   : IN  std_logic;                     -- Active-low reset
        sout     : OUT std_logic_vector(15 DOWNTO 0);  -- 16-bit sum output
        overflow : OUT std_logic                     -- Overflow flag
);
 
END carry_sellect;


ARCHITECTURE behavior OF carry_sellect IS


	 
		COMPONENT mult2to1 IS
		  PORT (
        input  : IN  std_logic_vector(1 DOWNTO 0);  
        sel    : IN  STD_LOGIC;                     
        output : OUT STD_LOGIC                      
    );
		END COMPONENT;	 
	 
	 
	 COMPONENT bit_Full_Adder is 
	     PORT (
        ain      : IN  std_logic_vector(3 DOWNTO 0);  
        bin      : IN  std_logic_vector(3 DOWNTO 0);  
        cin      : IN  std_logic;                     
        sout     : OUT std_logic_vector(3 DOWNTO 0);  
        overflow : OUT std_logic                     
			);
			
		END COMPONENT;
		
		COMPONENT mult2to1_4bit IS
		    PORT (
        input0  : IN  std_logic_vector(3 DOWNTO 0);  
		  input1  : IN  std_logic_vector(3 DOWNTO 0);
        sel    : IN  STD_LOGIC;                     
        output : OUT std_logic_vector(3 DOWNTO 0)
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
    SIGNAL QS0   : std_logic_vector(15 DOWNTO 0);       -- for c be zero
    SIGNAL QS1   : std_logic_vector(15 DOWNTO 0);       -- for c be one
    SIGNAL QSS   : std_logic_vector(15 DOWNTO 0);       -- final sum result
    SIGNAL c0   : std_logic := '0';
    SIGNAL c1   : std_logic := '1';	 
    SIGNAL internalcarry0 : std_logic_vector(3 DOWNTO 0); -- for c be zero
    SIGNAL internalcarry1 : std_logic_vector(3 DOWNTO 0);	-- for c be one 
    SIGNAL selected_carry : std_logic_vector(4 DOWNTO 0);	     

	 
 BEGIN
    
	 c0 <= '0';
	 c1 <= '1';
	 
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

	 
	 selected_carry(0) <= cin;

	 
	 	 

	 add0_0 : bit_Full_Adder
	 port map (
	 ain => QA(3 downto 0),
	 bin => QB(3 downto 0),
	 sout => QS0(3 downto 0),
	 cin => c0,
	 overflow => internalcarry0(0)
	 );
	 
	 
	 add0_1 : bit_Full_Adder
	 port map (
	 ain => QA(3 downto 0),
	 bin => QB(3 downto 0),
	 sout => QS1(3 downto 0),
	 cin => c1,
	 overflow => internalcarry1(0)
	 );
	 
	 
	 
	 add1_0 : bit_Full_Adder
	 port map (
	 ain => QA(7 downto 4),
	 bin => QB(7 downto 4),
	 sout => QS0(7 downto 4),
	 	 cin => c0,
		  overflow => internalcarry0(1)
	 );
	 
	  add1_1 : bit_Full_Adder
	 port map (
	 ain => QA(7 downto 4),
	 bin => QB(7 downto 4),
	 sout => QS1(7 downto 4),
	 	 cin => c1,
		  overflow => internalcarry1(1)
	 );
	 
	 	 add2_0: bit_Full_Adder
	 port map (
	 ain => QA(11 downto 8),
	 bin => QB(11 downto 8),
	 sout => QS0(11 downto 8),
	 	 cin => c0,
		  overflow => internalcarry0(2)
	 
	 );
	 
	 	 add2_1: bit_Full_Adder
	 port map (
	 ain => QA(11 downto 8),
	 bin => QB(11 downto 8),
	 sout => QS1(11 downto 8),
	 	 cin => c1,
		  overflow => internalcarry1(2)
	 
	 );
	 	 add3_0: bit_Full_Adder
	 port map (
	 ain => QA(15 downto 12),
	 bin => QB(15 downto 12),
	 sout => QS0(15 downto 12),
	 	 cin => c0,
		  overflow => internalcarry0(3)
	 );	 
	 
	 	 add3_1: bit_Full_Adder
	 port map (
	 ain => QA(15 downto 12),
	 bin => QB(15 downto 12),
	 sout => QS1(15 downto 12),
	 	 cin => c1,
		  overflow => internalcarry1(3)
	 );
	 
	 


	 
	 

	     mux0_4bit : mult2to1_4bit
        PORT MAP (
            input0 => QS0(3 downto 0),      
            input1 => QS1(3 downto 0),      
            sel      => selected_carry(0),      
            output   => QSS(3 downto 0)    
        );
		  
		  
		  
	     mux0 : mult2to1
        PORT MAP (
            input(0) => internalcarry0(0),      
            input(1) => internalcarry1(0),      
            sel      => selected_carry(0),      
            output   => selected_carry(1)    
        );


		  
	     mux1_4bit : mult2to1_4bit
        PORT MAP (
            input0 => QS0(7 downto 4),      
            input1 => QS1(7 downto 4),      
            sel      => selected_carry(1),      
            output   => QSS(7 downto 4)    
        );
		  
		  
		  
	     mux1 : mult2to1
        PORT MAP (
            input(0) => internalcarry0(1),      
            input(1) => internalcarry1(1),      
            sel      => selected_carry(1),      
            output   => selected_carry(2)    
        );		


	     mux2_4bit : mult2to1_4bit
        PORT MAP (
            input0 => QS0(11 downto 8),      
            input1 => QS1(11 downto 8),      
            sel      => selected_carry(2),      
            output   => QSS(11 downto 8)    
        );
		  
		  
		  
	     mux2 : mult2to1
        PORT MAP (
            input(0) => internalcarry0(2),      
            input(1) => internalcarry1(2),      
            sel      => selected_carry(2),      
            output   => selected_carry(3)    
        );	


	     mux3_4bit : mult2to1_4bit
        PORT MAP (
            input0 => QS0(15 downto 12),      
            input1 => QS1(15 downto 12),      
            sel      => selected_carry(3),      
            output   => QSS(15 downto 12)    
        );
		  
		  
		  
	     mux3 : mult2to1
        PORT MAP (
            input(0) => internalcarry0(3),      
            input(1) => internalcarry1(3),      
            sel      => selected_carry(3),      
            output   => selected_carry(4)    
        );	



		
	 
	 
    regnS : regn 
        GENERIC MAP ( N => 16 )
        PORT MAP (
            R      => signed(QSS),   -- Convert QS to signed for registering
            Clock  => Clock,
            Resetn => Resetn,
            Q      => QS_s          -- Registered signed sum
        );

    -- Convert the registered signed sum back to std_logic_vector for output
    sout <= std_logic_vector(QS_s);


    ff0 : flipflop PORT MAP (
        D      => selected_carry(4),
        Clock  => Clock,
        Resetn => Resetn,
        Q      => overflow
    );



END behavior;

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 