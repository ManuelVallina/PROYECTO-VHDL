library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
  PORT(
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           botones_IN : in std_logic_vector(3 downto 0);
           led_motor : out std_logic_vector(1 downto 0);
           led_puerta : out std_logic;
           segmentos : out STD_LOGIC_VECTOR(6 downto 0);
           anodos : out STD_LOGIC_VECTOR(3 downto 0);
           ACTUAL_FSM : out std_logic_vector(1 downto 0)
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

COMPONENT DisplaySnake 
PORT (
        piso : in  STD_LOGIC_VECTOR(1 downto 0); -- Entrada del piso (2 bits)
        display : out STD_LOGIC_VECTOR(6 downto 0) -- Salida al display 7 segmentos
);
end component;

COMPONENT BCD_to_Cathodes
PORT (
        digit : in STD_LOGIC_VECTOR(3 downto 0);
        cathode : out STD_LOGIC_VECTOR(7 downto 0)
);
end component;

COMPONENT BCD_control
PORT (
        digit1 : in STD_LOGIC_VECTOR(3 downto 0);
        digit2 : in STD_LOGIC_VECTOR(3 downto 0);
        digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        digit4 : in STD_LOGIC_VECTOR(3 downto 0);
        refreshcounter : in STD_LOGIC_VECTOR(1 downto 0);
        ONE_DIGIT : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

COMPONENT anode_control
PORT (
        refreshcounter : in STD_LOGIC_VECTOR(1 downto 0);
        anode : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

COMPONENT refreshcounter
PORT (
        refresh_clock : in STD_LOGIC;
        refreshcounter : out STD_LOGIC_VECTOR(1 downto 0)
);
end component;

signal piso_deseado_passthrough : STD_LOGIC_VECTOR(1 downto 0);
signal piso_seleccionado_signal : std_logic_vector (1 downto 0);
signal accion_motor_signal : std_logic_vector (1 downto 0);
signal accion_puerta_signal : std_logic;
signal Act_fsm :  std_logic_vector (1 downto 0);
signal piso_int : std_logic_vector (1 downto 0);
signal piso_act : std_logic_vector (1 downto 0);
signal refreshcounter_signal : STD_LOGIC_VECTOR(1 downto 0);
signal one_digit_signal : STD_LOGIC_VECTOR(3 downto 0);
signal cathodes_signal : STD_LOGIC_VECTOR(7 downto 0);
begin

inst_SelectorPiso: SelectorPiso port map(
           CLK => CLK,
           RST => RST,
           botones_IN => botones_IN,
           piso_seleccionado => piso_seleccionado_signal
);

inst_FSM :FSM port map(
           CLK => CLK,
           RESET => RST,
           ACTUAL => piso_act,
           objetivo => piso_deseado_passthrough,            
           piso => piso_int, 
           ACCION_MOTOR => accion_motor_signal,
           ACCION_PUERTA => accion_puerta_signal
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

inst_DisplaySnake: DisplaySnake port map(
        piso => piso_act,
        display => segmentos
);

inst_refreshcounter: refreshcounter port map(
        refresh_clock => CLK,
        refreshcounter => refreshcounter_signal
);

inst_anode_control: anode_control port map(
        refreshcounter => refreshcounter_signal,
        anode => anodos
);

inst_BCD_control: BCD_control port map(
        digit1 => "0000", -- Replace with actual digits if needed
        digit2 => "0000",
        digit3 => "0000",
        digit4 => "0000",
        refreshcounter => refreshcounter_signal,
        ONE_DIGIT => one_digit_signal
);

inst_BCD_to_Cathodes: BCD_to_Cathodes port map(
        digit => one_digit_signal,
        cathode => cathodes_signal
);

ACTUAL_FSM <= piso_act;

end Behavioral;
