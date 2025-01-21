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
           botones_IN : in std_logic_vector(3 downto 0);---
           led_motor : out std_logic_vector(1 downto 0);
           led_puerta :out std_logic;
           segmentos :out STD_LOGIC_VECTOR(6 downto 0);
           selct_dig :out std_logic_vector(7 downto 0);
           ---------
           boton_reset : in std_logic;
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
        ACCION_PUERTA : out STD_LOGIC;              -- Puerta: '1' abierta, '0' cerrada
        boton_reinicio : in std_logic;
        signal_pasa_display: out std_logic
   
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

 COMPONENT  Bin_to_BCD 
  Port (
        bin_in  : in  STD_LOGIC_VECTOR (1 downto 0); -- Entrada binaria de 2 bits
        seg_out : out STD_LOGIC_VECTOR (6 downto 0)  -- Salida para 7 segmentos
    );
 end component;
 
 COMPONENT  FSM_DISPLAY 
  Port (
        CLK           : in  STD_LOGIC;                       -- Reloj
        RESET         : in  STD_LOGIC;                       -- Reset del sistema
        ACTUAL        : in  STD_LOGIC_VECTOR(1 downto 0);    -- Piso actual
        objetivo      : in  STD_LOGIC_VECTOR(1 downto 0);    -- Piso deseado
        ACCION_MOTOR  : in  STD_LOGIC_VECTOR(1 downto 0);    -- Motor: "00" parado, "01" sube, "10" baja
        ACCION_PUERTA : in  STD_LOGIC;                       -- Puerta: '1' abierta, '0' cerrada
        selec :out std_logic_vector(1 DOWNTO 0);
        anim_marcha   : out STD_LOGIC ;                     -- Animación para marcha
        anim_cerrado  : out STD_LOGIC;                       -- Animación para cerrado
        anim_abierto  : out STD_LOGIC;                        -- Animación para abierto
        anim_error    : out STD_LOGIC;
        boton_reset   : in std_logic;
        pasa_cerrado : in std_logic
    );
   end component;
   
  COMPONENT Accion_abierto 
  Port ( 
    clk        : IN std_logic;                     -- Reloj para el selector
    inicio     : IN std_logic;                     -- Señal de inicio
    segmentos  : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
    anodos     : OUT std_logic_vector(7 DOWNTO 0); -- Control de los ánodos (bit bajo = display activo)
    NUM        : IN std_logic_vector(6 DOWNTO 0)   -- Valor a mostrar
);
end component;

COMPONENT Accion_marcha
  Port ( 
    clk        : IN std_logic;                     -- Reloj para el selector
    inicio     : IN std_logic;                     -- Señal de inicio
    segmentos  : OUT std_logic_vector(6 DOWNTO 0); -- Señales de los segmentos (a-g)
    anodos     : OUT std_logic_vector(7 DOWNTO 0); -- Control de los ánodos (bit bajo = display activo)
    NUM        : IN std_logic_vector(6 DOWNTO 0)   -- Valor a mostrar
);
  end component;
 
 COMPONENT Accion_cerrado
  Port ( 
        clk        : in  std_logic;                  -- Señal de reloj
        inicio     : in  std_logic;                  -- Señal de inicio de la animación
        --NUM        : IN std_logic_vector(6 DOWNTO 0);  -- Valor a mostrar
        segmentos  : out std_logic_vector(6 downto 0); -- Señales para un display de 7 segmentos
        anodos     : out std_logic_vector(7 downto 0)  -- Señales para activar los displays (ánodos)
);
  end component;
 COMPONENT Accion_error
  Port ( 
        clk        : in  std_logic;                  -- Señal de reloj
        inicio     : in  std_logic;                  -- Señal de inicio de la animación
        segmentos  : out std_logic_vector(6 downto 0); -- Señales para un display de 7 segmentos
        anodos     : out std_logic_vector(7 downto 0)  -- Señales para activar los displays (ánodos)
);
  end component;
component SalidaPantalla
Port (
        -- Entradas de las 4 entidades
        segmentos_1 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 1
        anodos_1    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 1

        segmentos_2 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 2
        anodos_2    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 2

        segmentos_3 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 3
        anodos_3    : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 3
        
        segmentos_4 : IN std_logic_vector(6 DOWNTO 0); -- Señales de segmentos de la entidad 3
        anodos_4   : IN std_logic_vector(7 DOWNTO 0); -- Señales de ánodos de la entidad 3

       
        -- Señal de control para seleccionar la entidad activa
        seleccion   : IN std_logic_vector(1 DOWNTO 0); -- Selección: 00, 01, 10, 11

        -- Salidas combinadas
        segmentos   : OUT std_logic_vector(6 DOWNTO 0); -- Salida combinada de segmentos
        anodos      : OUT std_logic_vector(7 DOWNTO 0)  -- Salida combinada de ánodos
    );
