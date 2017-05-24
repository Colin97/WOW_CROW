library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith;

-- for JY901(-BT)
entity imu is
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
        
        ERROR: out std_logic;
        speed : out integer range 0 to 31;
        pos : out integer range 0 to 199
    );
end;

architecture behavioral of imu is
    type state is (st_read_wait, st_read, st_checksum, st_data_out, st_error);
    type buffer_t is array(10 downto 0) of std_logic_vector(7 downto 0);
    constant TIMEOUT_CLOCKS: integer := CLK_FREQ / 1000 * TIMEOUT_MS;
    constant imu_range: integer := 65535;
    constant pos_lower_bound : integer := 24576;
    constant pos_upper_bound : integer := 40960;
    constant speed_lower_bound : integer := 24576;
    constant speed_upper_bound : integer := 40960;
    constant pos_range : integer := 199;
    constant speed_range : integer := 31; 

    signal buff: buffer_t;
    signal last_ready: std_logic;
    signal timeout_counter: integer range 0 to TIMEOUT_CLOCKS - 1;
    signal current_state: state;
    signal read_index: integer range 0 to 10;
    signal checksum: std_logic_vector(7 downto 0);
    signal checksum_correct: std_logic;
    signal error_buff: std_logic;
    
    signal data0, data1, data2, data3: std_logic_vector(15 downto 0);
    signal roll_integer : integer range 0 to 65535;
    signal pitch_integer : integer range 0 to 65535;
    -- output buffer
    signal a_x, a_y, a_z,
           w_x, w_y, w_z,
           h_x, h_y, h_z,
           roll_buff, pitch_buff, yaw_buff: std_logic_vector(15 downto 0);
begin
    -- outputs
    --Ax <= a_x;
    --Ay <= a_y;
    --Az <= a_z;
    --Wx <= w_x;
    --Wy <= w_y;
    --Wz <= w_z;
    --Hx <= h_x;
    --Hy <= h_y;
    --Hz <= h_z;
    --ROLL <= roll_buff;
    --PITCH <= pitch_buff;
    --YAW <= yaw_buff;
    ERROR <= error_buff;
    roll_integer <= conv_integer(roll_buff);
    pitch_integer <= conv_integer(pitch_buff);

    checksum_correct <= '1' when buff(0) = x"55" and buff(1)(7 downto 4) = x"5" and
                                 checksum = buff(10) else '0';
    data0 <= buff(3) & buff(2);
    data1 <= buff(5) & buff(4);
    data2 <= buff(7) & buff(6);
    data3 <= buff(9) & buff(8);
                          
    calc_pos : process(pitch_integer)
    begin
        if pitch_integer < pos_lower_bound then 
            pos <= 0;
        elsif pitch_integer > pos_upper_bound then
            pos <= pos_range;
        else 
            pos <= pos_range * (pitch_integer - pos_lower_bound) / (pos_upper_bound - pos_lower_bound);
        end if;
    end process; 

    calc_speed : process(roll_integer)
    begin
        if roll_integer < speed_lower_bound then 
            speed <= 0;
        elsif roll_integer > speed_upper_bound then
            speed <= speed_range;
        else 
            speed <= speed_range * (roll_integer - speed_lower_bound) / (speed_upper_bound - speed_lower_bound);
        end if;
    end process; 

    process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= st_read_wait;
            read_index <= 0;
            timeout_counter <= 0;
            checksum <= x"00";
            error_buff <= '0';
        else
            if rising_edge(CLK) then
                case current_state is
                    when st_read_wait =>
                        if last_ready = '0' and READY = '1' then
                            timeout_counter <= 0;
                            current_state <= st_read;
                        else
                            if timeout_counter = TIMEOUT_CLOCKS - 1 then -- timed out
                                read_index <= 0;
                                timeout_counter <= 0;
                                checksum <= x"00";
                            else
                                timeout_counter <= timeout_counter + 1;
                            end if;
                        end if;
                    when st_read =>
                        buff(read_index) <= DATA;
                        if read_index = 10 then
                            read_index <= 0;
                            current_state <= st_checksum;
                        else
                            read_index <= read_index + 1;
                            checksum <= checksum + DATA;
                            current_state <= st_read_wait;
                        end if;
                    when st_checksum =>
                        if checksum_correct = '1' then
                            current_state <= st_data_out;
                        else
                            current_state <= st_error;
                        end if;
                        checksum <= x"00";
                    when st_data_out =>
                        case buff(1)(3 downto 0) is
                            when x"1" => -- 加速度
                                a_x <= data0;
                                a_y <= data1;
                                a_z <= data2;
                            when x"2" => -- 角速度
                                w_x <= data0;
                                w_y <= data1;
                                w_z <= data2;
                            when x"3" => -- 欧拉角
                                roll_buff <= data0;
                                pitch_buff <= data1;
                                yaw_buff <= data2;
                            when x"4" => -- 磁场
                                h_x <= data0;
                                h_y <= data1;
                                h_z <= data2;
                            when others =>
                        end case;
                        current_state <= st_read_wait;
                    when st_error => -- checksum failed, error restore
                        -- find next 0x55(packet header) and retry
                        if last_ready = '0' and READY = '1' and DATA = x"55" then
                            error_buff <= '0';
                            current_state <= st_read;
                            -- assert timeout_counter = 0 and read_index = 0
                        else
                            error_buff <= '1';
                        end if;
                end case;
            end if;
        end if;
    end process;

    process(CLK, RST)
    begin
        if RST = '1' then
            last_ready <= '0';
        else
            if rising_edge(CLK) then
                last_ready <= READY;
            end if;
        end if;
    end process;
end;
