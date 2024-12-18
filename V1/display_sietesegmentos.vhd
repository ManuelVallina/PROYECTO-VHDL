library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_control is
Port ( CLK : in  STD_LOGIC;
           piso_actual_detected: in  STD_LOGIC_VECTOR (1 downto 0);
           piso_deseado : in  STD_LOGIC_VECTOR (1 downto 0);
           piso_selected : out STD_LOGIC_VECTOR (1 downto 0);
           piso_actual : out  STD_LOGIC_VECTOR (1 downto 0);
           movimiento : out  STD_LOGIC_VECTOR (1 downto 0)
			);	
end display_control;

architecture Behavioral of display_control is 
signal piso_actual_temp:STD_LOGIC_VECTOR (1 downto 0);
begin

gestor_display:process(clk)
	begin
		if rising_edge(clk) then
		
			if (piso_actual_detected/="00") then
				piso_actual_temp <= piso_actual_detected;
			end if;
			
			piso_selected <= piso_deseado;
			piso_actual <= piso_actual_temp;
			
			if (piso_deseado= "00") then
				movimiento <= "00";
			elsif (piso_actual_temp < piso_deseado) then
				movimiento <= "01";
			elsif (piso_actual_temp > piso_deseado) then
				movimiento <= "10";
			else
				movimiento <= "11";
			end if;
		end if;
	end process;

end Behavioral;