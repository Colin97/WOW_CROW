library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sd_test is
port (
    led_out_state: out std_logic_vector(2 downto 0);
    ------------------------------------------------
	cs : out std_logic;
	mosi : out std_logic;
	miso : in std_logic;
	sclk : out std_logic;
	----------------------------sram----------------
	
    sram_addr: buffer std_logic_vector (20 downto 0) := (others=>'0');
    sram_data: inout std_logic_vector (31 downto 0);
    sram_rw:   buffer std_logic_vector (1 downto 0) := "11";
    
    -----------------------------vga----------------
    vga_clock	: out std_logic;
	vga_hs, vga_vs	: out std_logic;		--行同步、场同步信号
	vga_red	: out std_logic_vector (2 downto 0);
	vga_green	: out std_logic_vector (2 downto 0);
	vga_blue	: out std_logic_vector (2 downto 0);
	
	mode_ctrl: in std_logic;

	rd : in std_logic;
--	wr : in std_logic;
--	dm_in : in std_logic;	-- data mode, 0 = write continuously, 1 = write single block
	reset_in : in std_logic;
--	din : in std_logic_vector(7 downto 0);
	clk_in : in std_logic	-- twice the SPI clk
);

end sd_test;

architecture rtl of sd_test is


component VGA_Controller is
	port (
	--VGA Side
		VGA_CLK	: out std_logic;
		hs,vs	: out std_logic;		--行同步、场同步信号
		oRed	: out std_logic_vector (2 downto 0);
		oGreen	: out std_logic_vector (2 downto 0);
		oBlue	: out std_logic_vector (2 downto 0);

        in_data    : in std_logic_vector (23 downto 0);

		req_addr: out std_logic_vector (18 downto 0);
	--Control Signals
		reset	: in  std_logic;
		CLK_in	: in  std_logic			--100M时钟输入
	);		
end component;


type states is (
	RST,
	INIT,
	CMD0,
	CMD55,
	CMD41,
	POLL_CMD,
	
	DISPLAY,
	NEXT_IMG,
  
	IDLE,	-- wait for read or write pulse
	READ_BLOCK,
	READ_BLOCK_WAIT,
	READ_BLOCK_DATA,
	READ_BLOCK_CRC,
	SEND_CMD,
	RECEIVE_BYTE_WAIT,
	RECEIVE_BYTE,
	WRITE_BLOCK_CMD,
	WRITE_BLOCK_INIT,		-- initialise write command
	WRITE_BLOCK_DATA,		-- loop through all data bytes
	WRITE_BLOCK_BYTE,		-- send one byte
	WRITE_BLOCK_WAIT		-- wait until not busy
);


-- one start byte, plus 512 bytes of data, plus two FF end bytes (CRC)
constant WRITE_DATA_SIZE : integer := 515;
constant IGNORE_SIZE: integer := 69118;


signal state, return_state : states;
signal sclk_sig : std_logic := '0';
signal cmd_out : std_logic_vector(55 downto 0);
signal recv_data : std_logic_vector(7 downto 0);
signal address : std_logic_vector(31 downto 0) := x"00000000";
signal cmd_mode : std_logic := '1';
signal data_mode : std_logic := '1';
signal response_mode : std_logic := '1';
signal data_sig : std_logic_vector(7 downto 0) := x"00";


signal dout : std_logic_vector(7 downto 0);
signal sram_read_now: std_logic := '0';

signal s_sram_data: std_logic_vector(31 downto 0) := (others=>'0');

signal wr : std_logic := '0';
signal dm_in : std_logic := '0';	-- data mode, 0 = write continuously, 1 = write single block
signal reset : std_logic;
signal din : std_logic_vector(7 downto 0);
signal clk: std_logic := '0';

signal vga_addr: std_logic_vector(18 downto 0) := (others=>'0');
signal vga_data: std_logic_vector(23 downto 0) := (others=>'0');

signal img_start_addr: std_logic_vector(31 downto 0):= (others=>'0');

signal continue_mode: std_logic := '0';
signal continue_clock: std_logic;
signal continue_count: std_logic_vector(31 downto 0);

signal real_rd: std_logic;

