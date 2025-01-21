----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2025 12:43:16
-- Design Name: 
-- Module Name: Accion_error - Behavioral
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

entity Accion_error is
Port ( 
    clk        : IN std_logic;                     -- Reloj para el selector
    segmentos  : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
    inicio     : in std_logic;
    anodos     : OUT std_logic_vector(7 DOWNTO 0) -- Control de los ánodos (bit bajo = display activo)
    
    
);
end Accion_error;

architecture Behavioral of Accion_error is

    signal cuenta   : integer range 0 to 100000; -- con dos ceros más se ajusta la velocidad 10000000
    signal seleccion : std_logic_vector (2 downto 0) := "000";
    signal mostrar  : std_logic_vector (7 downto 0) := "00000000";
    signal piso,guion,flecha :std_logic_vector(6 DOWNTO 0);

begin

    -- Proceso para alternar entre displays solo si inicio está activo
   process(clk)
    begin
        if rising_edge(clk) then
            if inicio = '1' then
                if cuenta < 100000 then -- Ajustar velocidad 10000000
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
    process(seleccion,inicio)
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
                when "11111110" => segmentos <= guion;
                when "11111101" => segmentos <= "1001110";
                when "11111011" => segmentos <= "1000000";
                when "11110111" => segmentos <= "1001110";
                when "11101111" => segmentos <= "1001110";
                when "11011111" => segmentos <= "0000110";
                when "10111111" => segmentos <= guion;
                when "01111111" => segmentos <= guion;
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
    piso <= "0001100"; -- puede ser catodo o anodo comun cuidao
    guion<= "0111111";
    flecha <= "0111001";
    --puerta <= "0111001";
   
end Behavioral;