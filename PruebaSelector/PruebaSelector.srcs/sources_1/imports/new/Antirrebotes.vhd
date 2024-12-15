----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 11:06:19
-- Design Name: 
-- Module Name: Antirrebotes - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Antirrebotes is
    Port ( CLK : in STD_LOGIC;
           logic_IN : in STD_LOGIC;
           logic_OUT : out STD_LOGIC;
           RST : in STD_LOGIC);
end Antirrebotes;

architecture Behavioral of Antirrebotes is

constant contador_SIZE : integer := 2;		--tamaño del contador (Para 50MHz: 19, 10ms - 20, 20ms - 21, 42ms - 22, 84ms)
signal logic_prev   : std_logic := '0';		--almacena estado del boton, se usa como variable de transicion
signal contador    : std_logic_vector(contador_SIZE downto 0) := (others => '0');	--vector contador para que pase el tiempo antirrebote
	 
begin
    process(CLK,RST,logic_IN)
    begin
	 if (RST='1') then
		logic_OUT <= logic_IN;
	 elsif (CLK'event and CLK='1') then									--Si hay flanco de reloj
		 if (logic_prev XOR logic_in)='1' then							--Si 	la entrada es diferente al estado previo almacenado
			 contador <= (others => '0');										--Contador a cero
		 	 logic_prev <= logic_in;											--La entrada pasa a la variable de transicion
		 elsif (contador(contador_SIZE) = '0') then					--Si la entrada es igual a la variable de transicion y el contador no esta lleno
			 contador <= std_logic_vector(UNSIGNED(contador) + 1);	--Sumamos 1 al contador
       else																		--Si la entrada es igual a la variable de transicion y el contador esta lleno
			 logic_out <= logic_prev;										--Pasamos la variable de transicion a la salida
		 end if;
	 end if;
	 
    end process;

end Behavioral;
