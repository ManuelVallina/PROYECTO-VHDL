----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 11:36:14
-- Design Name: 
-- Module Name: BotoneraAntirrebotes - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BotoneraAntirrebotes is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           BotonIN : in std_logic_vector(3 downto 0);
           BotonOUT : out std_logic_vector(3 downto 0));
end BotoneraAntirrebotes;

architecture Structural of BotoneraAntirrebotes is
component Antirrebotes
 PORT(
  CLK : in std_logic;
  RST: in std_logic;
  logic_IN : in std_logic;
  logic_OUT : out std_logic );
end component;
begin
 Antirrebote0:Antirrebotes
 Port map (
  CLK => CLK,
  logic_IN => BotonIN(0),
  logic_OUT => BotonOUT(0),
  RST => RST
 );
 
  Antirrebote1:Antirrebotes
 Port map (
  CLK => CLK,
  logic_IN => BotonIN(1),
  logic_OUT => BotonOUT(1),
  RST => RST
 );
 
  Antirrebote2:Antirrebotes
 Port map (
  CLK => CLK,
  logic_IN => BotonIN(2),
  logic_OUT => BotonOUT(2),
  RST => RST
 );
 
  Antirrebote3:Antirrebotes
 Port map (
  CLK => CLK,
  logic_IN => BotonIN(3),
  logic_OUT => BotonOUT(3),
  RST => RST
 );
 


end Structural;