begin

    process(clk_in)
    begin
        if clk_in'event and clk_in = '1' then
            continue_count <= continue_count + 1;
            if continue_count = 150000000 then
                continue_clock <= not continue_clock;
                continue_count <= (others=>'0');
            end if;
        end if;
    end process;

    process(mode_ctrl)
	begin
	    if mode_ctrl'event and mode_ctrl = '1' then
            continue_mode <= not continue_mode;
        end if;
    end process;

    reset <= not reset_in;
    process(clk_in)
    begin
        if clk_in'event and clk_in = '1' then
            clk <= not clk;
        end if;
    end process;
    
    real_rd <= (continue_mode and continue_clock) or (not continue_mode and rd);
  
	process(clk,reset)
		variable byte_counter : integer range 0 to WRITE_DATA_SIZE;
		variable bit_counter : integer range 0 to 160;
		variable sram_byte_count : integer range 0 to 5;
		variable ignored_size : integer range 0 to IGNORE_SIZE;
	begin
		data_mode <= dm_in;

		if rising_edge(clk) then
			if (reset='1') then
				state <= RST;
				sclk_sig <= '0';
			else
				case state is
                   
                when DISPLAY =>
                    if real_rd = '0' then
                        state <= NEXT_IMG;
                    end if;
                    sram_rw <= "11";
                    sram_data <= (others=>'Z');
                    vga_data <= sram_data(23 downto 0);
                    sram_addr(18 downto 0) <= vga_addr;
                    sram_addr(20 downto 19) <= "00";
                    led_out_state <= "100";
                
                when NEXT_IMG =>
                    address <= std_logic_vector(unsigned(img_start_addr) + x"12C200");
					sclk_sig <= '0';
					cmd_out <= (others => '1');
					byte_counter := 0;
					cmd_mode <= '1'; -- 0=data, 1=command
					response_mode <= '1';	-- 0=data, 1=command
					bit_counter := 160;
					cs <= '1';
					
					ignored_size := IGNORE_SIZE;
					--------sram--------
					sram_data <= (others=>'Z');
					sram_rw <= "11";
					sram_addr <= (others=>'0');
					sram_byte_count := 0;
					sram_read_now <= '0';
					---------------------
					state <= INIT;
					led_out_state <= "000";
				
				when RST =>
				    img_start_addr <= (others=>'0');
					sclk_sig <= '0';
					cmd_out <= (others => '1');
					byte_counter := 0;
					address <= x"00000000";
					cmd_mode <= '1'; -- 0=data, 1=command
					response_mode <= '1';	-- 0=data, 1=command
					bit_counter := 160;
					cs <= '1';
					
					ignored_size := IGNORE_SIZE;
					--------sram--------
					sram_data <= (others=>'Z');
					sram_rw <= "11";
					sram_addr <= (others=>'0');
					sram_byte_count := 0;
					sram_read_now <= '0';
					---------------------
					state <= INIT;
					led_out_state <= "000";
				
				when INIT =>		-- CS=1, send 80 clocks, CS=0
					img_start_addr <= address;
					if (bit_counter = 0) then
						cs <= '0';
						state <= CMD0;
					else
						bit_counter := bit_counter - 1;
						sclk_sig <= not sclk_sig;
					end if;	
				
				when CMD0 =>
					cmd_out <= x"FF400000000095";
					bit_counter := 55;
					return_state <= CMD55;
					state <= SEND_CMD;

				when CMD55 =>
					cmd_out <= x"FF770000000001";	-- 55d OR 40h = 77h
					bit_counter := 55;
					return_state <= CMD41;
					state <= SEND_CMD;
				
				when CMD41 =>
					cmd_out <= x"FF690000000001";	-- 41d OR 40h = 69h
					bit_counter := 55;
					return_state <= POLL_CMD;
					state <= SEND_CMD;
			
				when POLL_CMD =>
					if (recv_data(0) = '0') then
						state <= IDLE;
					else
						state <= CMD55;
					end if;
        	
				when IDLE => 
				    sram_byte_count := 0;
