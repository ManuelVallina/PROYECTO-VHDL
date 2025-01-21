library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DisplaySnake is
    Port (
        piso_actual : in STD_LOGIC_VECTOR(1downto 0);  -- Entrada del piso (4 bits, permite 0-9)
        segmentos : out STD_LOGIC_VECTOR(6 downto 0)  -- Salida hacia los segmentos (a, b, c, d, e, f, g)
    );
end DisplaySnake;

architecture Behavioral of DisplaySnake is
begin
    process(piso_actual)
    begin
        case piso_actual is 
            when "00" => segmentos <= "0000001"; -- 0
            when "01" => segmentos <= "1111001"; -- 1
            when "10" => segmentos <= "0010010"; -- 2
            when "11" => segmentos <= "0000110"; -- 3
          
            when others => segmentos <= "11111111"; -- Apagado (valor no válido)
        end case;
    end process;
end Behavioral;
