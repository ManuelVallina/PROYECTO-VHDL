----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 12:37:01
-- Design Name: 
-- Module Name: SelectorPiso_tb - Behavioral
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
-- Generation date : 14.12.2024 16:48:19 UTC

library ieee;
use ieee.std_logic_1164.all;

entity SelectorPiso_tb is
end SelectorPiso_tb;

architecture tb of SelectorPiso_tb is

    component SelectorPiso
        port (CLK               : in std_logic;
              RST               : in std_logic;
              botones_IN        : in std_logic_vector (3 downto 0);
              piso_seleccionado : out std_logic_vector (1 downto 0));
    end component;

    signal CLK               : std_logic;
    signal RST               : std_logic;
    signal botones_IN        : std_logic_vector (3 downto 0);
    signal piso_seleccionado : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : SelectorPiso
    port map (CLK               => CLK,
              RST               => RST,
              botones_IN        => botones_IN,
              piso_seleccionado => piso_seleccionado);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CLK <= '0';
        botones_IN <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_SelectorPiso_tb of SelectorPiso_tb is
    for tb
    end for;
end cfg_SelectorPiso_tb;