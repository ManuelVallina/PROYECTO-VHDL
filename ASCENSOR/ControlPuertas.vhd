----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 12:03:10
-- Design Name: 
-- Module Name: ControlPuertas - Behavioral
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

entity ControlPuertas is
    Port (
        ACCION_MOTOR : in STD_LOGIC_VECTOR(1 downto 0);
        ACCION_PUERTA : in STD_LOGIC;
        --piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
        puerta : out STD_LOGIC -- 1: Abierta, 0: Cerrada
    );
end ControlPuertas;

architecture Behavioral of ControlPuertas is
begin
    process(ACCION_MOTOR, ACCION_PUERTA)
    begin
        IF ACCION_MOTOR = "00" and ACCION_PUERTA = '1' then
            puerta <= '1'; -- Abrir puerta
        else
            puerta <= '0'; -- Cerrar puerta
        end if;
    end process;
end Behavioral;
