library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_TB is
    -- No ports for a testbench
end FSM_TB;

architecture Behavioral of FSM_TB is

    -- Component declaration for the FSM
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

    -- Signals to connect to FSM
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal ACTUAL : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal DESEADO : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal PUERTA : STD_LOGIC := '0';
    signal ACCION_MOTOR : STD_LOGIC_VECTOR(1 downto 0);
    signal ACCION_PUERTA : STD_LOGIC;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the FSM
    uut: FSM
        Port map (
            CLK => CLK,
            RESET => RESET,
            ACTUAL => ACTUAL,
            DESEADO => DESEADO,
            PUERTA => PUERTA,
            ACCION_MOTOR => ACCION_MOTOR,
            ACCION_PUERTA => ACCION_PUERTA
        );

    -- Clock generation
    CLK_PROCESS : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    STIMULUS: process
    begin
        -- Reset the system
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';

        -- Test 1: Validate desired floor within range and open door
        DESEADO <= "01"; -- Set desired floor to 1
        wait for 30 ns;
       -- PUERTA <= '0'; -- Close door
        wait for 50 ns;

        -- Test 2: Move to floor 2
        DESEADO <= "10";
        wait for 70 ns;

        -- Test 3: Error case - invalid desired floor
        DESEADO <= "11"; -- Invalid case
        wait for 50 ns;

        -- Test 4: Return to floor 0
        DESEADO <= "00";
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;