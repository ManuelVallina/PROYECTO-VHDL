----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 12:28:43
-- Design Name: 
-- Module Name: SalidaPantalla - Behavioral
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

entity SalidaPantalla is
    Port (
        -- Entradas de las 4 entidades
        segmentos_1 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 1
        anodos_1    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 1

        segmentos_2 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 2
        anodos_2    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 2

        segmentos_3 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 3
        anodos_3    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 3
        
        segmentos_4 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 3
        anodos_4   : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 3

       
        -- Señal de control para seleccionar la entidad activa
        seleccion   : IN std_logic_vector(1 DOWNTO 0); -- Selección: 00, 01, 10, 11

        -- Salidas combinadas
        segmentos   : OUT std_logic_vector(6 DOWNTO 0); -- Salida combinada de segmentos
        anodos      : OUT std_logic_vector(7 DOWNTO 0)  -- Salida combinada de ánodos
    );
end SalidaPantalla;

architecture Behavioral of SalidaPantalla is
begin
    -- Multiplexor para combinar las señales
    process(seleccion, segmentos_1, anodos_1, segmentos_2, anodos_2, segmentos_3, anodos_3,segmentos_4, anodos_4)
    begin
        case seleccion is
            when "00" =>  -- Seleccionar la entidad 1
                segmentos <= segmentos_1;
                anodos    <= anodos_1;
            when "01" =>  -- Seleccionar la entidad 2
                segmentos <= segmentos_2;
                anodos    <= anodos_2;
            when "10" =>  -- Seleccionar la entidad 3
                segmentos <= segmentos_3;
                anodos    <= anodos_3;
            when "11" =>  -- Seleccionar la entidad 3
                segmentos <= segmentos_4;
                anodos    <= anodos_4;
            when others => -- Apagar todas las señales por defecto
                segmentos <= "1111111"; -- Apagado
                anodos    <= "00000000"; -- Ningún display activo
        end case;
    end process;
end Behavioral;




