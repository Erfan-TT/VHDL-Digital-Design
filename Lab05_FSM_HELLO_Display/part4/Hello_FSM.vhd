library ieee;
use ieee.std_logic_1164.all;

entity Hello_FSM is
    port (
        KEY      : in  std_logic_vector(3 downto 0);
        CLOCK_50 : in  std_logic;
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
    );
end Hello_FSM;

architecture behavior of Hello_FSM is

    -- Components
    component one_hz_counter is
        port (
            Enable : in  std_logic;
            clk    : in  std_logic;
            Clear  : in  std_logic;
            TC     : out std_logic
        );
    end component;

    component seven_bit_register is
        port (
            R      : in  std_logic_vector(6 downto 0);
            reset  : in  std_logic;
            clk    : in  std_logic;
            enable : in  std_logic;
            Q      : out std_logic_vector(6 downto 0)
        );
    end component;

    -- State type
    type scroll_state is (S_H, S_E, S_L1, S_L2, S_O, S_BLANK, S_LOOP);
    signal present_state, next_state : scroll_state;

    -- 7-segment values
    constant SEG_H     : std_logic_vector(6 downto 0) := "0001001";
    constant SEG_E     : std_logic_vector(6 downto 0) := "0000110";
    constant SEG_L     : std_logic_vector(6 downto 0) := "1000111";
    constant SEG_O     : std_logic_vector(6 downto 0) := "1000000";
    constant SEG_SPACE : std_logic_vector(6 downto 0) := "1111111";

    -- Signals
    signal char_input : std_logic_vector(6 downto 0);
    signal resetn     : std_logic;
    signal pulse_1hz  : std_logic;
    signal enable_1hz : std_logic := '0';

    -- Pipeline register data
    signal stage0, stage1, stage2, stage3, stage4, stage5 : std_logic_vector(6 downto 0);

begin

    resetn <= not KEY(0);

    -- One Hz Counter Instance
    counter_inst : one_hz_counter
        port map (
            Enable => enable_1hz,
            clk    => CLOCK_50,
            Clear  => resetn,
            TC     => pulse_1hz
        );

    -- FSM: State Register
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if resetn = '1' then
                present_state <= S_H;
                enable_1hz <= '1';
            elsif pulse_1hz = '1' then
                present_state <= next_state;
            end if;
        end if;
    end process;

    -- FSM: Next-State Logic
    process(present_state)
    begin
        case present_state is
            when S_H     => next_state <= S_E;
            when S_E     => next_state <= S_L1;
            when S_L1    => next_state <= S_L2;
            when S_L2    => next_state <= S_O;
            when S_O     => next_state <= S_BLANK;
            when S_BLANK => next_state <= S_LOOP;
            when S_LOOP  => next_state <= S_LOOP;
            when others  => next_state <= S_H;
        end case;
    end process;

    -- FSM: Output Logic
    process(present_state)
    begin
        case present_state is
            when S_H     => char_input <= SEG_H;
            when S_E     => char_input <= SEG_E;
            when S_L1    => char_input <= SEG_L;
            when S_L2    => char_input <= SEG_L;
            when S_O     => char_input <= SEG_O;
            when S_BLANK => char_input <= SEG_SPACE;
            when S_LOOP  => char_input <= stage5;
            when others  => char_input <= SEG_SPACE;
        end case;
    end process;

    -- Pipeline Register Instantiations
    stage0_reg: seven_bit_register port map (R => char_input, reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage0);
    stage1_reg: seven_bit_register port map (R => stage0,     reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage1);
    stage2_reg: seven_bit_register port map (R => stage1,     reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage2);
    stage3_reg: seven_bit_register port map (R => stage2,     reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage3);
    stage4_reg: seven_bit_register port map (R => stage3,     reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage4);
    stage5_reg: seven_bit_register port map (R => stage4,     reset => resetn, clk => CLOCK_50, enable => pulse_1hz, Q => stage5);

    -- Output HEX Assignments
    process(stage0, stage1, stage2, stage3, stage4, stage5)
    begin
        HEX0 <= stage0;
        HEX1 <= stage1;
        HEX2 <= stage2;
        HEX3 <= stage3;
        HEX4 <= stage4;
        HEX5 <= stage5;
    end process;

end behavior;
