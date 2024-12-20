library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_to_Cathodes is
    Port (
        digit : in STD_LOGIC_VECTOR(3 downto 0);
        cathode : out STD_LOGIC_VECTOR(7 downto 0)
    );
end BCD_to_Cathodes;

architecture Behavioral of BCD_to_Cathodes is
begin
    process(digit)
    begin
        case digit is
            when "0000" => cathode <= "11000000"; -- 0
            when "0001" => cathode <= "11111001"; -- 1
            when "0010" => cathode <= "10100100"; -- 2
            when "0011" => cathode <= "10110000"; -- 3
            when "0100" => cathode <= "10011001"; -- 4
            when "0101" => cathode <= "10010010"; -- 5
            when "0110" => cathode <= "10000010"; -- 6
            when "0111" => cathode <= "11111000"; -- 7
            when "1000" => cathode <= "10000000"; -- 8
            when "1001" => cathode <= "10010000"; -- 9
            when others => cathode <= "11111111";  -- Default (all segments off)
        end case;
    end process;
end Behavioral;
