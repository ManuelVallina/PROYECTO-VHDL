----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 13:34:30
-- Design Name: 
-- Module Name: ControlMovimiento - Behavioral
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

entity ControlMovimiento is
    Port (
        piso_actual : in STD_LOGIC_VECTOR(1 downto 0);
        piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
        motor : out STD_LOGIC_VECTOR(1 downto 0) -- 00: Parado, 01: Subiendo, 10: Bajando
    );
end ControlMovimiento;

architecture Behavioral of ControlMovimiento is
begin
    process(piso_actual, piso_deseado)
    begin
       if piso_actual = piso_deseado then
            motor <= "00"; -- Parado
           -- en_movimiento <= '0'; -- No está en movimiento
        elsif piso_actual < piso_deseado then
            motor <= "01"; -- Subiendo
           -- en_movimiento <= '1'; -- En movimiento
        elsif piso_actual > piso_deseado then
            motor <= "10"; -- Bajando
           -- en_movimiento <= '1'; -- En movimiento
        else 
             motor <= "00";
            -- en_movimiento <= '0';
        end if;
    end process;
end Behavioral;
