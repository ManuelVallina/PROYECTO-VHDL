----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 17:00:43
-- Design Name: 
-- Module Name: ControlMovimiento_tb - Behavioral
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

entity ControlMovimiento_TB is
-- No ports for testbench
end ControlMovimiento_TB;

architecture Behavioral of ControlMovimiento_TB is

    -- Component declaration for the tested entity
    component ControlMovimiento
        Port (
            piso_actual : in STD_LOGIC_VECTOR(1 downto 0);
            piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
            motor : out STD_LOGIC_VECTOR(1 downto 0) -- 00: Parado, 01: Subiendo, 10: Bajando
        );
    end component;

    -- Signals to connect to the tested entity
    signal piso_actual : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Initial floor
    signal piso_deseado : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Desired floor
    signal motor : STD_LOGIC_VECTOR(1 downto 0); -- Motor control output

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ControlMovimiento
        Port map (
            piso_actual => piso_actual,
            piso_deseado => piso_deseado,
            motor => motor
        );

    -- Test process
    process
    begin
        -- Test Case 1: Ascensor parado en el piso deseado
        piso_actual <= "01";
        piso_deseado <= "01";
        wait for 20 ns;

        -- Test Case 2: Ascensor sube del piso 0 al piso 2
        piso_actual <= "00";
        piso_deseado <= "10";
        wait for 20 ns;

        -- Test Case 3: Ascensor baja del piso 3 al piso 1
        piso_actual <= "11";
        piso_deseado <= "01";
        wait for 20 ns;

        -- Test Case 4: Ascensor parado en el piso 0 y debe subir
        piso_actual <= "00";
        piso_deseado <= "01";
        wait for 20 ns;

        -- Test Case 5: Ascensor parado en el piso 2 y debe bajar al piso 0
        piso_actual <= "10";
        piso_deseado <= "00";
        wait for 20 ns;

        -- End of simulation
        wait;
    end process;

end Behavioral;
