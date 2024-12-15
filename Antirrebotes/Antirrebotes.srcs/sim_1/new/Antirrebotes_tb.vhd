----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 11:07:17
-- Design Name: 
-- Module Name: Antirrebotes_tb - Behavioral
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

entity Antirrebotes_tb is
-- No hay puertos en el testbench porque es un banco de pruebas
end Antirrebotes_tb;

architecture Behavioral of Antirrebotes_tb is

    -- Señales locales para conectar con el módulo bajo prueba (UUT)
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal logic_IN : std_logic := '0';
    signal logic_OUT : std_logic;

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 20 ns; -- Reloj de 50 MHz

begin

    -- Instancia del módulo Antirrebotes
    UUT: entity work.Antirrebotes
        port map (
            CLK => CLK,
            logic_IN => logic_IN,
            logic_OUT => logic_OUT,
            RST => RST
        );

    -- Generador de reloj
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos para probar el filtro antirrebote
    stimulus_process : process
    begin
        -- 1. Reset inicial
        RST <= '1';
        wait for 2 * CLK_PERIOD;
        RST <= '0';

        -- 2. Simular botón presionado con rebotes
        logic_IN <= '0';
        wait for 50 ns;
        logic_IN <= '1';  -- Comienza el rebote
        wait for 10 ns;
        logic_IN <= '0';
        wait for 10 ns;
        logic_IN <= '1';
        wait for 10 ns;
        logic_IN <= '0';
        wait for 10 ns;
        logic_IN <= '1'; -- Finalmente estable
        wait for 1 ms; -- Esperar tiempo suficiente para estabilización

        -- 3. Simular botón liberado con rebotes
        logic_IN <= '0';  -- Comienza el rebote al soltar el botón
        wait for 10 ns;
        logic_IN <= '1';
        wait for 10 ns;
        logic_IN <= '0';
        wait for 10 ns;
        logic_IN <= '1';
        wait for 10 ns;
        logic_IN <= '0'; -- Finalmente estable
        wait for 1 ms; -- Esperar tiempo suficiente para estabilización

        -- Finalizar simulación
        wait;
    end process;

end Behavioral;

