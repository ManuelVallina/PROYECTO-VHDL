----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 12:04:22
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


library ieee;
use ieee.std_logic_1164.all;

entity tb_ControlPuertas is
end tb_ControlPuertas;

architecture tb of tb_ControlPuertas is

    component ControlPuertas
        port (motor        : in std_logic_vector (1 downto 0);
              piso_actual  : in std_logic_vector (1 downto 0);
              piso_deseado : in std_logic_vector (1 downto 0);
              puerta       : out std_logic);
    end component;

    signal motor        : std_logic_vector (1 downto 0);
    signal piso_actual  : std_logic_vector (1 downto 0);
    signal piso_deseado : std_logic_vector (1 downto 0);
    signal puerta       : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : ControlPuertas
    port map (motor        => motor,
              piso_actual  => piso_actual,
              piso_deseado => piso_deseado,
              puerta       => puerta);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        motor <= (others => '0');
        piso_actual <= (others => '0');
        piso_deseado <= (others => '0');

     

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_ControlPuertas of tb_ControlPuertas is
    for tb
    end for;
end cfg_tb_ControlPuertas;