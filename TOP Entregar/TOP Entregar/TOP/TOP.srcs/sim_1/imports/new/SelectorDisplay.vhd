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

entity SelectorDisplay is
Port ( 
    clk     : IN std_logic;                     -- Reloj para el selector
    reset   : IN std_logic;                     -- Reset para el selector
    piso_actual : IN std_logic_vector(1 DOWNTO 0); -- Piso actual a mostrar
    segmentos   : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
    anodos      : OUT std_logic_vector(3 DOWNTO 0)  -- Control de los ánodos (bit bajo = display activo)
);
end SelectorDisplay;

architecture Behavioral of SelectorDisplay is

    -- Contador para alternar entre displays
    signal sel_dis : std_logic_vector(1 DOWNTO 0) := "00"; -- 2 bits para seleccionar 1 de los 4 displays
    signal segmentos_int : std_logic_vector(6 DOWNTO 0);   -- Segmentos internos
    signal anodos_int : std_logic_vector(3 DOWNTO 0) := "1111"; -- Todos los displays apagados inicialmente

    -- Decodificador de piso a segmentos
    function decode_7seg(piso : std_logic_vector(1 DOWNTO 0)) return std_logic_vector is
    begin
        case piso is
            when "00" => return "1000000"; -- 0
            when "01" => return "1111001"; -- 1
            when "10" => return "0100100"; -- 2
            when "11" => return "0110000"; -- 3
            when others => return "1111111"; -- Apagado
        end case;
    end decode_7seg;

begin

    -- Proceso para alternar entre displays
    process(clk, reset)
    begin
        if reset = '1' then
            sel_dis <= "00";
        elsif rising_edge(clk) then
            sel_dis <= std_logic_vector(unsigned(sel_dis) + 1); -- Incrementa de manera cíclica
        end if;
    end process;

    -- Control de los ánodos y segmentos
    process(sel_dis, piso_actual, reset)
    begin
        if reset = '1' then
            anodos_int <= "1111"; -- Todos apagados
            segmentos_int <= "1111111"; -- Segmentos apagados
        else
            case sel_dis is
                when "00" => 
                    anodos_int <= "1110"; -- Display 1 activo
                    segmentos_int <= decode_7seg(piso_actual);
                when "01" => 
                    anodos_int <= "1101"; -- Display 2 activo
                    segmentos_int <= decode_7seg(piso_actual);
                when "10" => 
                    anodos_int <= "1011"; -- Display 3 activo
                    segmentos_int <= decode_7seg(piso_actual);
                when "11" => 
                    anodos_int <= "0111"; -- Display 4 activo
                    segmentos_int <= decode_7seg(piso_actual);
                when others => 
                    anodos_int <= "1111"; -- Todos apagados por seguridad
                    segmentos_int <= "1111111"; -- Segmentos apagados
            end case;
        end if;
    end process;

    -- Asignación de salidas
    segmentos <= segmentos_int;
    anodos <= anodos_int;

end Behavioral;