--				    if sram_addr(20 downto 19) /= "00" then
                    if sram_addr(20 downto 14) = "0010011" then
                        sram_data <= (others=>'Z');
                        state <= DISPLAY;
					else
						state <= READ_BLOCK;
					end if;
					led_out_state <= "111";
				
				when READ_BLOCK =>
					cmd_out <= x"FF" & x"51" & address & x"FF";
					bit_counter := 55;
					return_state <= READ_BLOCK_WAIT;
					state <= SEND_CMD;
					led_out_state <= "010";
				
				when READ_BLOCK_WAIT =>
					if (sclk_sig='1' and miso='0') then
						state <= READ_BLOCK_DATA;
						byte_counter := 511;
						bit_counter := 7;
						return_state <= READ_BLOCK_DATA;
						state <= RECEIVE_BYTE;
					end if;
					sclk_sig <= not sclk_sig;

				when READ_BLOCK_DATA =>
					if ignored_size /= 0 then
						ignored_size := ignored_size - 1;
					end if;
				    sram_rw <= "11";
				    sram_data <= (others=>'Z');
				    ---------sram----------
					if (byte_counter = 0) then
						bit_counter := 7;
						return_state <= READ_BLOCK_CRC;
						state <= RECEIVE_BYTE;
					else
						byte_counter := byte_counter - 1;
						return_state <= READ_BLOCK_DATA;
						bit_counter := 7;
						state <= RECEIVE_BYTE;
					end if;
			
				when READ_BLOCK_CRC =>
				    sram_rw <= "11";
				    sram_data <= (others=>'Z');
				    ---------sram-------------
					bit_counter := 7;
					return_state <= IDLE;
					address <= std_logic_vector(unsigned(address) + x"200");
					state <= RECEIVE_BYTE;
        	
				when SEND_CMD =>
					if (sclk_sig = '1') then
						if (bit_counter = 0) then
							state <= RECEIVE_BYTE_WAIT;
						else
							bit_counter := bit_counter - 1;
							cmd_out <= cmd_out(54 downto 0) & '1';
						end if;
					end if;
					sclk_sig <= not sclk_sig;
				
				when RECEIVE_BYTE_WAIT =>
					if (sclk_sig = '1') then
						if (miso = '0') then
							recv_data <= (others => '0');
							if (response_mode='0') then
								bit_counter := 3; -- already read bits 7..4
							else
								bit_counter := 6; -- already read bit 7
							end if;
							state <= RECEIVE_BYTE;
						end if;
					end if;
					sclk_sig <= not sclk_sig;

				when RECEIVE_BYTE =>
					if (sclk_sig = '1') then
						recv_data <= recv_data(6 downto 0) & miso;
						if (bit_counter = 0) then
							dout <= recv_data(6 downto 0) & miso;
							------------sram-----------
							if ignored_size = 0 and (return_state = READ_BLOCK_CRC or return_state = READ_BLOCK_DATA) then
						        s_sram_data(23 downto 0) <= s_sram_data(31 downto 8);
								s_sram_data(31 downto 24) <= dout;
								sram_byte_count := sram_byte_count + 1;
								if sram_byte_count = 4 then
									sram_rw <= "10";
									sram_data <= s_sram_data;
									sram_addr <= sram_addr + 1;
									sram_byte_count := 0;
								end if;
						    end if;
							state <= return_state;
						else
							bit_counter := bit_counter - 1;
						end if;
					end if;
					sclk_sig <= not sclk_sig;

				when WRITE_BLOCK_CMD =>
					cmd_mode <= '1';
					if (data_mode = '0') then
						cmd_out <= x"FF" & x"59" & address & x"FF";	-- continuous
					else
						cmd_out <= x"FF" & x"58" & address & x"FF";	-- single block
					end if;
					bit_counter := 55;
					return_state <= WRITE_BLOCK_INIT;
					state <= SEND_CMD;
					
				when WRITE_BLOCK_INIT => 
					cmd_mode <= '0';
					byte_counter := WRITE_DATA_SIZE; 
					state <= WRITE_BLOCK_DATA;
					
				when WRITE_BLOCK_DATA => 
					if byte_counter = 0 then
						state <= RECEIVE_BYTE_WAIT;
						return_state <= WRITE_BLOCK_WAIT;
						response_mode <= '0';
					else 	
						if ((byte_counter = 2) or (byte_counter = 1)) then
							data_sig <= x"FF"; -- two CRC bytes
						elsif byte_counter = WRITE_DATA_SIZE then
							if (data_mode='0') then
								data_sig <= x"FC"; -- start byte, multiple blocks
							else
								data_sig <= x"FE"; -- start byte, single block
							end if;
						else
							-- just a counter, get real data here
							data_sig <= std_logic_vector(to_unsigned(byte_counter,8));
						end if;
						bit_counter := 7;
						state <= WRITE_BLOCK_BYTE;
						byte_counter := byte_counter - 1;
					end if;
				
				when WRITE_BLOCK_BYTE => 
					if (sclk_sig = '1') then
						if bit_counter=0 then
							state <= WRITE_BLOCK_DATA;
						else
							data_sig <= data_sig(6 downto 0) & '1';
							bit_counter := bit_counter - 1;
						end if;
					end if;
					sclk_sig <= not sclk_sig;
					
				when WRITE_BLOCK_WAIT =>
					response_mode <= '1';
					if sclk_sig='1' then
						if MISO='1' then
							if (data_mode='0') then
								state <= WRITE_BLOCK_INIT;
							else
								address <= std_logic_vector(unsigned(address) + x"200");
								state <= IDLE;
							end if;
						end if;
					end if;
					sclk_sig <= not sclk_sig;

				when others => state <= IDLE;
        end case;
      end if;
    end if;
  end process;
  
  
  vga: VGA_Controller port map(
        VGA_CLK => vga_clock,
        hs=>vga_hs, vs=>vga_vs,
        oRed=>vga_blue, oGreen=>vga_green, oBlue=>vga_red,
        in_data=>vga_data, req_addr=>vga_addr, reset=>'1',CLK_in=>clk_in);

  sclk <= sclk_sig;
  mosi <= cmd_out(55) when cmd_mode='1' else data_sig(7);
  
end rtl;

