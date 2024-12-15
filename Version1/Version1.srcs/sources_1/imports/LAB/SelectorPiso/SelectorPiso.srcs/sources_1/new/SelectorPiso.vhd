----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 12:20:58
-- Design Name: 
-- Module Name: SelectorPiso - Behavioral
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

entity SelectorPiso is
    Port ( 
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        botones_IN : in std_logic_vector(3 downto 0);
        piso_seleccionado : out std_logic_vector(1 downto 0)
    );
end SelectorPiso;

architecture Behavioral of SelectorPiso is

    -- Componente para el antirrebote
    component BotoneraAntirrebotes
        port (
            CLK : in std_logic;
            RST : in std_logic;
            BotonIN: in std_logic_vector(3 downto 0);
            BotonOUT : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Señal para almacenar el último piso seleccionado
    signal piso_temp : std_logic_vector(1 downto 0);
    -- Señal interna para los botones filtrados
    signal botones_filtrados: std_logic_vector(3 downto 0);

begin

    -- Instanciación de la Botonera con Antirrebotes
    BotoneraAnti: BotoneraAntirrebotes
        Port map(
            CLK => CLK,
            RST => RST,
            BotonIN => botones_IN,
            BotonOUT => botones_filtrados
        );

    -- Proceso para asignar el piso seleccionado
    process (CLK, RST)
    begin
        if RST = '1' then
            piso_temp <= "00"; -- Reset a piso 0 por defecto
        elsif rising_edge(CLK) then
            case botones_filtrados is
                when "0001" => piso_temp <= "00";
                when "0010" => piso_temp <= "01";
                when "0100" => piso_temp <= "10";
                when "1000" => piso_temp <= "11";
                when others => null; -- Mantener el valor previo
            end case;
        end if;
    end process;

    -- Asignar el valor del piso seleccionado
    piso_seleccionado <= piso_temp;

end Behavioral;
