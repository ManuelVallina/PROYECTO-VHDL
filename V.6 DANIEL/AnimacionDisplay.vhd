library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplaySnake is
    Port (
        clk : in  STD_LOGIC; -- Señal de reloj
        reset : in STD_LOGIC; -- Señal de reset
        piso : in STD_LOGIC_VECTOR(1 downto 0); -- Piso (2 bits)
        display : out STD_LOGIC_VECTOR(6 downto 0) -- Salida al display de 7 segmentos
    );
end DisplaySnake;

architecture Behavioral of DisplaySnake is
    signal counter : INTEGER := 0; -- Contador para la temporización
    signal toggle : STD_LOGIC := '0'; -- Alterna entre número y blanco
    constant MAX_COUNT : INTEGER := 10000000; -- Ajustar según el reloj (por ejemplo, 0.1s para 100MHz)
begin

    -- Proceso para manejar el temporizador y la señal de alternancia
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            toggle <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT then
                counter <= 0;
                toggle <= not toggle; -- Cambia entre 0 y 1
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Proceso para manejar la salida del display
    process(piso, toggle)
    begin
        if toggle = '0' then
            case piso is
                when "00" => display <= "1000000"; -- Número 0
                when "01" => display <= "1111001"; -- Número 1
                when "10" => display <= "0100100"; -- Número 2
                when "11" => display <= "0110000"; -- Número 3
                when others => display <= "1111111"; -- Apagado (valor inválido)
            end case;
        else
            display <= "1111111"; -- Blanco (apagado)
        end if;
    end process;

end Behavioral;
