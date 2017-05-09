library IEEE;
use IEEE.std_logic_1164.all;

entity wow_crow is
    generic
    (
        SYS_CLK: integer := 50000000
    );
    port
    (
        CLK: in std_logic; 
        RST_n: in std_logic;
        
        -- LED
        LED: out STD_LOGIC_VECTOR(3 downto 0);
        
        -- digital tube
        DS_DP_n: out std_logic;
        DS_n: out std_logic_vector(6 downto 0); -- 6-0: a-g
        DS_EN_n: out std_logic_vector(5 downto 0);
        
        -- UART
        RXD: in std_logic;
        DBG_STATE: out std_logic_vector(2 downto 0);

        -- VGA
        VGA_HSYNC: out std_logic;
        VGA_VSYNC: out std_logic;
        VGA_RED: out std_logic_vector(4 downto 0);
        VGA_GREEN: out std_logic_vector(5 downto 0);
        VGA_BLUE: out std_logic_vector(4 downto 0)
    );
end;

architecture behavioral of wow_crow is
    component freq_div is
        generic
        (
            DIV: integer := 50
        );
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            O: out std_logic
        );
    end component;
    
    component digital_tube is
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            DA: in std_logic_vector(23 downto 0);
            DS_DP: out std_logic;
            DS: out std_logic_vector(6 downto 0); -- 6-0: a-g
            DS_EN: out std_logic_vector(5 downto 0)
        );
    end component;
    
    component uart is
    generic
    (
        CLK_FREQ: integer := SYS_CLK;
        BAUD: integer := 115200
    );
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        RXD: in std_logic;
        
        DATA_READ: out std_logic_vector(7 downto 0);
        DATA_READY: out std_logic;
        DATA_ERROR: out std_logic;
        DBG_STATE: out std_logic_vector(2 downto 0)
    );
    end component;
    
    component imu is
        generic
        (
            CLK_FREQ: integer := SYS_CLK;
            TIMEOUT_MS: integer := 20
        );
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            DATA: in std_logic_vector(7 downto 0);
            READY: in std_logic;
            
            -- outputs
            ERROR: out std_logic;
            Ax: out std_logic_vector(15 downto 0);
            Ay: out std_logic_vector(15 downto 0);
            Az: out std_logic_vector(15 downto 0);
            Wx: out std_logic_vector(15 downto 0);
            Wy: out std_logic_vector(15 downto 0);
            Wz: out std_logic_vector(15 downto 0);
            Hx: out std_logic_vector(15 downto 0);
            Hy: out std_logic_vector(15 downto 0);
            Hz: out std_logic_vector(15 downto 0);
            ROLL: out std_logic_vector(15 downto 0);
            PITCH: out std_logic_vector(15 downto 0);
            YAW: out std_logic_vector(15 downto 0)
        );
    end component;

    component vga_controller is
        generic
        (
            clock_freq: integer := 25000000;

            h_active: integer := 640;
            h_front_porch: integer := 16;
            h_sync_pulse: integer := 96;
            h_back_porch: integer := 48;

            v_active: integer := 480;
            v_front_porch: integer := 10;
            v_sync_pulse: integer := 2;
            v_back_porch: integer := 33
            -- TODO: sync pole
        );
        port
        (
            VGA_CLK: in std_logic;
            RST: in std_logic;

            -- Graphics RAM
            -- data should be ready at next clock positive edge.
            REN: out std_logic;
            X_ADDR: out std_logic_vector(15 downto 0);
            Y_ADDR: out std_logic_vector(15 downto 0);
            RED_DA: in std_logic_vector(4 downto 0);
            GREEN_DA: in std_logic_vector(5 downto 0);
            BLUE_DA: in std_logic_vector(4 downto 0);

            -- outputs
            HSYNC: out std_logic;
            VSYNC: out std_logic;
            RED: out std_logic_vector(4 downto 0);
            GREEN: out std_logic_vector(5 downto 0);
            BLUE: out std_logic_vector(4 downto 0)
        );
    end component;
    
    component renderer is
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            X: in std_logic_vector(15 downto 0);
            Y: in std_logic_vector(15 downto 0);

            RED_DA: out std_logic_vector(4 downto 0);
            GREEN_DA: out std_logic_vector(5 downto 0);
            BLUE_DA: out std_logic_vector(4 downto 0);

            Ax: in std_logic_vector(15 downto 0);
            Ay: in std_logic_vector(15 downto 0)
        );
    end component;
    
    signal RST: std_logic;

    signal CLK_25M, CLK_500: std_logic;

    signal DS_DA: std_logic_vector(23 downto 0);
    signal DS_DP: std_logic;
    signal DS: std_logic_vector(6 downto 0);
    signal DS_EN: std_logic_vector(5 downto 0);

    signal UART_DATA: std_logic_vector(7 downto 0);
    signal UART_DATA_READY: std_logic;

    signal VGA_X_ADDR: std_logic_vector(15 downto 0);
    signal VGA_Y_ADDR: std_logic_vector(15 downto 0);
    signal VGA_RED_DA: std_logic_vector(4 downto 0);
    signal VGA_GREEN_DA: std_logic_vector(5 downto 0);
    signal VGA_BLUE_DA: std_logic_vector(4 downto 0);
    
    signal IMU_Ax, IMU_Ay, IMU_Az: std_logic_vector(15 downto 0);
