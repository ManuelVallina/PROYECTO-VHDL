----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2024 18:27:27
-- Design Name: 
-- Module Name: SelectorDisplay - Behavioral
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

entity accion_cerrado is
    Port (
        clk        : IN std_logic;                     -- Reloj para el selector
        segmentos  : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
        inicio     : IN std_logic;                     -- Señal de inicio
        anodos     : OUT std_logic_vector(7 DOWNTO 0)  -- Control de los ánodos (bit bajo = display activo)
    );
end accion_cerrado;

architecture Behavioral of accion_cerrado is

    signal cuenta    : integer range 0 to 10000000 := 0; -- Ajustar velocidad
    signal seleccion : integer range 0 to 6 := 0;       -- Control de la etapa de la animación
    signal mostrar   : std_logic_vector(7 DOWNTO 0) := "11111111"; -- Ánodos activos
    signal estado    : std_logic_vector(6 DOWNTO 0);    -- Segmentos activos

    -- Patrones para la animación
    constant PATRON_1 : std_logic_vector(6 DOWNTO 0) := "1111110"; -- Primer segmento (barra izquierda)
    constant PATRON_2 : std_logic_vector(6 DOWNTO 0) := "1111101"; -- Añadir barra (dos barras)
    constant PATRON_3 : std_logic_vector(6 DOWNTO 0) := "1111011"; -- Añadir barra (tres barras)
    constant PATRON_4 : std_logic_vector(6 DOWNTO 0) := "1110111"; -- Cuatro barras
    constant PATRON_5 : std_logic_vector(6 DOWNTO 0) := "1101111"; -- Cinco barras
    constant PATRON_6 : std_logic_vector(6 DOWNTO 0) := "1011111"; -- Seis barras
    constant PATRON_7 : std_logic_vector(6 DOWNTO 0) := "1111111"; -- Siete barras (completamente lleno)

begin

    -- Proceso para alternar entre los patrones de animación
    process(clk)
    begin
        if rising_edge(clk) then
            if inicio = '1' then
                if cuenta < 10000000 then -- Ajustar velocidad de la animación
                    cuenta <= cuenta + 1;
                else
                    cuenta <= 0;
                    if seleccion = 6 then
                        seleccion <= 0; -- Reinicia la animación
                    else
                        seleccion <= seleccion + 1; -- Avanza al siguiente patrón
                    end if;
                end if;
            else
                cuenta <= 0;        -- Reinicia el contador si inicio está desactivado
                seleccion <= 0;    -- Reinicia la animación
            end if;
        end if;
    end process;

    -- Proceso para controlar los ánodos y segmentos
    process(seleccion)
    begin
        if inicio = '1' then
            -- Control de los segmentos basado en el patrón actual
            case seleccion is
                when 0 => estado <= PATRON_1; -- Primera barra
                when 1 => estado <= PATRON_2; -- Segunda barra
                when 2 => estado <= PATRON_3; -- Tercera barra
                when 3 => estado <= PATRON_4; -- Cuarta barra
                when 4 => estado <= PATRON_5; -- Quinta barra
                when 5 => estado <= PATRON_6; -- Sexta barra
                when 6 => estado <= PATRON_7; -- Séptima barra
                when others => estado <= "1111111"; -- Todos apagados (fallback)
            end case;

            -- Control de los ánodos: todos activos
            mostrar <= "00000000"; -- Todos los displays encendidos
        else
            -- Apagar todo si inicio está en 0
            estado <= "1111111";   -- Apagar segmentos
            mostrar <= "11111111"; -- Apagar todos los displays
        end if;
    end process;

    -- Asignación de salida
    segmentos <= estado;
    anodos <= mostrar;

end Behavioral;
