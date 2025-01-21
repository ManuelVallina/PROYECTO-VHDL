----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 17:38:13
-- Design Name: 
-- Module Name: MultiplicadorPiso - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MultiplicadorPiso IS
    PORT (
        piso_deseado : IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- Piso deseado de entrada
        piso_out     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Piso deseado de salida
    );
END MultiplicadorPiso;

ARCHITECTURE Behavioral OF MultiplicadorPiso IS
BEGIN
    piso_out <= piso_deseado; -- La salida es igual a la entrada
END Behavioral;
