library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_display_control is
-- No ports: es un banco de pruebas.
end tb_display_control;

architecture Behavioral of tb_display_control is

    -- Component declaration del DUT (Device Under Test)
    component display_control
        Port ( 
            CLK : in STD_LOGIC;
            piso_actual_detected : in STD_LOGIC_VECTOR(1 downto 0);
            piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
            piso_selected : out STD_LOGIC_VECTOR(1 downto 0);
            piso_actual : out STD_LOGIC_VECTOR(1 downto 0);
            movimiento : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Señales para conectar al DUT
    signal CLK : STD_LOGIC := '0';
    signal piso_actual_detected : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal piso_deseado : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal piso_selected : STD_LOGIC_VECTOR(1 downto 0);
    signal piso_actual : STD_LOGIC_VECTOR(1 downto 0);
    signal movimiento : STD_LOGIC_VECTOR(1 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT
    uut: display_control
        Port map (
            CLK => CLK,
            piso_actual_detected => piso_actual_detected,
            piso_deseado => piso_deseado,
            piso_selected => piso_selected,
            piso_actual => piso_actual,
            movimiento => movimiento
        );

    -- Proceso para generar el reloj
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Estímulos de prueba
    stim_process : process
    begin
        -- Caso 1: piso_actual_detected = "00", piso_deseado = "00"
        piso_actual_detected <= "00";
        piso_deseado <= "00";
        wait for 20 ns;

        -- Caso 2: piso_actual_detected = "01", piso_deseado = "10"
        piso_actual_detected <= "01";
        piso_deseado <= "10";
        wait for 20 ns;

        -- Caso 3: piso_actual_detected = "10", piso_deseado = "01"
        piso_actual_detected <= "10";
        piso_deseado <= "01";
        wait for 20 ns;

        -- Caso 4: piso_actual_detected = "11", piso_deseado = "11"
        piso_actual_detected <= "11";
        piso_deseado <= "11";
        wait for 20 ns;

        -- Terminar la simulación
        wait;
    end process;

end Behavioral;

