----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2024 20:10:26
-- Design Name: 
-- Module Name: TOP - Behavioral
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



entity TOP is
  PORT(
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           botones_IN : in std_logic_vector(3 downto 0);
           led_motor : out std_logic_vector(1 downto 0);
           led_puerta :out std_logic;
           ---------
           ACTUAL_FSM :out std_logic_vector(1 downto 0)
          -- acc_motor_tb: out STD_LOGIC_VECTOR(1 downto 0);
          -- acc_puerta_tb :out std_logic;
          -- objetivo_tb: out STD_LOGIC_VECTOR(1 downto 0);
         --  piso_selec_tb: out std_logic_vector(1 downto 0)
           
           
     );

end TOP;

architecture Behavioral of TOP is

component SelectorPiso 
  PORT (
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           botones_IN : in std_logic_vector(3 downto 0);
           piso_seleccionado : out std_logic_vector(1 downto 0)
  
  );
 end component;
 
 component FSM
   PORT (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        ACTUAL : out STD_LOGIC_VECTOR(1 downto 0);  -- Estado actual del ascensor
        objetivo : in STD_LOGIC_VECTOR(1 downto 0);  -- Piso deseado        
        piso : inout STD_LOGIC_VECTOR(1 downto 0); 
        ACCION_MOTOR : out STD_LOGIC_VECTOR(1 downto 0); -- Motor: "00" parado, "01" sube, "10" baja
        ACCION_PUERTA : out STD_LOGIC               -- Puerta: '1' abierta, '0' cerrada
        
   
   );
 end component;


component ControlMovimiento

PORT(
       ACCION_MOTOR : in STD_LOGIC_VECTOR(1 downto 0);
       motor : out STD_LOGIC_VECTOR(1 downto 0) -- 00: Parado, 01: Subiendo, 10: Bajando

);
end component;

component ControlPuertas
PORT(
        ACCION_MOTOR : in STD_LOGIC_VECTOR(1 downto 0);
        ACCION_PUERTA : in STD_LOGIC;
        puerta : out STD_LOGIC -- 1: Abierta, 0: Cerrada
);


end component;

COMPONENT MultiplicadorPiso
PORT(
    piso_deseado : in std_logic_vector(1 downto 0);
    piso_out : out std_logic_vector(1 downto 0)
);
 end component; 
 
  signal piso_deseado_passthrough : STD_LOGIC_VECTOR(1 downto 0);
  signal piso_seleccionado_signal : std_logic_vector (1 downto 0);
  signal accion_motor_signal : std_logic_vector (1 downto 0);
  signal accion_puerta_signal : std_logic;
  signal Act_fsm :  std_logic_vector (1 downto 0);
  signal piso_int : std_logic_vector (1 downto 0);
 
begin

inst_SelectorPiso: SelectorPiso port map(
           CLK => CLK,
           RST => rst,
           botones_IN => botones_in,
           piso_seleccionado => piso_seleccionado_signal
);

inst_FSM :FSM port map(
           CLK => CLK,
           RESET =>rst,
           ACTUAL => ACTUAL_FSM,
           objetivo => piso_deseado_passthrough,            
           piso => piso_int, 
           ACCION_MOTOR => accion_motor_signal, -- Motor: "00" parado, "01" sube, "10" baja
           ACCION_PUERTA => accion_puerta_signal           -- Puerta: '1' abierta, '0' cerrada
);

inst_ControlMovimiento : ControlMovimiento port map(
       ACCION_MOTOR => accion_motor_signal,
       motor => led_motor

);

inst_ControlPuertas : ControlPuertas port map (
       ACCION_MOTOR => accion_motor_signal,
       ACCION_PUERTA => accion_puerta_signal,
       puerta => led_puerta
);

 passthrough_inst : MultiplicadorPiso port map (
 
        piso_deseado => piso_seleccionado_signal,
        piso_out => piso_deseado_passthrough
  );
  
--acc_motor_tb <= accion_motor_signal; 
--acc_puerta_tb <= accion_puerta_signal;
--ACTUAL_FSM <=Act_fsm;
--objetivo_tb <= piso_int;
--piso_selec_tb <= piso_deseado_passthrough;
end Behavioral;
