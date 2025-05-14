LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY two_process_FSM IS
    PORT (
        SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);   -- SW(1): input w, SW(0): active-low reset
        KEY  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- KEY(0): manual clock
        LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)    -- LEDR(0): output z
    );
END two_process_FSM;

ARCHITECTURE behaviour OF two_process_FSM IS

    TYPE State_type IS (A, B, C, D, E, F, G, H, I);
    SIGNAL CS, FS : State_type;         -- CS: current state, FS: next state
    SIGNAL w, reset, clk, z : STD_LOGIC;

BEGIN
    -- Input mappings
    w     <= SW(1);
    reset <= SW(0);        -- Active-low reset
    clk   <= KEY(0);       -- Clock input

    -- Output assignments
    LEDR(0)            <= z;                 -- Output z
    LEDR(9 DOWNTO 1)   <= (OTHERS => '0');   -- Unused LEDs off

    -- Clocked process: updates current state on rising clock edge
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '0' THEN
                CS <= A;                     -- Reset to state A
            ELSE
                CS <= FS;                    -- Transition to next state
            END IF;
        END IF;
    END PROCESS;

    -- Combinational process: determines next state based on current state and input w
    PROCESS(w, CS)
    BEGIN
        CASE CS IS
            WHEN A =>
                IF w = '0' THEN FS <= B;
                ELSE           FS <= F;
                END IF;

            WHEN B =>
                IF w = '0' THEN FS <= C;
                ELSE           FS <= F;
                END IF;
            WHEN C =>
                IF w = '0' THEN FS <= D;
                ELSE           FS <= F;
                END IF;
           WHEN D =>
                IF w = '0' THEN FS <= E;
                ELSE           FS <= F;
                END IF;
           WHEN E =>
                IF w = '0' THEN FS <= E;
                ELSE           FS <= F;
                END IF;
           WHEN F =>
                IF w = '0' THEN FS <= B;
                ELSE           FS <= G;
                END IF;
           WHEN G =>
                IF w = '0' THEN FS <= B;
                ELSE           FS <= H;
                END IF;
           WHEN H =>
                IF w = '0' THEN FS <= B;
                ELSE           FS <= I;
                END IF;
           WHEN I =>
                IF w = '0' THEN FS <= B;
                ELSE           FS <= I;
                END IF;

            WHEN OTHERS =>
                FS <= A;
        END CASE;
    END PROCESS;

    -- Output logic: sets z high in states E and I
    PROCESS(CS)
    BEGIN
        CASE CS IS
            WHEN E =>
                z <= '1';
            WHEN I =>
                z <= '1';
            WHEN OTHERS =>
                z <= '0';
        END CASE;
    END PROCESS;
END behaviour;
