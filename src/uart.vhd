library IEEE;
use IEEE.std_logic_1164.all;

entity uart is
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
end;

architecture behavioral of uart is
    type state is (st_init, st_wait, st_read, st_read_stop, st_data_out, st_error);
    constant WAIT_CLOCKS: integer := CLK_FREQ / BAUD;

    signal current_state, resume_state: state;
    signal counter: integer range 0 to 3 * WAIT_CLOCKS / 2 - 1;
    signal buff: std_logic_vector(7 downto 0);
    signal rxd_index: integer range 0 to 8;
    signal data_out: std_logic_vector(7 downto 0);
    signal ready, error: std_logic;
    signal rxd_buff: std_logic_vector(1 downto 0);
begin
    -- filter
    process(CLK, RST)
    begin
        if RST = '1' then
            rxd_buff <= "11";
        else
            if rising_edge(CLK) then
                rxd_buff <= rxd_buff(0) & RXD;
            end if;
        end if;
    end process;

    -- read 8-n-1
    process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= st_init;
            resume_state <= st_init;
            counter <= 0;
            buff <= x"00";
            rxd_index <= 0;
            data_out <= x"00";
            ready <= '0';
            error <= '0';
        else
            if rising_edge(CLK) then
                case current_state is
                    when st_init =>
                        ready <= '0';
                        error <= '0';
                        if rxd_buff = "10" then
                            current_state <= st_wait;
                            counter <= 3 * WAIT_CLOCKS / 2 - 1;
                            rxd_index <= 0;
                            resume_state <= st_read;
                        else
                            resume_state <= st_init;
                        end if;
                    when st_wait =>
                        if resume_state = st_wait then
                            current_state <= st_init;
                        else
                            if counter = 0 then
                                current_state <= resume_state;
                            else
                                counter <= counter - 1;
                            end if;
                        end if;
                    when st_read =>
                        buff(rxd_index) <= rxd_buff(0); -- sample

                        current_state <= st_wait;
                        counter <= WAIT_CLOCKS - 1;
                        if rxd_index = 7 then
                            resume_state <= st_read_stop;
                        else
                            resume_state <= st_read;
                            rxd_index <= rxd_index + 1;
                        end if;
                    when st_read_stop =>
                        if rxd_buff(0) = '1' then
                            data_out <= buff;
                            current_state <= st_data_out;
                        else
                            current_state <= st_error;
                        end if;
                    when st_data_out =>
                        ready <= '1';
                        current_state <= st_init;
                    when st_error =>
                        error <= '1';
                        current_state <= st_init;
                    when others =>
                        current_state <= st_init;
                end case;
            end if;
        end if;
    end process;
    
    DATA_READ <= data_out;
    DATA_READY <= ready;
    DATA_ERROR <= error;
    
    process(current_state)
    begin
        case current_state is
            when st_init =>
                DBG_STATE <= "000";
            when st_wait =>
                DBG_STATE <= "001";
            when st_read =>
                DBG_STATE <= "010";
            when st_read_stop =>
                DBG_STATE <= "011";
            when st_data_out =>
                DBG_STATE <= "100";
            when st_error =>
                DBG_STATE <= "101";
            when others =>
                DBG_STATE <= "111";
        end case;
    end process;
end;
