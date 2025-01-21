----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 12:20:58
-- Design Name: 
-- Module Name: SelectorPiso - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SelectorPiso is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           botones_IN : in std_logic_vector(3 downto 0);
           piso_seleccionado : out std_logic_vector(1 downto 0)
           );
end SelectorPiso;

architecture Behavioral of SelectorPiso is

 signal botones_filtrados: std_logic_vector( 3 downto 0);
 
component BotoneraAntirrebotes
 port(
  CLK : in std_logic;
  RST : in std_logic;
  BotonIN: in std_logic_vector(3 downto 0);
  BotonOUT : out std_logic_vector (3 downto 0)
  );
 end component;
 
begin

BotoneraAnti: BotoneraAntirrebotes
 Port map(
 CLK => CLK,
 RST => RST,
 BotonIN => botones_IN,
 BotonOUT => botones_filtrados
 );

process (CLK,RST)
begin
if RST = '1' then
        piso_seleccionado <= "00"; -- Reset a piso 0 por defecto
elsif rising_edge(CLK) then
  case botones_filtrados is 
  when "0001" => piso_seleccionado <= "00" ;
  when "0010" => piso_seleccionado <= "01" ;
  when "0100" => piso_seleccionado <= "10" ;
  when "1000" => piso_seleccionado <= "11" ;
  when others =>  NULL ;
  
  end case;
end if;

end process;

end Behavioral;
