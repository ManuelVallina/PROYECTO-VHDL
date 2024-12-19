library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port (
        clk : in STD_LOGIC; -- Reloj para multiplexar los displays
        reset : in STD_LOGIC; -- Reset para inicializar el sistema
        data : in STD_LOGIC_VECTOR(15 downto 0); -- Datos de los 8 dígitos (2 bits por dígito, 8 dígitos en total)
        piso_actual: in STD_LOGIC_VECTOR(1 downto 0); --entrada1
        puerta: in STD_LOGIC; --entrada 2
        anodos : out STD_LOGIC_VECTOR(7 downto 0); -- Control de anodos (activación de displays)
        segmentos : out STD_LOGIC_VECTOR(6 downto 0) -- Salida de segmentos (a-g)
        
    );
end display;

architecture Behavioral of display is

    -- Señal para controlar qué display está activo
    signal active_display : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- 3 bits para seleccionar 1 de 8 displays
    signal segment_data : STD_LOGIC_VECTOR(1 downto 0); -- 2 bits para el dígito actual
    signal active_display_int : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- 3 bits para el display activo
    signal data_selected : STD_LOGIC_VECTOR(3 downto 0); -- Datos seleccionados para mostrar
    signal data_to_display : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- Datos para todos los displays




    -- Decodificador binario a 7 segmentos
    function decode_7seg(input : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case input is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1001111"; -- 1 tambien | izq
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0001100"; -- P
            when "0110" => return "1000110"; -- [
            when "0111" => return "1110000"; -- ]
            when "1000" => return "1111001"; -- |dcha
            when "1001" => return "0111111"; -- -
            when others => return "1111111"; -- Apagado
        end case;
    end decode_7seg;

begin

    -- Control de multiplexación
    process(clk, reset)
        variable clk_div : integer := 0; -- Divisor de reloj para multiplexar
    begin
        if reset = '1' then
            active_display <= "000";
            clk_div := 0;
        elsif rising_edge(clk) then
            clk_div := clk_div + 1;
            if clk_div = 100000 then -- Ajusta para definir la velocidad de multiplexado
                clk_div := 0;
                active_display <= std_logic_vector(unsigned(active_display) + 1);
                if active_display = "111" then
                    active_display <= "000"; -- Reinicia a la primera pantalla después del octavo display
                end if;
            end if;
        end if;
    end process;

    -- Lógica para seleccionar los datos de los displays
    process(puerta, piso_actual)
    begin
        -- Apaga todos los displays inicialmente
        data_to_display <= (others => '0');
        
        if puerta = '1' then
        -- Si la puerta está abierta, mostrar "P x" en los displays 4 y 5
            data_to_display(15 downto 12) <= "0101"; -- P en el 4º display
            data_to_display(3 downto 0) <= "0001";
            data_to_display(31 downto 28) <= "1000";
            case piso_actual is
                when "00" => data_to_display(19 downto 16) <= "0000"; -- 0 en el 5º display
                when "01" => data_to_display(19 downto 16) <= "0001"; -- 1 en el 5º display
                when "10" => data_to_display(19 downto 16) <= "0010"; -- 2 en el 5º display
                when "11" => data_to_display(19 downto 16) <= "0011"; -- 3 en el 5º display
                when others => data_to_display(19 downto 16) <= "1111"; -- Apagado por error
                
    
            end case;
        else
            -- Si entrada1 es "0", MOSTRAMOS ANIMACION con guiones
           data_to_display(15 downto 12) <= "1001"; -- Guión en el 4º display
           data_to_display(19 downto 16) <= "1001"; -- Guión en el 5º display
           data_to_display(7 downto 4) <= "1001"; 
           data_to_display(11 downto 8) <= "1001"; 
           data_to_display(19 downto 16) <= "1001"; 
           data_to_display(23 downto 20) <= "1001";
           data_to_display(27 downto 24) <= "1001";
           data_to_display(3 downto 0) <= "0110";
           data_to_display(31 downto 28) <= "0111";

        end if;
    end process;
    
    -- Proceso de decodificación y salida
    process(active_display_int, data_to_display)
    begin
        case active_display_int is
            when "000" => segment_data <= data_to_display(3 downto 0);   -- 1er display
            when "001" => segment_data <= data_to_display(7 downto 4);   -- 2º display
            when "010" => segment_data <= data_to_display(11 downto 8);  -- 3º display
            when "011" => segment_data <= data_to_display(15 downto 12); -- 4º display
            when "100" => segment_data <= data_to_display(19 downto 16); -- 5º display
            when "101" => segment_data <= data_to_display(23 downto 20); -- 6º display
            when "110" => segment_data <= data_to_display(27 downto 24); -- 7º display
            when "111" => segment_data <= data_to_display(31 downto 28); -- 8º display
            when others => segment_data <= "1111"; -- Apagar por defecto
        end case;
    end process;

    -- Decodificación de los datos seleccionados a 7 segmentos
    segmentos <= decode_7seg(data_selected);
    -- Salida del display activo
    active_display <= active_display_int;

end Behavioral; 
