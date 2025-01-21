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

entity Accion_marcha is
Port ( 
    clk        : IN std_logic;                     -- Reloj para el selector
    inicio     : IN std_logic;                     -- Señal de inicio
    segmentos  : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
    anodos     : OUT std_logic_vector(7 DOWNTO 0); -- Control de los ánodos (bit bajo = display activo)
    NUM        : IN std_logic_vector(6 DOWNTO 0)   -- Valor a mostrar
);
end Accion_marcha;

architecture Behavioral of Accion_marcha is

    signal cuenta   : integer range 0 to 30000000; -- con dos ceros más se ajusta la velocidad 10000000
    signal seleccion : std_logic_vector (2 downto 0) := "000";
    signal mostrar  : std_logic_vector (7 downto 0) := "00000000";

begin

    -- Proceso para alternar entre displays solo si inicio está activo
    process(clk)
    begin
        if rising_edge(clk) then
            if inicio = '1' then
                if cuenta < 30000000 then -- Ajustar velocidad 10000000
                    cuenta <= cuenta + 1;
                else
                    seleccion <= std_logic_vector(to_unsigned(to_integer(unsigned(seleccion)) + 1, 3)); -- Incremento de seleccion
                    cuenta <= 0;
                end if;
            else
                cuenta <= 0; -- Reset de cuenta si inicio está en 0
                seleccion <= "000"; -- Reset de selección si inicio está en 0
            end if;
        end if;
    end process;

    -- Control de los ánodos y segmentos solo si inicio está activo
    process(seleccion, inicio)
    begin
        if inicio = '1' then
            -- Selección de ánodos
            case seleccion is
                when "000" => mostrar <= "11111110";
                when "001" => mostrar <= "11111101";
                when "010" => mostrar <= "11111011";
                when "011" => mostrar <= "11110111";
                when "100" => mostrar <= "11101111";
                when "101" => mostrar <= "11011111";
                when "110" => mostrar <= "10111111";
                when "111" => mostrar <= "01111111";
                when others => mostrar <= "11111111";
            end case;

            -- Selección de segmentos
            case mostrar is
                when "11111110" => segmentos <= NUM;
                when "11111101" => segmentos <= NUM;
                when "11111011" => segmentos <= NUM;
                when "11110111" => segmentos <= NUM;
                when "11101111" => segmentos <= NUM;
                when "11011111" => segmentos <= NUM;
                when "10111111" => segmentos <= NUM;
                when "01111111" => segmentos <= NUM;
                when others => segmentos <= "1111111"; -- Todos apagados
            end case;
        else
            -- Si inicio está en 0, apagar segmentos y ánodos
            mostrar <= "11111111";
            segmentos <= "1111111"; -- Todos apagados
        end if;
    end process;

    -- Asignación de salida
    anodos <= mostrar;

end Behavioral;

