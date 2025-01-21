----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2024 22:58:24
-- Design Name: 
-- Module Name: Bin_to_BCD - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Bin_to_BCD is
    Port (
        bin_in  : in  STD_LOGIC_VECTOR (1 downto 0); -- Entrada binaria de 2 bits
        seg_out : out STD_LOGIC_VECTOR (6 downto 0)  -- Salida para 7 segmentos
    );
end Bin_to_BCD;


architecture Behavioral of Bin_to_BCD is
begin
    process(bin_in)
    begin
        case bin_in is
    when "00" =>
        seg_out <= "1000000"; -- Representa '0' en el display de 7 segmentos
    when "01" =>
        seg_out <= "1001111"; -- Representa '1' en el display de 7 segmentos
    when "10" =>
        seg_out <= "0100100"; -- Representa '2' en el display de 7 segmentos
    when "11" =>
        seg_out <= "0110000"; -- Representa '3' en el display de 7 segmentos
    when others =>
        seg_out <= "0000000"; -- Todos apagados por defecto
end case;

    end process;
end Behavioral;