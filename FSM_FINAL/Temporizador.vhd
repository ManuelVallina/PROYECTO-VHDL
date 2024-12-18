library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Temporizador is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        TIME_SET : in INTEGER;       -- Tiempo en ciclos de reloj
        TIME_OUT : out STD_LOGIC     -- Señal de salida cuando el tiempo transcurre
    );
end Temporizador;

architecture Behavioral of Temporizador is
    signal counter : INTEGER := 0;       -- Contador interno
    signal active : STD_LOGIC := '0';    -- Control interno del temporizador
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            counter <= 0;
            active <= '0';
            TIME_OUT <= '0';
        elsif rising_edge(CLK) then
            -- Inicia el temporizador automáticamente
            if active = '0' then
                active <= '1';
                counter <= 0;
                TIME_OUT <= '0';
            elsif active = '1' then
                if counter < TIME_SET then
                    counter <= counter + 1;
                else
                    TIME_OUT <= '1';  -- Temporizador completado
                    active <= '0';   -- Reinicia automáticamente para el siguiente uso
                end if;
            end if;
        end if;
    end process;
end Behavioral;
