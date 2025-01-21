library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SelectorDisplay is
Port ( 
    clk       : IN std_logic;                     -- Reloj
    reset     : IN std_logic;                     -- Reset
    segmentos : OUT std_logic_vector(6 DOWNTO 0); -- Segmentos del display
    anodos    : OUT std_logic_vector(7 DOWNTO 0);  -- Ánodos para seleccionar displays
   -- puerta    : in std_logic
    );
end SelectorDisplay;

architecture Behavioral of SelectorDisplay is
    -- Señales internas
    signal segmentos_i : std_logic_vector(6 DOWNTO 0);
    signal anodos_i : std_logic_vector(7 DOWNTO 0) := "11111111"; -- Todos apagados inicialmente

    -- Decodificador binario a 7 segmentos
    function decode_7seg(input : std_logic_vector(3 DOWNTO 0)) return std_logic_vector is
    begin
        case input is
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when others => return "1111111"; -- Apagado
        end case;
    end function;

begin
    -- Lógica de control
    process(clk, reset)
    begin
        if reset = '1' then
            anodos_i <= "11111111";  -- Apagar todos los displays
            segmentos_i <= "1111111"; -- Apagar segmentos
        elsif rising_edge(clk) then
       
            -- Activar displays 1, 2, 3, 4 (bits 0-3 en nivel bajo)
            anodos_i <= "11110000";

            -- Asignar segmentos para mostrar 1, 2, 3, 4
            case anodos_i is
                when "11101111" => segmentos_i <= decode_7seg("0001"); -- Display 1 muestra 1
                when "11011111" => segmentos_i <= decode_7seg("0010"); -- Display 2 muestra 2
                when "10111111" => segmentos_i <= decode_7seg("0011"); -- Display 3 muestra 3
                when "01111111" => segmentos_i <= decode_7seg("0100"); -- Display 4 muestra 4
                when others => segmentos_i <= "1111111"; -- Apagar segmentos
            end case;
        end if;
        end if;
    end process;

    -- Asignación de salida
    segmentos <= segmentos_i;
    anodos <= anodos_i;

end Behavioral;
