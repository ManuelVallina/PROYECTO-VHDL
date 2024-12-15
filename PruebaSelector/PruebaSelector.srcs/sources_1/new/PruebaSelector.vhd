----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 17:29:46
-- Design Name: 
-- Module Name: PruebaSelector - Behavioral
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

ENTITY PruebaSelector IS
    PORT (
        CLK : IN  STD_LOGIC;
        RST : IN  STD_LOGIC;
        botones_IN : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        piso_deseado_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END PruebaSelector;

ARCHITECTURE Behavioral OF PruebaSelector IS

    COMPONENT SelectorPiso
        PORT (
            CLK : IN  STD_LOGIC;
            RST : IN  STD_LOGIC;
            botones_IN : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            piso_seleccionado : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MultiplicadorPiso
        PORT (
            piso_deseado : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            piso_out     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL piso_intermedio : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    -- Instancia del Selector de Pisos
    selector_inst : SelectorPiso
        PORT MAP (
            CLK => CLK,
            RST => RST,
            botones_IN => botones_IN,
            piso_seleccionado => piso_intermedio
        );

    -- Instancia del PassthroughPiso
    passthrough_inst : MultiplicadorPiso
        PORT MAP (
            piso_deseado => piso_intermedio,
            piso_out => piso_deseado_out
        );

END Behavioral;