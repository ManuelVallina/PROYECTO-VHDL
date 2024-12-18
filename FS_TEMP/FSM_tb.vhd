library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_TB is
end FSM_TB;

architecture Behavioral of FSM_TB is

    -- Componentes
    component FSM
        Port (
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            ACTUAL : out STD_LOGIC_VECTOR(1 downto 0);
            DESEADO : in STD_LOGIC_VECTOR(1 downto 0);
            PUERTA : in STD_LOGIC;
            ACCION_MOTOR : out STD_LOGIC_VECTOR(1 downto 0);
            ACCION_PUERTA : out STD_LOGIC
        );
    end component;

    -- Señales de prueba
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal DESEADO : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal PUERTA : STD_LOGIC := '0';
    signal ACTUAL : STD_LOGIC_VECTOR(1 downto 0);
    signal ACCION_MOTOR : STD_LOGIC_VECTOR(1 downto 0);
    signal ACCION_PUERTA : STD_LOGIC;

    -- Constantes para simulación
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia de la FSM
    DUT: FSM
        port map (
            CLK => CLK,
            RESET => RESET,
            ACTUAL => ACTUAL,
            DESEADO => DESEADO,
            PUERTA => PUERTA,
            ACCION_MOTOR => ACCION_MOTOR,
            ACCION_PUERTA => ACCION_PUERTA
        );

    -- Generador de reloj
    CLK_GEN: process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Proceso de simulación
    STIMULUS: process
    begin
        -- Inicio de simulación
        wait for 50 ns;
        RESET <= '1';    -- Activar RESET
        wait for CLK_PERIOD;
        RESET <= '0';    -- Desactivar RESET

        -- Escenario 1: Validar transiciones normales
        -- Piso actual = 00, DESEADO = 10
        DESEADO <= "10";
        wait for 1u ns;

        -- Simular que la puerta está abierta
        PUERTA <= '1';
        wait for 300 ns;
        PUERTA <= '0';

        -- Esperar suficiente para alcanzar el tiempo del temporizador
        wait for 1 us;

        -- Cambiar el piso deseado para probar otra transición
        DESEADO <= "01";
        wait for 1 us;

        -- Simular que se cierra la puerta
        PUERTA <= '1';
        wait for 300 ns;
        PUERTA <= '0';

        -- Escenario 2: Validar tiempo en estados ABIERTO y CERRADO
        wait for 2 us;

        -- Escenario 3: Probar estado de error
        DESEADO <= "11"; -- Estado inválido
        wait for 1 us;

        -- Fin de la simulación
        wait;
    end process;

end Behavioral;
