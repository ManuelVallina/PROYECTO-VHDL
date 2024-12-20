library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity anode_control is
    Port (
        refreshcounter : in STD_LOGIC_VECTOR(1 downto 0); -- Entrada del contador de refresco (2 bits)
        anode : out STD_LOGIC_VECTOR(3 downto 0) -- Salida de ánodo (4 bits)
    );
end anode_control;

architecture Behavioral of anode_control is
begin

    process(refreshcounter)
    begin
        case refreshcounter is
            when "00" => 
                anode <= "1110"; -- Digit 1 ON (right digit)
            when "01" => 
                anode <= "1101"; -- Digit 2 ON
            when "10" => 
                anode <= "1011"; -- Digit 3 ON
            when "11" => 
                anode <= "0111"; -- Digit 4 ON (left digit)
            when others => 
                anode <= "1111"; -- Default case (all OFF)
        end case;
    end process;

end Behavioral;
