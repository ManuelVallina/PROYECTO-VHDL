library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity refreshcounter is
    Port (
        refresh_clock : in STD_LOGIC; -- Señal de reloj
        refreshcounter : out STD_LOGIC_VECTOR(1 downto 0) -- Contador de 2 bits
    );
end refreshcounter;

architecture Behavioral of refreshcounter is
    signal refreshcounter_reg : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Inicializado en 0
begin

    process(refresh_clock)
    begin
        if rising_edge(refresh_clock) then
            refreshcounter_reg <= std_logic_vector(unsigned(refreshcounter_reg) + 1);
        end if;
    end process;

    refreshcounter <= refreshcounter_reg; -- Asignar salida

end Behavioral;

