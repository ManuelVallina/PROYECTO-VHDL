----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 17:43:05
-- Design Name: 
-- Module Name: tb_Top_Selector_Multiplicador - Behavioral
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

ENTITY tb_Top_Selector_Multiplicador IS
END tb_Top_Selector_Multiplicador;

ARCHITECTURE Behavioral OF tb_Top_Selector_Multiplicador IS

    -- Componentes del top
    COMPONENT PruebaSelector
        PORT (
            CLK : IN  STD_LOGIC;
            RST : IN  STD_LOGIC;
            botones_IN : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            piso_deseado_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    -- Señales para estímulos
    SIGNAL CLK_tb : STD_LOGIC := '0';
    SIGNAL RST_tb : STD_LOGIC := '0';
    SIGNAL botones_IN_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL piso_deseado_out_tb : STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- Constante para el reloj
    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN
    -- Instancia del Top
    uut : PruebaSelector
        PORT MAP (
            CLK => CLK_tb,
            RST => RST_tb,
            botones_IN => botones_IN_tb,
            piso_deseado_out => piso_deseado_out_tb
        );

    -- Generador de reloj
    clk_process : PROCESS
    BEGIN
        CLK_tb <= '0';
        WAIT FOR CLK_PERIOD / 2;
        CLK_tb <= '1';
        WAIT FOR CLK_PERIOD / 2;
    END PROCESS;

    -- Estímulos
    stim_process : PROCESS
    BEGIN
        -- Reset inicial
        RST_tb <= '1';
        WAIT FOR 20 ns;
        RST_tb <= '0';
        
        -- Caso 1: Selección del primer piso
        botones_IN_tb <= "0001"; -- Botón del piso 0
        WAIT FOR 50 ns;

        -- Caso 2: Selección del segundo piso
        botones_IN_tb <= "0010"; -- Botón del piso 1
        WAIT FOR 50 ns;

        -- Caso 3: Selección del tercer piso
        botones_IN_tb <= "0100"; -- Botón del piso 2
        WAIT FOR 50 ns;

        -- Caso 4: Selección del cuarto piso
        botones_IN_tb <= "1000"; -- Botón del piso 3
        WAIT FOR 50 ns;

        -- Finalizar la simulación
        WAIT;
    END PROCESS;

END Behavioral;
