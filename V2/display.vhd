library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display7seg is
    Port (
        planta : in STD_LOGIC_VECTOR(1 downto 0); -- Entrada de la planta (2 bits: 0-3)
        display1 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al primer display (a-g)
        display2 : out STD_LOGIC_VECTOR(6 downto 0) -- Salida al segundo display (a-g)
    );
end display7seg;

architecture Behavioral of display7seg is
begin
    process(planta)
    begin
        case planta is
            when "00" => display1 <= "0000001"; -- Mostrar "0"
            when "01" => display1 <= "1001111"; -- Mostrar "1"
            when "10" => display1 <= "0010010"; -- Mostrar "2"
            when "11" => display1 <= "0000110"; -- Mostrar "3"
            when others => display1 <= "1111111"; -- Apagar en caso de error
        end case;
    end process;

    -- Proceso para manejar el segundo display (apagado por ahora)
    display2 <= "1111111"; -- Apagar todos los segmentos del segundo display
end Behavioral;

