
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 11:54:51
-- Design Name: 
-- Module Name: BotoneraAntirrebotes_tb - Behavioral
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

entity BotoneraAntirrebotes_tb is
-- No tiene puertos, ya que es un banco de pruebas
end BotoneraAntirrebotes_tb;

architecture Behavioral of BotoneraAntirrebotes_tb is

    -- Señales locales para conectar con la unidad bajo prueba (UUT)
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal botones_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal botones_OUT : std_logic_vector(3 downto 0);

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 20 ns; -- 50 MHz

begin

    -- Instancia del módulo bajo prueba (UUT)
    UUT: entity work.BotoneraAntirrebotes
        port map (
            CLK => CLK,
            RST => RST,
            BotonIN => botones_IN,
            BotonOUT => botones_OUT
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

    -- Proceso de estímulos para la botonera
    stimulus_process : process
    begin
        -- 1. Reset inicial
        RST <= '1';
        wait for 2 * CLK_PERIOD;
        RST <= '0';

        -- 2. Simulación de pulsación con rebotes en el botón 0
        botones_IN(0) <= '0';
        wait for 50 ns;
        botones_IN(0) <= '1'; -- Comienza rebote
        wait for 10 ns;
        botones_IN(0) <= '0';
        wait for 10 ns;
        botones_IN(0) <= '1';
        wait for 10 ns;
        botones_IN(0) <= '0';
        wait for 10 ns;
        botones_IN(0) <= '1'; -- Finalmente estable
        wait for 60 ns;

        -- 3. Simulación de pulsación con rebotes en el botón 1
        botones_IN(1) <= '0';
        wait for 50 ns;
        botones_IN(1) <= '1'; -- Comienza rebote
        wait for 10 ns;
        botones_IN(1) <= '0';
        wait for 10 ns;
        botones_IN(1) <= '1';
        wait for 10 ns;
        botones_IN(1) <= '0';
        wait for 10 ns;
        botones_IN(1) <= '1'; -- Finalmente estable
        wait for 60 ns;

        -- 4. Simulación simultánea de pulsaciones en botones 2 y 3
        botones_IN(2) <= '0';
        botones_IN(3) <= '0';
        wait for 50 ns;
        botones_IN(2) <= '1';
        botones_IN(3) <= '1';
        wait for 10 ns;
        botones_IN(2) <= '0';
        botones_IN(3) <= '0';
        wait for 10 ns;
        botones_IN(2) <= '1';
        botones_IN(3) <= '1'; -- Finalmente estables
        wait for 60 ns;

        -- 5. Liberar todos los botones
        botones_IN <= (others => '0');
        wait for 120 ns;

        -- Finalizar simulación
        wait;
    end process;

end Behavioral;

