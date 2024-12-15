library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_TB is
end FSM_TB;

architecture Behavioral of FSM_TB is
    -- Component declaration
    component FSM
        Port (
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            ACTUAL : inout STD_LOGIC_VECTOR(1 downto 0);
            DESEADO : in STD_LOGIC_VECTOR(1 downto 0);
            PUERTA : in std_logic;
            ACCION_MOTOR : out std_logic_vector(1 downto 0);
            ACCION_PUERTA : out std_logic
        );
    end component;

    -- Signals
    signal CLK_TB : STD_LOGIC := '0';
    signal RESET_TB : STD_LOGIC := '0';
    signal ACTUAL_TB : STD_LOGIC_VECTOR(1 downto 0);
    signal DESEADO_TB : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal PUERTA_TB : STD_LOGIC := '0';
    signal ACCION_MOTOR_TB : STD_LOGIC_VECTOR(1 downto 0);
    signal ACCION_PUERTA_TB : STD_LOGIC;

    -- Clock period in nanoseconds
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the FSM
    DUT: FSM
        port map (
            CLK => CLK_TB,
            RESET => RESET_TB,
            ACTUAL => ACTUAL_TB,
            DESEADO => DESEADO_TB,
            PUERTA => PUERTA_TB,
            ACCION_MOTOR => ACCION_MOTOR_TB,
            ACCION_PUERTA => ACCION_PUERTA_TB
        );

    -- Clock process
    CLK_PROCESS : process
    begin
        while true loop
            CLK_TB <= '0';
            wait for CLK_PERIOD / 2; -- 5 ns
            CLK_TB <= '1';
            wait for CLK_PERIOD / 2; -- 5 ns
        end loop;
    end process;

    -- Stimulus process
    STIMULUS_PROCESS : process
    begin
        -- Step 1: Reset FSM
        report "Step 1: Reset FSM";
        RESET_TB <= '1';
        PUERTA_TB <= '0';
        wait for 20 ns;
        RESET_TB <= '0';
        wait for 20 ns;

        -- Step 2: Go to floor "01"
        report "Step 2: Go to floor 01";
        DESEADO_TB <= "01";
        wait for 100 ns;

        -- Step 3: Door opens at floor 01
        report "Step 3: Open door at floor 01";
        PUERTA_TB <= '1';
        wait for 50 ns;

        -- Step 4: Close the door and go to floor "10"
        report "Step 4: Close door and go to floor 10";
        PUERTA_TB <= '0';
        DESEADO_TB <= "10";
        wait for 100 ns;

        -- Step 5: Door opens at floor 10
        report "Step 5: Open door at floor 10";
        PUERTA_TB <= '1';
        wait for 50 ns;

        -- Step 6: Close the door and go back to floor "00"
        report "Step 6: Close door and go to floor 00";
        PUERTA_TB <= '0';
        DESEADO_TB <= "00";
        wait for 100 ns;

        -- Step 7: Invalid floor "11"
        report "Step 7: Invalid floor 11 - FSM should handle ERROR state";
        DESEADO_TB <= "11";
        wait for 100 ns;

        -- Step 8: Reset FSM
        report "Step 8: Reset FSM";
        RESET_TB <= '1';
        wait for 20 ns;
        RESET_TB <= '0';
        wait for 50 ns;

        -- Finish simulation
        report "Simulation complete.";
        wait;
    end process;

    -- Monitoring process for outputs
   
end Behavioral;
