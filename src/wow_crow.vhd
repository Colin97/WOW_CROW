library IEEE;
use IEEE.std_logic_1164.all;
use work.signals.all;
use work.state.all;
use work.image_info.all;

entity wow_crow is
    generic
    (
        SYS_CLK: integer := 100000000
    );
    port
    (
        CLK: in std_logic; 
        RST_n: in std_logic;
        LOGIC_RST_n: in std_logic;
        START_n: in std_logic;
        
        -- debug signals
        DBG: out std_logic_vector(55 downto 0);
          
        -- UART
        RXD: in std_logic;

        -- IR
        IR_RX: in std_logic;
        
        -- SRAM
        RAM_ADDR: out std_logic_vector(ADDR_WIDTH - 1 downto 0);
        RAM_DQ: inout std_logic_vector(WORD_WIDTH - 1 downto 0);
        RAM_WE_n: out std_logic;
        RAM_OE_n: out std_logic;
        RAM_CS_n: out std_logic;
        
        -- SD
        SD_CS_n: out std_logic; -- SD_NCS, SD_DATA3_CD
        SD_SCLK: out std_logic; -- SD_CLK
        SD_MISO: in std_logic;  -- SD_DOUT, SD_DATA0_DO
        SD_MOSI: out std_logic; -- SD_DIN, SD_CMD

        -- VGA
        VGA_HSYNC: out std_logic;
        VGA_VSYNC: out std_logic;
        VGA_RED: out std_logic_vector(2 downto 0);
        VGA_GREEN: out std_logic_vector(2 downto 0);
        VGA_BLUE: out std_logic_vector(2 downto 0);

        -- SOUND
        SOUND_OUT : out std_logic
    );
end;

