LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TOP_tb IS
END TOP_tb;

ARCHITECTURE behavior OF TOP_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT TOP
    PORT(
         CLK : IN std_logic;
         RST : IN std_logic;
         botones_IN : IN std_logic_vector(3 downto 0);
         led_motor : OUT std_logic_vector(1 downto 0);
         led_puerta : OUT std_logic;
         ACTUAL_FSM : OUT std_logic_vector(1 downto 0);
         acc_motor_tb : OUT std_logic_vector(1 downto 0);
         acc_puerta_tb : OUT std_logic;
         objetivo_tb : OUT std_logic_vector(1 downto 0);
         piso_selec_tb: out std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    
    -- Signals for testbench
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal botones_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal led_motor : std_logic_vector(1 downto 0);
    signal led_puerta : std_logic;
    signal ACTUAL_FSM : std_logic_vector(1 downto 0);
    signal acc_motor_tb : std_logic_vector(1 downto 0);
    signal acc_puerta_tb : std_logic;
    signal objetivo_tb : std_logic_vector(1 downto 0);
    signal piso_selec_tb:  std_logic_vector(1 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: TOP PORT MAP (
          CLK => CLK,
          RST => RST,
          botones_IN => botones_IN,
          led_motor => led_motor,
          led_puerta => led_puerta,
          ACTUAL_FSM => ACTUAL_FSM,
          acc_motor_tb => acc_motor_tb,
          acc_puerta_tb => acc_puerta_tb,
          objetivo_tb => objetivo_tb,
          piso_selec_tb => piso_selec_tb
        );

    -- Clock process
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset the system
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 20 ns;

        -- Test case 1: Select floor 1
        botones_IN <= "0001";
        wait for 5000 ns;

        -- Test case 2: Select floor 2
        botones_IN <= "0010";
        wait for 5000 ns;

        -- Test case 3: Select floor 3
        botones_IN <= "0100";
        wait for 5000 ns;

        -- Test case 4: Select floor 4
        botones_IN <= "1000";
        wait for 5000 ns;

        -- Test case 5: Reset system during operation
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 5000 ns;

        -- Test case 6: Invalid button press (all high)
        botones_IN <= "1111";
        wait for 5000 ns;

        -- Simulation ends
        wait;
    end process;

END;
