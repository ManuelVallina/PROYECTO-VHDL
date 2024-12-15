----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 00:00:48
-- Design Name: 
-- Module Name: display - Behavioral
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

entity SEGMENTOS is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PISO : in STD_LOGIC_VECTOR(1 downto 0); -- Indica el piso actual del ascensor
        LEDS : out STD_LOGIC_VECTOR(3 downto 0) -- LEDs correspondientes a cada piso
    );
end SEGMENTOS;

architecture Behavioral of SEGMENTOS is
begin

-- Proceso para controlar los LEDs en función del piso
LED_CONTROL: PROCESS(CLK, RESET)
BEGIN
    IF RESET = '1' THEN
        LEDS <= "0000"; -- Apagar todos los LEDs al reset
    ELSIF rising_edge(CLK) THEN
        CASE PISO IS
            WHEN "00" =>
                LEDS <= "0001"; -- Encender LED del piso 0
            WHEN "01" =>
                LEDS <= "0010"; -- Encender LED del piso 1
            WHEN "10" =>
                LEDS <= "0100"; -- Encender LED del piso 2
            WHEN "11" =>
                LEDS <= "1000"; -- Encender LED del piso 3
            WHEN OTHERS =>
                LEDS <= "0000"; -- Apagar LEDs en caso de error
        END CASE;
    END IF;
END PROCESS;

end Behavioral;
