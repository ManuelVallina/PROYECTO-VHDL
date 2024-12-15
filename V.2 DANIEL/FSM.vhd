library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Para realizar operaciones aritméticas con std_logic_vector

entity FSM is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        ACTUAL : inout STD_LOGIC_VECTOR(1 downto 0); -- Ahora se actualiza internamente
        DESEADO : in STD_LOGIC_VECTOR(1 downto 0);
        PUERTA : in std_logic;
        ACCION_MOTOR : out std_logic_vector(1 downto 0);
        ACCION_PUERTA : out std_logic
    );
end FSM;

architecture Behavioral of FSM is
    TYPE estados IS (IDLE, VALIDANDO, ABIERTO, CERRADO, MARCHA, ERROR);
    SIGNAL estoy : estados := IDLE;
    SIGNAL sig_estado : estados := IDLE;

    SIGNAL piso_actual : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Interno para actualizar ACTUAL
    SIGNAL piso_deseado_valido : BOOLEAN := false;

    -- Señales internas para controlar las salidas
    SIGNAL motor_signal : std_logic_vector(1 downto 0) := "00"; -- Interna para ACCION_MOTOR
    SIGNAL puerta_signal : std_logic := '0'; -- Interna para ACCION_PUERTA
begin

-- Estado reset
estado_reset:
PROCESS(RESET, CLK)
begin
    IF RESET = '1' THEN
        estoy <= IDLE;
        piso_actual <= "00";
    elsif rising_edge(CLK) THEN
        estoy <= sig_estado;
    END IF;
END PROCESS;

-- Transiciones de estados
estado:
PROCESS(estoy, DESEADO, PUERTA, piso_actual)
begin
    sig_estado <= estoy; -- Default: mantener estado
    CASE estoy IS
        WHEN IDLE =>
            IF piso_actual /= "00" THEN
                sig_estado <= MARCHA; -- Regresar al piso base
            ELSE
                sig_estado <= VALIDANDO;
            END IF;

        WHEN VALIDANDO =>
            IF DESEADO >= "00" AND DESEADO <= "11" THEN
                piso_deseado_valido <= true;
                sig_estado <= ABIERTO; -- Transición inicial
            ELSE
                piso_deseado_valido <= false;
                sig_estado <= ERROR;
            END IF;

        WHEN ABIERTO =>
            IF piso_deseado_valido AND DESEADO /= piso_actual THEN
                sig_estado <= CERRADO;
            END IF;

        WHEN CERRADO =>
            IF PUERTA = '0' THEN
                sig_estado <= MARCHA;
            END IF;

        WHEN MARCHA =>
            IF piso_actual = DESEADO THEN
                sig_estado <= ABIERTO;
            END IF;

        WHEN ERROR =>
            -- Mantener estado hasta un reset
            NULL;

        WHEN OTHERS =>
            sig_estado <= IDLE;
    END CASE;
END PROCESS;

-- Lógica de salidas internas
OUT_FSM:
PROCESS(estoy, piso_actual, DESEADO)
begin
    -- Valores predeterminados
    motor_signal <= "00"; -- Parado
    puerta_signal <= '0'; -- Cerrado

    CASE estoy IS
        WHEN IDLE =>
            IF piso_actual /= "00" THEN
                motor_signal <= "10"; -- Bajar hasta 00
            END IF;

        WHEN ABIERTO =>
            puerta_signal <= '1'; -- Abrir puerta

        WHEN CERRADO =>
            puerta_signal <= '0'; -- Cerrar puerta

        WHEN MARCHA =>
            puerta_signal <= '0'; -- Cerrado
            IF DESEADO > piso_actual THEN
                motor_signal <= "01"; -- Subiendo
            ELSIF DESEADO < piso_actual THEN
                motor_signal <= "10"; -- Bajando
            END IF;

        WHEN ERROR =>
            motor_signal <= "00"; -- Parado
            puerta_signal <= '0'; -- Cerrado

        WHEN OTHERS =>
            motor_signal <= "00"; -- Parado
            puerta_signal <= '0'; -- Cerrado
    END CASE;
END PROCESS;

-- Actualización del piso actual
process(CLK, RESET)
begin
    if RESET = '1' then
        piso_actual <= "00";
    elsif rising_edge(CLK) then
        if estoy = MARCHA then
            if motor_signal = "01" then -- Subiendo
                piso_actual <= std_logic_vector(unsigned(piso_actual) + 1);
            elsif motor_signal = "10" then -- Bajando
                piso_actual <= std_logic_vector(unsigned(piso_actual) - 1);
            end if;
        end if;
    end if;
end process;

-- Actualización de salidas
ACTUAL <= piso_actual; -- Actualización de piso externo
ACCION_MOTOR <= motor_signal; -- Conexión a la señal interna
ACCION_PUERTA <= puerta_signal; -- Conexión a la señal interna

end Behavioral;
