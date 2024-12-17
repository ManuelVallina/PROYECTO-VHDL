----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2024 18:37:24
-- Design Name: 
-- Module Name: ControlPuertas_tb - Behavioral
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

entity ControlPuertas_tb is
-- Test bench no tiene puertos
end ControlPuertas_tb;

architecture testbench of ControlPuertas_tb is
    -- Component Declaration
    component ControlPuertas
        Port (
            ACCION_MOTOR : in STD_LOGIC_VECTOR(1 downto 0);
            ACCION_PUERTA : in STD_LOGIC;
            puerta : out STD_LOGIC
        );
    end component;

    -- Signals for Stimulus
    signal ACCION_MOTOR_tb : STD_LOGIC_VECTOR(1 downto 0);
    signal ACCION_PUERTA_tb : STD_LOGIC;
    signal puerta_tb : STD_LOGIC;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ControlPuertas
        port map (
            ACCION_MOTOR => ACCION_MOTOR_tb,
            ACCION_PUERTA => ACCION_PUERTA_tb,
            puerta => puerta_tb
        );

    -- Stimulus Process
    process
    begin
        -- Caso 1: ACCION_MOTOR = "00" y ACCION_PUERTA = '1' --> puerta = '1'
        ACCION_MOTOR_tb <= "00";
        ACCION_PUERTA_tb <= '1';
        wait for 10 ns;
        assert (puerta_tb = '1') 
            report "Fallo en Caso 1: puerta debería ser '1'" severity error;

        -- Caso 2: ACCION_MOTOR = "00" y ACCION_PUERTA = '0' --> puerta = '0'
        ACCION_MOTOR_tb <= "00";
        ACCION_PUERTA_tb <= '0';
        wait for 10 ns;
        assert (puerta_tb = '0') 
            report "Fallo en Caso 2: puerta debería ser '0'" severity error;

        -- Caso 3: ACCION_MOTOR = "01" y ACCION_PUERTA = '1' --> puerta = '0'
        ACCION_MOTOR_tb <= "01";
        ACCION_PUERTA_tb <= '1';
        wait for 10 ns;
        assert (puerta_tb = '0') 
            report "Fallo en Caso 3: puerta debería ser '0'" severity error;

        -- Caso 4: ACCION_MOTOR = "10" y ACCION_PUERTA = '0' --> puerta = '0'
        ACCION_MOTOR_tb <= "10";
        ACCION_PUERTA_tb <= '0';
        wait for 10 ns;
        assert (puerta_tb = '0') 
            report "Fallo en Caso 4: puerta debería ser '0'" severity error;

        -- Caso 5: ACCION_MOTOR = "11" y ACCION_PUERTA = '1' --> puerta = '0'
        ACCION_MOTOR_tb <= "11";
        ACCION_PUERTA_tb <= '1';
        wait for 10 ns;
        assert (puerta_tb = '0') 
            report "Fallo en Caso 5: puerta debería ser '0'" severity error;

        -- Finalización
        report "Test completado con éxito." severity note;
        wait;
    end process;
end testbench;

