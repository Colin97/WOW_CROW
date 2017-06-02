library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use work.state.all;
use work.image_info.all;
use work.signals.all;

entity IR is 
    generic (
        lead_low : integer := 9000;
        lead_high : integer := 4500;
        data_low : integer := 560;
        bit_0_high : integer := 560;
        bit_1_high : integer := 1680;
        data_length : integer := 32;
        error_range : integer := 200
    );
    port (
        rst : in std_logic;
        clk : in std_logic;
        RX : in std_logic;
        data : out std_logic_vector(31 downto 0);
        done : out std_logic
    );
end entity IR;

architecture IR_bhv of IR is
    type state is (s_init, s_lead_low, s_lead_high, s_data_low, s_data_high); 
    signal current_state : state := s_init;
    signal cnt : integer := 0;
    signal current_bit : integer := 0;
begin 
    main : process(clk, rst)
    begin
        if rst = '1' then
            current_state <= s_init;
        elsif rising_edge(clk) then
            case current_state is
                when s_init =>
                    if RX = '0' then
                        cnt <= 1;
                        current_state <= s_lead_low;
                        done <= '0';
                    end if;
                when s_lead_low => 
                    if RX = '0' then
                        cnt <= cnt + 1;
                    else 
                        if cnt >= lead_low - error_range and cnt <= lead_low + error_range then
                            cnt <= 1;
                            current_state <= s_lead_high;
                        else
                            current_state <= s_init;
                        end if;
                    end if;
                when s_lead_high => 
                    if RX = '1' then
                        cnt <= cnt + 1;
                    else 
                        if cnt >= lead_high - error_range and cnt <= lead_high + error_range then
                            cnt <= 1;
                            current_state <= s_data_low;
                            current_bit <= 0;
                        else
                            current_state <= s_init;
                        end if;
                    end if;
                when s_data_low => 
                    if RX = '0' then
                        cnt <= cnt + 1;
                    else 
                        if cnt >= data_low - error_range and cnt <= data_low + error_range then
                            cnt <= 1;
                            current_state <= s_data_high;
                        else
                            current_state <= s_init;
                        end if;
                    end if;
                when s_data_high => 
                    if RX = '1' then
                        cnt <= cnt + 1;
                    else 
                        if cnt >= bit_0_high - error_range and cnt <= bit_0_high + error_range then
                            data(current_bit) <= '0';
                            if current_bit = 31 then
                                done <= '1';
                                current_state <= s_init;
                            else
                                current_bit <= current_bit + 1;
                                current_state <= s_data_low;
                                cnt <= 1;
                            end if;
                        elsif cnt >= bit_1_high - error_range and cnt <= bit_1_high + error_range then
                            data(current_bit) <= '1';
                            if current_bit = 31 then
                                done <= '1';
                                current_state <= s_init;
                            else
                                current_bit <= current_bit + 1;
                                current_state <= s_data_low;
                                cnt <= 1;
                            end if;
                        end if;
                    end if;
            end case;
        end if;
    end process;
end architecture IR_bhv;