begin
    RST <= not RST_n;
    
    freq_div_25m_inst: freq_div
    generic map
    (
        DIV => SYS_CLK / 25000000
    )
    port map
    (
        CLK => CLK,
        RST => RST,
        O => CLK_25M
    );

    freq_div_500_inst: freq_div
    generic map
    (
        DIV => 25000000 / 500
    )
    port map
    (
        CLK => CLK_25M,
        RST => RST,
        O => CLK_500
    );

    DS_DP_n <= not DS_DP;
    DS_n <= not DS;
    DS_EN_n <= not DS_EN;

    digital_tube_inst: digital_tube
    port map
    (
        CLK => CLK_500,
        RST => RST,
        DA => DS_DA,
        DS_DP => DS_DP,
        DS => DS,
        DS_EN => DS_EN
    );
    
    LED(0) <= RXD;
    uart_inst: uart
    port map
    (
        CLK => CLK,
        RST => RST,
        RXD => RXD,
        DATA_READ => UART_DATA,
        DATA_READY => UART_DATA_READY,
        DATA_ERROR => LED(1),
        DBG_STATE => DBG_STATE
    );
    
    process(RST, UART_DATA_READY)
    begin
        if RST = '1' then
            DS_DA(23 downto 16) <= x"00";
        else
            if rising_edge(UART_DATA_READY) then
                DS_DA(23 downto 16) <= UART_DATA;
            end if;
        end if;
    end process;
    
    imu_inst: imu
    port map
    (
        CLK => CLK,
        RST => RST,
        DATA => UART_DATA,
        READY => UART_DATA_READY,
        ERROR => LED(2),
        
        Ax => IMU_Ax,
        Ay => IMU_Ay,
        Az => IMU_Az
    );
    DS_DA(15 downto 0) <= IMU_Az;

    vga_controller_inst: vga_controller
    port map
    (
        VGA_CLK => CLK_25M,
        RST => RST,
        X_ADDR => VGA_X_ADDR,
        Y_ADDR => VGA_Y_ADDR,
        RED_DA => VGA_RED_DA,
        GREEN_DA => VGA_GREEN_DA,
        BLUE_DA => VGA_BLUE_DA,
        HSYNC => VGA_HSYNC,
        VSYNC => VGA_VSYNC,
        RED => VGA_RED,
        GREEN => VGA_GREEN,
        BLUE => VGA_BLUE
    );
    
    renderer_inst: renderer
    port map
    (
        CLK => CLK_25M,
        RST => RST,
        X => VGA_X_ADDR,
        Y => VGA_Y_ADDR,
        RED_DA => VGA_RED_DA,
        GREEN_DA => VGA_GREEN_DA,
        BLUE_DA => VGA_BLUE_DA,
        
        Ax => IMU_Ax,
        Ay => IMU_Ay
    );
end;