architecture behavioral of wow_crow is
    component IR is 
        port (
            rst : in std_logic;
            clk : in std_logic;
            RX : in std_logic;
            data : out std_logic_vector(31 downto 0);
            done : out std_logic;
            repeat : out std_logic
        );
    end component;
    
    component remote_controller is
        generic
        (
            CLK_FREQ: integer := 1000000;
            TIMEOUT_MS: integer := 150
        );
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            DATA: in std_logic_vector(31 downto 0);
            READY: in std_logic;
            REPEAT: in std_logic;

            OK: out std_logic;
            UP: out std_logic
        );
    end component;

    component sound is 
        port (
            rst : in std_logic;
            clk : in std_logic;
            hit : in std_logic;
            game_over : in std_logic;
            sound_out : out std_logic
        );
    end component;

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
    
    component uart is
    generic
    (
        CLK_FREQ: integer := 25000000;
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
            CLK_FREQ: integer := 25000000;
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
            speed : out integer range 0 to 31;
            pos : out integer range 0 to 199
        );
    end component;

    component sram_controller is
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            
            -- connect to sram
            RAM_ADDR: out std_logic_vector(ADDR_WIDTH - 1 downto 0);
            RAM_DQ: inout std_logic_vector(WORD_WIDTH - 1 downto 0);
            RAM_WE_n: out std_logic;
            RAM_OE_n: out std_logic;
            
            -- internal wires
            BOOTLOADER_REQ: in RAM_REQ;
            BOOTLOADER_RES: out RAM_RES;
            VGA_REQ: in RAM_REQ;
            VGA_RES: out RAM_RES;
            RENDERER_REQ: in RAM_REQ;
            RENDERER_RES: out RAM_RES
        );
    end component;

    component bootloader is
        generic
        (
            WORD_WIDTH: integer := 32; -- word width of SRAM
            LOG2_WORD_WIDTH_DIV_8: integer := 2; -- log2(32 / 8)
            RAM_SIZE: integer := 1024 * 1024 * 32 / 8 -- SRAM size (bytes)
        );
        port
        (
            CLK: in std_logic; -- 25MHz
            RST: in std_logic;

            BL_REQ: out RAM_REQ;
            BL_RES: in RAM_RES;

            SD_CS_n: out std_logic; -- SD_NCS, SD_DATA3_CD
            SD_SCLK: out std_logic; -- SD_CLK
            SD_MISO: in std_logic;  -- SD_DOUT, SD_DATA0_DO
            SD_MOSI: out std_logic; -- SD_DIN, SD_CMD

            DONE: out std_logic;
            REJECTED: out std_logic;
            DBG: out std_logic_vector(3 downto 0)
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
            -- data should be ready before next clock positive edge.
            BASE_ADDR: std_logic_vector(ADDR_WIDTH - 1 downto 0);
            VGA_REQ: out RAM_REQ;
            VGA_RES: in RAM_RES;

            -- outputs
            HSYNC: out std_logic;
            VSYNC: out std_logic;
            RED: out std_logic_vector(2 downto 0);
            GREEN: out std_logic_vector(2 downto 0);
            BLUE: out std_logic_vector(2 downto 0);
            DONE: out std_logic
        );
    end component;

    component game_logic is 
        generic (
            MAX_LIFE: integer := 5;
            MAX_CROW: integer := 4;
            MAX_BULLET_PER_CROW : integer := 4;
            SCORE_INTERVAL : integer := 250;
            POS_INTERVAL : integer := 15;
            CROW_APPEAR_SCORE : integer := 300;
            WIDTH : integer := 320;
            MAX_SCORE : integer := 1048575
        );
        port (
            rst : in std_logic; 
            clk : in std_logic;

            pos : in integer range 0 to 199;
            speed : in integer range 0 to 31;
            hit : out std_logic;

            output_state : out STATE
        );
    end component;

    component render is 
        generic (
            VGA_WIDTH : integer := 640;
            VGA_HEIGHT : integer := 480
        );
        port (
            rst, clk : in std_logic;
            state : in STATE;
            vga_done : in std_logic;
            vga_addr : out std_logic_vector(19 downto 0);
            render_req: out RAM_REQ;
            render_res: in RAM_RES
        );
    end component;

    signal RST, LOGIC_RST: std_logic;

    signal CLK_25M, CLK_50M, CLK_1M, CLK_1000: std_logic;

    signal UART_DATA: std_logic_vector(7 downto 0);
    signal UART_DATA_READY: std_logic;

    signal BOOTLOADER_REQ: RAM_REQ;
    signal BOOTLOADER_RES: RAM_RES;
    signal VGA_REQ: RAM_REQ;
    signal VGA_RES: RAM_RES;
    signal RENDERER_REQ: RAM_REQ;
    signal RENDERER_RES: RAM_RES;

    signal bootloader_done: std_logic;
    signal internal_rst: std_logic;
    
    signal vga_base: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal vga_done: std_logic;
    signal bldbg: std_logic_vector(3 downto 0);
    signal addr_buff: std_logic_vector(19 downto 0);
    signal pos : integer range 0 to 199;
    signal speed : integer range 0 to 31;
    signal game_state : STATE;
    signal started: std_logic;
    signal hit : std_logic;
    signal IR_DATA : std_logic_vector(31 downto 0);
    signal IR_DONE, IR_REPEAT, RC_OK, RC_UP : std_logic;
    signal start: std_logic;
    signal game_over : std_logic;
