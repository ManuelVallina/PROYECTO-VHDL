library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_DISPLAY is
    Port (
        CLK           : in  STD_LOGIC;                       -- Reloj
        RESET         : in  STD_LOGIC;                       -- Reset del sistema
        ACTUAL        : in  STD_LOGIC_VECTOR(1 downto 0);    -- Piso actual
        objetivo      : in  STD_LOGIC_VECTOR(1 downto 0);    -- Piso deseado
        ACCION_MOTOR  : in  STD_LOGIC_VECTOR(1 downto 0);    -- Motor: "00" parado, "01" sube, "10" baja
        ACCION_PUERTA : in  STD_LOGIC;                       -- Puerta: '1' abierta, '0' cerrada
        anim_marcha   : out STD_LOGIC;                       -- Animación para marcha
        selec         : out STD_LOGIC_VECTOR(1 DOWNTO 0);    -- Selección de animación
        anim_abierto  : out STD_LOGIC;                        -- Animación para abierto
        anim_cerrado :out STD_LOGIC;
        anim_error   :out STD_LOGIC;
        pasa_cerrado  : in std_logic;
        boton_reset :in std_logic
    );
end FSM_DISPLAY;

architecture Behavioral of FSM_DISPLAY is

    -- Estados de la FSM
    type estados is (ABIERTO, CERRADO, MARCHA, ERROR);
    signal estoy      : estados := ABIERTO;                 -- Estado actual
    signal sig_estado : estados := ABIERTO;                 -- Próximo estado

    -- Señales para animaciones
    signal sig_anim_abierto  : std_logic := '0';
    signal sig_anim_marcha   : std_logic := '0';
    signal sig_anim_cerrado  : std_logic := '0';
    signal sig_anim_error    : std_logic := '0';
    signal sig_selec         : std_logic_vector(1 downto 0) := "00";

begin

    -- Proceso síncrono: Maneja el estado actual
    process(CLK, RESET)
    begin
        if RESET = '0' then
            estoy <= ERROR;                               -- Reset al estado inicial
        elsif rising_edge(CLK) then
            estoy <= sig_estado;                           -- Actualización del estado
        end if;
    end process;

    -- Proceso combinacional: Transiciones entre estados
    process(estoy, ACCION_PUERTA, ACTUAL, objetivo)
    begin
        sig_estado <= estoy; -- Permanecer en el estado actual por defecto

        case estoy is
            when ABIERTO =>
                if pasa_cerrado = '1' then
                   sig_estado <= CERRADO;                 -- Transición a cerrado
                end if;

            when CERRADO =>
                if ACCION_MOTOR /= "00" then
                    sig_estado <= MARCHA;                  -- Transición a marcha si el motor está en movimiento
                end if;

            when MARCHA =>
                if ACTUAL = objetivo then
                    sig_estado <= ABIERTO;                 -- Transición a abierto si alcanza el piso objetivo
                end if;

            when ERROR =>
              if boton_reset >='1' then
                sig_estado <= ABIERTO;
               end if;
                                                  -- Estado de error, no hace nada hasta que RESET sea activado

            when others =>
                sig_estado <= ERROR;                      -- Estado no definido lleva a ERROR
        end case;
    end process;

    -- Proceso síncrono: Control de salidas y animaciones
    process(CLK, RESET)
    begin
        if RESET = '0' then
            sig_anim_abierto <= '0';
            sig_anim_marcha <= '0';
            sig_anim_error <= '1';
            sig_selec <= "11";
        elsif rising_edge(CLK) then
            -- Restablecer señales por defecto
            sig_anim_abierto <= '0';
            sig_anim_marcha <= '0';
            sig_selec <= "00";

            -- Actualizar según el estado
            case estoy is
                when ABIERTO =>
                    sig_anim_abierto <= '1';
                    sig_selec <= "00";

                when CERRADO =>
                    sig_anim_cerrado<='1';
                    sig_selec <= "10";

                when MARCHA =>
                    sig_anim_marcha <= '1';
                    sig_selec <= "01";

                when ERROR =>
                    sig_anim_error <='1';
                    sig_selec <= "11"; -- Opcional para depuración

                when others =>
                    sig_selec <= "11"; -- Opcional para depuración
            end case;
        end if;
    end process;

    -- Asignación de salidas
    anim_abierto <= sig_anim_abierto;
    anim_marcha  <= sig_anim_marcha;
    anim_cerrado <= sig_anim_cerrado;
    anim_error  <= sig_anim_error;
    selec        <= sig_selec;

end Behavioral;
