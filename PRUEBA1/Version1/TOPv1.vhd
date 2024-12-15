----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 12:19:26
-- Design Name: 
-- Module Name: TOPv1 - Behavioral
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

entity AscensorTop is
    Port (
        CLK : in STD_LOGIC;                     -- Reloj
        RST : in STD_LOGIC;                     -- Reset
        botones_IN : in STD_LOGIC_VECTOR(3 downto 0); -- Botones de entrada
        piso_actual : in STD_LOGIC_VECTOR(1 downto 0); -- Piso actual
        piso_deseado: out std_logic_vector(1 downto 0);
        puerta : out STD_LOGIC;                 -- Estado de la puerta
        motor : out STD_LOGIC_VECTOR(1 downto 0) -- Control del motor
    );
end AscensorTop;

architecture Behavioral of AscensorTop is

COMPONENT SelectorPiso
PORT(
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    botones_IN : in std_logic_vector(3 downto 0);
    piso_seleccionado : out std_logic_vector(1 downto 0)
);
END COMPONENT;

COMPONENT ControlMovimiento
PORT(
    piso_actual : in STD_LOGIC_VECTOR(1 downto 0);
    piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
    motor : out STD_LOGIC_VECTOR(1 downto 0) -- 00: Parado, 01: Subiendo, 10: Bajando
);
END COMPONENT;

COMPONENT ControlPuertas
PORT(
    motor : in STD_LOGIC_VECTOR(1 downto 0);
    piso_actual : in STD_LOGIC_VECTOR(1 downto 0);
    piso_deseado : in STD_LOGIC_VECTOR(1 downto 0);
    puerta : out STD_LOGIC -- 1: Abierta, 0: Cerrada
);
END COMPONENT;

COMPONENT MultiplicadorPiso
PORT(
    piso_deseado : in std_logic_vector(1 downto 0);
    piso_out : out std_logic_vector(1 downto 0)
);
END COMPONENT;

-- Señales internas
signal piso_deseado_signal : STD_LOGIC_VECTOR(1 downto 0);
signal piso_deseado_passthrough : STD_LOGIC_VECTOR(1 downto 0);
signal motor_signal : std_logic_vector(1 downto 0);

begin

    -- Instancia del Selector de Pisos
    selector_inst : SelectorPiso
        port map (
            CLK => CLK,
            RST => RST,
            botones_IN => botones_IN,
            piso_seleccionado => piso_deseado_signal
        );

    -- Instancia del PassthroughPiso
    passthrough_inst : MultiplicadorPiso
        port map (
            piso_deseado => piso_deseado_signal,
            piso_out => piso_deseado_passthrough
        );

    -- Instancia del Control de Movimiento
    movimiento_inst : ControlMovimiento
        port map (
            piso_actual => piso_actual,
            piso_deseado => piso_deseado_passthrough,
            motor => motor_signal
        );

    -- Instancia del Control de Puertas
    puertas_inst : ControlPuertas
        port map (
            motor => motor_signal,
            piso_actual => piso_actual,
            piso_deseado => piso_deseado_passthrough,
            puerta => puerta
        );

    motor <= motor_signal;
 piso_deseado <= piso_deseado_passthrough;
end Behavioral;