begin
    RST <= not RST_n;
    internal_rst <= RST or not bootloader_done;
    LOGIC_RST <= (RC_UP or not LOGIC_RST_n) or internal_rst;
    RAM_CS_n <= '0';
    
    start <= not START_n or RC_OK;
    
    process(start, LOGIC_RST)
    begin
        if LOGIC_RST = '1' then
            started <= '0';
        elsif rising_edge(start) then
            started <= '1';
        end if;
    end process;

    freq_div_25m_inst: freq_div
    generic map
    (
        DIV => 100000000 / 25000000
    )
    port map
    (
        CLK => CLK,
        RST => RST,
        O => CLK_25M
    );
    
    freq_div_50m_inst: freq_div
    generic map
    (
        DIV => 100000000 / 50000000
    )
    port map
    (
        CLK => CLK,
        RST => RST,
        O => CLK_50M
    );
    
    freq_div_1m_inst: freq_div
    generic map
    (
        DIV => 50000000 / 1000000
    )
    port map
    (
        CLK => CLK_50M,
        RST => RST,
        O => CLK_1M
    );

    freq_div_1000_inst: freq_div
    generic map
    (
        DIV => 1000000 / 1000
    )
    port map
    (
        CLK => CLK_1M,
        RST => RST,
        O => CLK_1000
    );

    DBG(0) <= RXD;
    uart_inst: uart
    port map
    (
        CLK => CLK_25M,
        RST => RST,
        RXD => RXD,
        DATA_READ => UART_DATA,
        DATA_READY => UART_DATA_READY,
        DATA_ERROR => DBG(1)
    );
    
    imu_inst: imu
    port map
    (
        CLK => CLK_25M,
        RST => RST,
        DATA => UART_DATA,
        READY => UART_DATA_READY,
        ERROR => DBG(2),

        pos => pos,
        speed => speed
    );
    
    DBG(3) <= RST_n;
    --DBG(4) <= game_state.crows(0).in_screen;
    --DBG(5) <= game_state.crows(1).in_screen;
    DBG(4) <= RC_OK;
    DBG(5) <= RC_UP;
    DBG(6) <= game_state.crows(2).in_screen;
    DBG(7) <= game_state.crows(3).in_screen;
    DBG(11 downto 8) <= addr_buff(19 downto 16);
    DBG(15 downto 12) <= bldbg;
    DBG(47 downto 16) <= RAM_DQ;
    RAM_ADDR <= addr_buff;

    sram_controller_inst: sram_controller
    port map
    (
        CLK => CLK_25M,
        RST => internal_rst,
        
        RAM_ADDR => addr_buff,
        RAM_DQ => RAM_DQ,
        RAM_WE_n => RAM_WE_n,
        RAM_OE_n => RAM_OE_n,
        
        BOOTLOADER_REQ => BOOTLOADER_REQ,
        BOOTLOADER_RES => BOOTLOADER_RES,
        VGA_REQ => VGA_REQ,
        VGA_RES => VGA_RES,
        RENDERER_REQ => RENDERER_REQ,
        RENDERER_RES => RENDERER_RES
    );
    
    bootloader_inst: bootloader
    port map
    (
        CLK => CLK_25M,
        RST => RST,
        
        BL_REQ => BOOTLOADER_REQ,
        BL_RES => BOOTLOADER_RES,
        
        SD_CS_n => SD_CS_n,
        SD_SCLK => SD_SCLK,
        SD_MISO => SD_MISO,
        SD_MOSI => SD_MOSI,
        
        DONE => bootloader_done,
        DBG => bldbg
    );
    
    vga_controller_inst: vga_controller
    port map
    (
        VGA_CLK => CLK_25M,
        RST => internal_rst,
        
        BASE_ADDR => vga_base,
        VGA_REQ => VGA_REQ,
        VGA_RES => VGA_RES,
        
        HSYNC => VGA_HSYNC,
        VSYNC => VGA_VSYNC,
        RED => VGA_RED,
        GREEN => VGA_GREEN,
        BLUE => VGA_BLUE,
        DONE => vga_done
    );

    game_logic_inst : game_logic
    port map (
        rst => LOGIC_RST or not started,
        clk => CLK_1000,

        pos => pos,
        speed => speed,
        hit => hit,

        output_state => game_state
    );

    render_inst : render
    port map (
        rst => LOGIC_RST,
        clk => CLK_25M,
        state => game_state,
        vga_done => vga_done,
         vga_addr => vga_base,
        render_req => RENDERER_REQ,
        render_res => RENDERER_RES
    );

	game_over <= '1' when game_state.state = 2 else '0';
    sound_inst : sound 
    port map (
        rst => LOGIC_RST,
        clk => CLK_1000,
        hit => hit,
        game_over => game_over,
        sound_out => SOUND_OUT   
    );

    IR_inst : IR
    port map (
        rst => internal_rst,
        clk => CLK_1M,
        RX => IR_RX,
        data => IR_DATA,
        done => IR_DONE,
        repeat => IR_REPEAT
    );
    
    remote_controller_inst: remote_controller
    port map
    (
        CLK => CLK_1M,
        RST => internal_rst,
        DATA => IR_DATA,
        READY => IR_DONE,
        REPEAT => IR_REPEAT,

        OK => RC_OK,
        UP => RC_UP
    );
end;