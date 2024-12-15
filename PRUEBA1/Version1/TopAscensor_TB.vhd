----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 16:52:32
-- Design Name: 
-- Module Name: TopAscensor_TB - Behavioral
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


-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 14.12.2024 17:40:21 UTC

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopAscensor_TB  is
-- Testbench sin puertos.
end TopAscensor_TB ;

architecture Behavioral of TopAscensor_TB  is

    -- Componentes de prueba
    component AscensorTop
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            botones_IN : in STD_LOGIC_VECTOR(3 downto 0);
            piso_actual : in STD_LOGIC_VECTOR(1 downto 0);
            piso_deseado : out STD_LOGIC_VECTOR(1 downto 0);
            puerta : out STD_LOGIC;
            motor : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Señales internas
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '1';
    signal botones_IN : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal piso_actual : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal piso_deseado : STD_LOGIC_VECTOR(1 downto 0);
    signal puerta : STD_LOGIC;
    signal motor : STD_LOGIC_VECTOR(1 downto 0);

    -- Constantes para tiempos
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del módulo AscensorTop
    uut : AscensorTop
        port map (
            CLK => CLK,
            RST => RST,
            botones_IN => botones_IN,
            piso_actual => piso_actual,
            piso_deseado => piso_deseado,
            puerta => puerta,
            motor => motor
        );

    -- Generación del reloj
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de prueba
    stimulus : process
    begin
        -- Reset del sistema
        wait for 20 ns;
        RST <= '0';

        -- Simulación de selección de pisos
        botones_IN <= "0001"; -- Selecciona el piso 0
        wait for 40 ns;
        botones_IN <= "0010"; -- Selecciona el piso 1
        wait for 40 ns;
        botones_IN <= "0100"; -- Selecciona el piso 2
        wait for 40 ns;
        botones_IN <= "1000"; -- Selecciona el piso 3
        wait for 40 ns;

        -- Simulación del movimiento del ascensor
        piso_actual <= "00";
        wait for 40 ns;
        piso_actual <= "01"; -- Piso actual cambia a 1
        wait for 40 ns;
        piso_actual <= "10"; -- Piso actual cambia a 2
        wait for 40 ns;
        piso_actual <= "11"; -- Piso actual cambia a 3
        wait for 40 ns;

        -- Fin de simulación
        wait for 100 ns;
        wait;
    end process;

end Behavioral;
