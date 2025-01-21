library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplaySnake is
    Port (
        clk         : in  STD_LOGIC;                -- Reloj principal
        reset       : in  STD_LOGIC;                -- Señal de reinicio
        piso_actual : in  STD_LOGIC_VECTOR(1 downto 0); -- Piso actual (00, 01, 10, 11)
        segmentos   : out STD_LOGIC_VECTOR(6 downto 0); -- Salida a los segmentos (a-g)
        anodos      : out STD_LOGIC_VECTOR(7 downto 0)  -- Control de los ánodos
    );
end DisplaySnake;

architecture Behavioral of DisplaySnake is

    -- Decodificador binario a 7 segmentos
    function decode_7seg(input : STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case input is
            when "00" => return "1000000"; -- 0
            when "01" => return "1111001"; -- 1
            when "10" => return "0100100"; -- 2
            when "11" => return "0110000"; -- 3
            when others => return "1111111"; -- Apagado
        end case;
    end decode_7seg;

    -- Señal interna para el valor a mostrar en segmentos
    signal segmentos_int : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');

    -- Control de ánodos (1 para habilitar, 0 para deshabilitar)
    signal anodos_int : STD_LOGIC_VECTOR(7 downto 0) := "11111111"; -- Todos los displays apagados

    -- Contador para alternar entre los displays
    signal display_counter : unsigned(1 downto 0) := "00"; -- Controla los 4 displays (2 bits)

    -- Divisor de reloj para manejar la multiplexación
    signal clk_div : unsigned(15 downto 0) := (others => '0');
    signal slow_clk : STD_LOGIC := '0';

begin

    -- Generador de reloj lento para multiplexar
    process(clk, reset)
    begin
        if reset = '0' then
            clk_div <= (others => '0');
            slow_clk <= '0';
        elsif rising_edge(clk) then
            if clk_div = 70000 then -- Ajusta según la frecuencia del reloj principal
                clk_div <= (others => '0');
                slow_clk <= not slow_clk;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    -- Control de desplazamiento
    process(slow_clk, reset)
    begin
        if reset = '0' then
            segmentos_int <= "1111111"; -- Apagado
            anodos_int <= "11111111";   -- Apagar todos los displays
            display_counter <= "00";   -- Reiniciar al primer display
        elsif rising_edge(slow_clk) then
            -- Decodificar el piso actual a segmentos
            segmentos_int <= decode_7seg(piso_actual);

            -- Actualizar el display activo según el contador
            case display_counter is
                when "00" => anodos_int <= "11111110"; -- Activar primer display
                when "01" => anodos_int <= "11111101"; -- Activar segundo display
                when "10" => anodos_int <= "11111011"; -- Activar tercer display
                when "11" => anodos_int <= "11110111"; -- Activar cuarto display
                when others => anodos_int <= "11111111"; -- Apagar todos por seguridad
            end case;

            -- Incrementar el contador de displays
            display_counter <= display_counter + 1;
        end if;
    end process;

    -- Asignación de las salidas
    segmentos <= segmentos_int;
    anodos <= anodos_int;

end Behavioral;
