library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        ACTUAL : out STD_LOGIC_VECTOR(1 downto 0);  -- Cambiado a out
        DESEADO : in STD_LOGIC_VECTOR(1 downto 0);
        PUERTA : in STD_LOGIC;
        ACCION_MOTOR : out STD_LOGIC_VECTOR(1 downto 0);
        ACCION_PUERTA : out STD_LOGIC
    );
end FSM;

architecture Behavioral of FSM is
    -- Definición de estados
    TYPE estados IS (IDLE, VALIDANDO, ABIERTO, CERRADO, MARCHA, ACTUALIZAR, ERROR);
    SIGNAL estoy : estados := IDLE;
    SIGNAL sig_estado : estados := IDLE;

    SIGNAL piso_actual : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Piso actual
    SIGNAL motor_signal : STD_LOGIC_VECTOR(1 downto 0) := "00";
    SIGNAL puerta_signal : STD_LOGIC := '0';

begin

    -- Proceso síncrono: actualiza el estado y piso_actual
    PROCESS (CLK, RESET)
    begin
        IF RESET = '1' THEN
            estoy <= IDLE;
            piso_actual <= "00";
        ELSIF rising_edge(CLK) THEN
            estoy <= sig_estado;
            
            -- Actualización de piso_actual sincronizada
            IF estoy = ACTUALIZAR THEN
                IF piso_actual < DESEADO THEN
                    piso_actual <= std_logic_vector(unsigned(piso_actual) + 1);
                ELSIF piso_actual > DESEADO THEN
                    piso_actual <= std_logic_vector(unsigned(piso_actual) - 1);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Proceso combinacional: lógica de transición de estados
    PROCESS (estoy, piso_actual, DESEADO, PUERTA)
    begin
        sig_estado <= estoy;  -- Por defecto, permanecer en el mismo estado
        
        CASE estoy IS
            WHEN IDLE =>
                IF piso_actual /= "00" THEN
                    sig_estado <= MARCHA;
                ELSE
                    sig_estado <= VALIDANDO;
                END IF;

            WHEN VALIDANDO =>
                IF DESEADO >= "00" AND DESEADO <= "10" THEN
                    sig_estado <= ABIERTO;
                ELSE
                    sig_estado <= ERROR;
                END IF;

            WHEN ABIERTO =>
                IF piso_actual /= DESEADO  THEN
                    sig_estado <= CERRADO;
                END IF;

            WHEN CERRADO =>
                IF PUERTA = '0' THEN
                    sig_estado <= MARCHA;
                END IF;

            WHEN MARCHA =>
                IF piso_actual = DESEADO THEN
                    sig_estado <= ABIERTO;
                ELSE
                    sig_estado <= ACTUALIZAR;
                END IF;

            WHEN ACTUALIZAR =>
                sig_estado <= MARCHA;

            WHEN ERROR =>
                NULL;  -- Estado de error, espera hasta RESET

            WHEN OTHERS =>
                sig_estado <= IDLE;
        END CASE;
    END PROCESS;

    -- Proceso combinacional: lógica de salidas
    PROCESS (estoy, piso_actual, DESEADO)
    begin
        -- Valores predeterminados
        motor_signal <= "00";
        puerta_signal <= '0';

        CASE estoy IS
            WHEN ABIERTO =>
                puerta_signal <= '1';

            WHEN CERRADO =>
                puerta_signal <= '0';

            WHEN MARCHA =>
                IF piso_actual < DESEADO THEN
                    motor_signal <= "01"; -- Subiendo
                ELSIF piso_actual > DESEADO THEN
                    motor_signal <= "10"; -- Bajando
                ELSE
                    motor_signal <= "00"; -- Parado
                END IF;

            WHEN OTHERS =>
                motor_signal <= "00";
                puerta_signal <= '0';
        END CASE;
    END PROCESS;

    -- Asignación de salidas
    ACTUAL <= piso_actual;
    ACCION_MOTOR <= motor_signal;
    ACCION_PUERTA <= puerta_signal;

end Behavioral;