end component;

  signal piso_deseado_passthrough : STD_LOGIC_VECTOR(1 downto 0);
  signal piso_seleccionado_signal : std_logic_vector (1 downto 0);
  signal accion_motor_signal : std_logic_vector (1 downto 0);
  signal accion_puerta_signal : std_logic;
  signal Act_fsm :  std_logic_vector (1 downto 0);
  signal piso_int : std_logic_vector (1 downto 0);
  signal piso_act : std_logic_vector (1 downto 0);
  signal piso_7seg: std_logic_vector (6 downto 0);
  signal salida_puerta :std_logic;
  signal pasa_sig : std_logic;
  
  ---
  signal abierto_anim : std_logic ;
  signal marcha_anim : std_logic ;
  signal cerrado_anim : std_logic ;
  signal error_anim : std_logic ;
  
  signal seleccion :std_logic_vector(1 downto 0);
  
  --ABRIR
  signal segmentos_accion_1 :STD_LOGIC_VECTOR(6 downto 0);
  SIGNAL anodos_accion_1 : STD_LOGIC_VECTOR(7 downto 0);
  -- MARCHA
  signal segmentos_accion_2 :STD_LOGIC_VECTOR(6 downto 0);
  SIGNAL anodos_accion_2 : STD_LOGIC_VECTOR(7 downto 0);
  -- CERRAR
  signal segmentos_accion_3 :STD_LOGIC_VECTOR(6 downto 0);
  SIGNAL anodos_accion_3 : STD_LOGIC_VECTOR(7 downto 0);
  
   signal segmentos_accion_4 :STD_LOGIC_VECTOR(6 downto 0);
  SIGNAL anodos_accion_4 : STD_LOGIC_VECTOR(7 downto 0);
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
           ACTUAL => piso_act,
           objetivo => piso_deseado_passthrough,            
           piso => piso_int, 
           ACCION_MOTOR => accion_motor_signal, -- Motor: "00" parado, "01" sube, "10" baja
           ACCION_PUERTA => accion_puerta_signal,          -- Puerta: '1' abierta, '0' cerrada
           boton_reinicio => boton_reset,
           signal_pasa_display => pasa_sig
);

inst_ControlMovimiento : ControlMovimiento port map(
       ACCION_MOTOR => accion_motor_signal,
       motor => led_motor

);

inst_ControlPuertas : ControlPuertas port map (
       ACCION_MOTOR => accion_motor_signal,
       ACCION_PUERTA => accion_puerta_signal,
       puerta => salida_puerta
);

 passthrough_inst : MultiplicadorPiso port map (
 
        piso_deseado => piso_seleccionado_signal,
        piso_out => piso_deseado_passthrough
  );
  -- Instancia de SelectorDisplay

decoder_inst : Bin_to_BCD port map (
        bin_in  => piso_act,
        seg_out => piso_7seg
        );

fsm_display_inst : FSM_DISPLAY port map (
        CLK         => clk,
        RESET       => rst,
        ACTUAL      => piso_act,
        objetivo    => piso_int,
        ACCION_MOTOR  => accion_motor_signal,   -- Motor: "00" parado, "01" sube, "10" baja
        ACCION_PUERTA => accion_puerta_signal,                      -- Puerta: '1' abierta, '0' cerrada
        selec => seleccion,
        anim_marcha   => marcha_anim,                    -- Animación para marcha
        anim_cerrado  => cerrado_anim,                   -- Animación para cerrado
        anim_abierto  =>  abierto_anim,
        anim_error    => error_anim,
        boton_reset   => boton_reset,
        pasa_cerrado => pasa_sig
);

inst_anim_abierto: Accion_abierto port map(

   clk       => clk,                   -- Reloj para el selector
   inicio    => abierto_anim,                -- Señal de inicio
   segmentos => segmentos_accion_1,-- Señales de los segmentos (a-g)
   anodos    => anodos_accion_1, -- Control de los ánodos (bit bajo = display activo)
   NUM       => piso_7seg   -- Valor a mostrar
);

inst_anim_marcha: Accion_marcha port map(

    clk       => clk,                   -- Reloj para el selector
    inicio    => marcha_anim,                -- Señal de inicio
    segmentos => segmentos_accion_2,-- Señales de los segmentos (a-g)
    anodos    => anodos_accion_2, -- Control de los ánodos (bit bajo = display activo)
    NUM       => piso_7seg   -- Valor a mostrar
);

inst_anim_cerrar: accion_cerrado port map(

       clk      => clk,              -- Señal de reloj
       inicio   => cerrado_anim,  
       --NUM      => piso_7seg,
       anodos    =>  anodos_accion_3,          -- Señal de inicio de la animación
       segmentos  => segmentos_accion_3
);
inst_anim_error: Accion_error port map(

   clk       => clk,                   -- Reloj para el selector
   inicio    => error_anim,                -- Señal de inicio
   segmentos => segmentos_accion_4,-- Señales de los segmentos (a-g)
   anodos    => anodos_accion_4 -- Control de los ánodos (bit bajo = display activo)
   
);
inst_salida_pantalla: SalidaPantalla port map (


        -- Entradas de las 4 entidades
        segmentos_1 => segmentos_accion_1,
        anodos_1    => anodos_accion_1,

        segmentos_2  => segmentos_accion_2,
        anodos_2     => anodos_accion_2,

        segmentos_3 => segmentos_accion_3,
        anodos_3  =>  anodos_accion_3,

       segmentos_4=> segmentos_accion_4,
        anodos_4  =>  anodos_accion_4,
        -- Señal de control para seleccionar la entidad activa
        seleccion  => seleccion,

        -- Salidas combinadas
        segmentos  => segmentos,
        anodos      =>selct_dig
 
);
led_puerta <= salida_puerta; 
ACTUAL_FSM <= piso_act;
--acc_motor_tb <= accion_motor_signal; 
--acc_puerta_tb <= accion_puerta_signal;
--ACTUAL_FSM <=Act_fsm;
--objetivo_tb <= piso_int;
--piso_selec_tb <= piso_deseado_passthrough;
end Behavioral;
