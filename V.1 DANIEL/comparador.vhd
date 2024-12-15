----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 17:40:10
-- Design Name: 
-- Module Name: comparador - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparador is
Port (
        piso_deseado : in  STD_LOGIC_VECTOR(3 downto 0); -- Piso deseado (4 bits)
        piso_actual  : in  STD_LOGIC_VECTOR(3 downto 0); -- Piso actual (4 bits)
        diferente    : out STD_LOGIC                 -- Salida: 1 si diferentes, 0 si iguales
    );
end comparador;

architecture Behavioral of comparador is

begin
    proceso_comparacion: process(piso_deseado, piso_actual)
    begin
        if piso_deseado /= piso_actual then -- si el piso actual no es como el deseado nos da una señal de 1 para poder conectarlo con la puerta?
            diferente <= '1';
        else
            diferente <= '0';
        end if;
    end process proceso_comparacion;

end Behavioral;
