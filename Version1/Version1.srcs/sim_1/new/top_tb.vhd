----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 13:48:05
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
end top_tb;

architecture tb of top_tb is

    component AscensorTop
        port (CLK          : in std_logic;
              RST          : in std_logic;
              botones_IN   : in std_logic_vector (3 downto 0);
              piso_actual  : in std_logic_vector (1 downto 0);
              display_piso : out std_logic_vector (6 downto 0);
              LEDs         : out std_logic_vector (1 downto 0);
              puerta       : out std_logic;
              motor        : out std_logic_vector (1 downto 0));
    end component;

    signal CLK          : std_logic;
    signal RST          : std_logic;
    signal botones_IN   : std_logic_vector (3 downto 0);
    signal piso_actual  : std_logic_vector (1 downto 0);
    --signal display_piso : std_logic_vector (6 downto 0);
    --signal LEDs         : std_logic_vector (1 downto 0);
    signal puerta       : std_logic;
    signal motor        : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 400 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : AscensorTop
    port map (CLK          => CLK,
              RST          => RST,
              botones_IN   => botones_IN,
              piso_actual  => piso_actual,
              --display_piso => display_piso,
             -- LEDs         => LEDs,
              puerta       => puerta,
              motor        => motor);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        botones_IN <= (others => '0');
        piso_actual <= (others => '0');

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

configuration cfg_top_tb of top_tb is
    for tb
    end for;
end cfg_top_tb;
