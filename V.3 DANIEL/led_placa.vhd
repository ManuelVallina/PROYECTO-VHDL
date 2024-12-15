----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 00:08:33
-- Design Name: 
-- Module Name: led_placa - Behavioral
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

entity LED is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PISO : in STD_LOGIC_VECTOR(1 downto 0); -- Indica el piso actual del ascensor
        LEDS_EXTERNOS : out STD_LOGIC_VECTOR(15 downto 0) -- LEDs físicos de salida en la FPGA Nexys 4DDR
    );
end LED;

architecture Behavioral of LED is
begin

-- Proceso para controlar los LEDs externos en función del piso
LED_CONTROL: PROCESS(CLK, RESET)
BEGIN
    IF RESET = '1' THEN
        LEDS_EXTERNOS <= (others => '0'); -- Apagar todos los LEDs al reset
    ELSIF rising_edge(CLK) THEN
        CASE PISO IS
            WHEN "00" =>
                LEDS_EXTERNOS <= "0000000000000001"; -- Encender LED físico para el piso 0
            WHEN "01" =>
                LEDS_EXTERNOS <= "0000000000000010"; -- Encender LED físico para el piso 1
            WHEN "10" =>
                LEDS_EXTERNOS <= "0000000000000100"; -- Encender LED físico para el piso 2
            WHEN "11" =>
                LEDS_EXTERNOS <= "0000000000001000"; -- Encender LED físico para el piso 3
            WHEN OTHERS =>
                LEDS_EXTERNOS <= (others => '0'); -- Apagar LEDs en caso de error
        END CASE;
    END IF;
END PROCESS;

end Behavioral;

