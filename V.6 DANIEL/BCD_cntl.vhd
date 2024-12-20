library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_control is
    Port (
        digit1 : in STD_LOGIC_VECTOR(3 downto 0); -- Right digit (ones)
        digit2 : in STD_LOGIC_VECTOR(3 downto 0); -- Tens
        digit3 : in STD_LOGIC_VECTOR(3 downto 0); -- Hundreds
        digit4 : in STD_LOGIC_VECTOR(3 downto 0); -- Left digit (thousands)
        refreshcounter : in STD_LOGIC_VECTOR(1 downto 0); -- Selector de dígito
        ONE_DIGIT : out STD_LOGIC_VECTOR(3 downto 0) -- Salida del dígito seleccionado
    );
end BCD_control;

architecture Behavioral of BCD_control is
begin

    process(refreshcounter, digit1, digit2, digit3, digit4)
    begin
        case refreshcounter is
            when "00" =>
                ONE_DIGIT <= digit1; -- Valor del dígito 1 (ones)
            when "01" =>
                ONE_DIGIT <= digit2; -- Valor del dígito 2 (tens)
            when "10" =>
                ONE_DIGIT <= digit3; -- Valor del dígito 3 (hundreds)
            when "11" =>
                ONE_DIGIT <= digit4; -- Valor del dígito 4 (thousands)
            when others =>
                ONE_DIGIT <= "0000"; -- Valor por defecto (apagado)
        end case;
    end process;

end Behavioral;
