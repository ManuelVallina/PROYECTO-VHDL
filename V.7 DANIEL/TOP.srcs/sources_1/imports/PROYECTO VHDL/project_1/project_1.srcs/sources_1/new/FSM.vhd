library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        ACTUAL : out STD_LOGIC_VECTOR(1 downto 0);  -- Estado actual del ascensor
        objetivo : in STD_LOGIC_VECTOR(1 downto 0);  -- Piso deseado
        -- PUERTA : in STD_LOGIC;        
        --aux :out STD_LOGIC_VECTOR(1 downto 0);            -- Estado de la puerta (abierta o cerrada)
        piso : inout STD_LOGIC_VECTOR(1 downto 0); 
        ACCION_MOTOR : out STD_LOGIC_VECTOR(1 downto 0); -- Motor: "00" parado, "01" sube, "10" baja
        ACCION_PUERTA : out STD_LOGIC               -- Puerta: '1' abierta, '0' cerrada
        
    );
end FSM;

architecture Behavioral of FSM is
    -- Estados de la FSM
    type estados is (IDLE, VALIDANDO, ABIERTO, CERRADO, MARCHA, ACTUALIZAR, ERROR);
    signal estoy : estados := IDLE;
    signal sig_estado : estados := IDLE;

    -- Señales internas
    signal piso_actual : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal motor_signal : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal puerta_signal : STD_LOGIC := '0';

    -- Señales del temporizador
    signal timer_timeout : STD_LOGIC := '0';         -- Salida del temporizador
    signal time_set : INTEGER := 100000000;               -- Tiempo para cada estado

    signal DESEADO :  STD_LOGIC_VECTOR(1 downto 0):="00";
    signal DESEADO_1 :  STD_LOGIC_VECTOR(1 downto 0):="00";
    -- Instancia del temporizador
    component Temporizador is
        Port (
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            TIME_SET : in INTEGER;       -- Tiempo en ciclos de reloj
            TIME_OUT : out STD_LOGIC     -- Señal de salida cuando el tiempo transcurre
        );
    end component;

begin

    TEMPORIZADOR_INST: Temporizador
        port map (
            CLK => CLK,
            RESET => RESET,
            TIME_SET => time_set,
            TIME_OUT => timer_timeout
        );

    -- Proceso síncrono para actualizar el estado y piso_actual
    process (CLK, RESET)
    begin
        if RESET = '0' then
            estoy <= IDLE;
          --  motor_signal <= "00";
          --  puerta_signal <= '0';
            piso_actual <= piso;
        elsif rising_edge(CLK) then
            estoy <= sig_estado;

            -- Actualización del piso actual (si se está moviendo)
            if estoy = ACTUALIZAR then
                if piso_actual < piso then
                    piso_actual <= std_logic_vector(unsigned(piso_actual) + 1);
                elsif piso_actual > piso then
                    piso_actual <= std_logic_vector(unsigned(piso_actual) - 1);
                end if;
            end if;
        end if;
    end process;

    -- Proceso combinacional: lógica de transición de estados
    process (estoy, piso_actual, timer_timeout)
    begin
        sig_estado <= estoy;  -- Por defecto, permanecer en el mismo estado
        time_set <= 100000000;      -- Tiempo predeterminado (en ciclos de reloj)
       -- ACTUAL <= piso_actual;
        case estoy is
            when IDLE =>
                if piso_actual /= "00" then
                    sig_estado <= MARCHA;
                else
                    sig_estado <= VALIDANDO;
                end if;

            when VALIDANDO =>
               
                if DESEADO >= "00" and DESEADO <= "10" then
                    sig_estado <= ABIERTO;
                else
                    sig_estado <= ERROR;
                end if;
         
            when ABIERTO =>
                time_set <= 100000000;  -- Tiempo de espera con la puerta abierta
                if timer_timeout = '1' and piso_actual /= objetivo then
                    piso <= objetivo;
                    sig_estado <= CERRADO;
                    
                end if;

            when CERRADO =>
                
                time_set <= 100000000;  -- Tiempo de espera con la puerta cerrada
                if timer_timeout = '1' then
                    sig_estado <= MARCHA;
                end if;

            when MARCHA =>
                
                if piso_actual = piso then
                    sig_estado <= VALIDANDO;
                else
                 time_set <= 100000000;
                 if timer_timeout = '1' then
                    sig_estado <= ACTUALIZAR;
                 end if;
                end if;
               

            when ACTUALIZAR =>
                sig_estado <= MARCHA;

            when ERROR =>
                null;  -- Estado de error, espera hasta RESET

            when others =>
                sig_estado <= IDLE;
        end case;
    end process;

    -- Proceso combinacional: lógica de salidas
    process (estoy, piso_actual)
    begin
        -- Valores predeterminados
        motor_signal <= "00";
        puerta_signal <= '0';

        case estoy is
            when ABIERTO =>
                puerta_signal <= '1'; -- Puerta abierta

            when CERRADO =>
                puerta_signal <= '0'; -- Puerta cerrada

            when MARCHA =>
              
               
                if piso_actual < piso then
                    motor_signal <= "01"; -- Subiendo
                elsif piso_actual > piso then
                    motor_signal <= "10"; -- Bajando
                else
                    motor_signal <= "00"; -- Parado
                end if;
        
            when others =>
                motor_signal <= "00";
                puerta_signal <= '0';
        end case;
    end process;

    -- Asignación de salidas
    ACTUAL <= piso_actual;
    ACCION_MOTOR <= motor_signal;
    ACCION_PUERTA <= puerta_signal;
    --AUX <= PISO;
    

end Behavioral;
