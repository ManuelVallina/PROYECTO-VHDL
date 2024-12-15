----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 17:49:34
-- Design Name: 
-- Module Name: cerrrar_puerta - Behavioral
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

entity cerrrar_puerta is
 Port (
        clk : in STD_LOGIC; -- Reloj para sincronización opcional
        entrada : in STD_LOGIC; -- Señal de entrada
        salida : out STD_LOGIC; -- Señal de salida
        señal_comparador : in STD_LOGIC -- Señal del comparador
    );
end cerrrar_puerta;

architecture Behavioral of cerrrar_puerta is
begin
    -- Proceso para controlar la puerta
    process(clk) -- creo que hace falta para la conexion
    begin
        if rising_edge(clk) then --Detecta el flanco de subida
            if señal_comparador = '1' then --si la señal de el comparador llega, no se como exppresarlo
                salida <= '0'; -- La puerta "se cierra"
            else
                salida <= entrada; -- La puerta deja pasar la señal de entrada
            end if;
        end if;
    end process;

end Behavioral;
