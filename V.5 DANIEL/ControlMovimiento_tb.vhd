----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2024 19:00:34
-- Design Name: 
-- Module Name: ControlMovimiento_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlMovimiento_tb is
    -- El test bench no tiene puertos
end ControlMovimiento_tb;

architecture testbench of ControlMovimiento_tb is
    -- Declaración del componente
    component ControlMovimiento
        Port (
            ACCION_MOTOR : in STD_LOGIC_VECTOR(1 downto 0);
            motor : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Señales para estimular y verificar
    signal ACCION_MOTOR_tb : STD_LOGIC_VECTOR(1 downto 0);
    signal motor_tb : STD_LOGIC_VECTOR(1 downto 0);

begin
    -- Instanciar el módulo bajo prueba (UUT)
    uut: ControlMovimiento
        port map (
            ACCION_MOTOR => ACCION_MOTOR_tb,
            motor => motor_tb
        );

    -- Proceso de estímulos
    process
    begin
        -- Caso 1: ACCION_MOTOR = "00" --> motor = "00" (Parado)
        ACCION_MOTOR_tb <= "00";
        wait for 10 ns;
        assert (motor_tb = "00") 
            report "Fallo en Caso 1: motor debería ser '00' (Parado)" severity error;

        -- Caso 2: ACCION_MOTOR = "01" --> motor = "01" (Subiendo)
        ACCION_MOTOR_tb <= "01";
        wait for 10 ns;
        assert (motor_tb = "01") 
            report "Fallo en Caso 2: motor debería ser '01' (Subiendo)" severity error;

        -- Caso 3: ACCION_MOTOR = "10" --> motor = "10" (Bajando)
        ACCION_MOTOR_tb <= "10";
        wait for 10 ns;
        assert (motor_tb = "10") 
            report "Fallo en Caso 3: motor debería ser '10' (Bajando)" severity error;

        -- Caso 4: ACCION_MOTOR = "11" --> motor = "00" (Parado por defecto)
        ACCION_MOTOR_tb <= "11";
        wait for 10 ns;
        assert (motor_tb = "00") 
            report "Fallo en Caso 4: motor debería ser '00' (Parado por defecto)" severity error;

        -- Finalización del test
        report "Test completado con éxito. Todos los casos pasaron." severity note;
        wait; -- Detener la simulación
    end process;

end testbench;


