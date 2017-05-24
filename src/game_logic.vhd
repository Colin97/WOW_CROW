library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use work.state.all;
use work.image_info.all;

entity game_logic is
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

        output_state : out STATE
    );
end entity game_logic;

architecture game_logic_bhv of game_logic is 
    signal score_cnt : integer range 0 to SCORE_INTERVAL := 0;
    signal pos_cnt : integer range 0 to POS_INTERVAL := 0;
    signal last_crow_score : integer range 0 to MAX_SCORE := 0;
    signal last_bullet_score : integer range 0 to MAX_SCORE := 0;
    signal score : integer range 0 to MAX_SCORE := 0;
    signal current_crow : integer := 0;
	signal current_bullet : integer := 0;
    signal game_state : STATE;
    constant CROW_SCORE_INTERVAL : integer := 60;
    constant BULLET_SCORE_INTERVAL : integer := 30;
begin
    game_state.player1.score <= score;
    game_state.player1.pos <= pos; 
    game_state.player1.speed <= speed;
    output_state <= game_state;
    
    main : process(clk, rst)
    begin
        if rst = '1' then
            game_state.state <= 1;
            game_state.player1.life <= MAX_LIFE;
            score_cnt <= 0;
            pos_cnt <= 0;
            score <= 0;
            last_crow_score <= 0;
            last_bullet_score <= 0;
            for i in 0 to 3 loop
                game_state.crows(i).in_screen <= '0';
                for j in 0 to 3 loop
                    game_state.crows(i).bullets(j).in_screen <= '0';
                end loop;
            end loop;
        elsif rising_edge(clk) then
            if game_state.state = 1 then
                score_cnt <= score_cnt + 1;
                if score_cnt = SCORE_INTERVAL then
                    score_cnt <= 0;
                    score <= game_state.player1.score + speed;
                end if;
                pos_cnt <= pos_cnt + 1;
                if pos_cnt = POS_INTERVAL then
                    pos_cnt <= 0;
                end if; 
				if current_crow = 3 then
					current_crow <= 0;
				else 
					current_crow <= current_crow + 1;
				end if;
				if current_bullet = 15 then
					current_bullet <= 0;
				else
					current_bullet <= current_bullet + 1;
				end if;
                for i in 0 to 3 loop
                    if game_state.crows(i).in_screen = '0' then
                        if score > CROW_APPEAR_SCORE and score - last_crow_score > (CROW_SCORE_INTERVAL + (pos + speed) MOD 128)  and current_crow = i then
							last_crow_score <= score;
							game_state.crows(i).in_screen <= '1';
							game_state.crows(i).pos <= WIDTH - 1;
							for j in 0 to 3 loop
								game_state.crows(i).bullets(j).in_screen <= '0';
							end loop;
                        end if;
                    else 
                        if pos_cnt = 0 then
                            if game_state.crows(i).pos < 2 then
                                game_state.crows(i).in_screen <= '0';
                                for j in 0 to 3 loop
									game_state.crows(i).bullets(j).in_screen <= '0';
								end loop;
                            elsif speed > 15 then 
                                game_state.crows(i).pos <= game_state.crows(i).pos - 2;
                            else
                                game_state.crows(i).pos <= game_state.crows(i).pos - 1;
                            end if;
                        end if;
                        for j in 0 to 3 loop
                            if game_state.crows(i).bullets(j).in_screen = '0' then
                                if current_bullet = i * 4 + j and score - last_bullet_score > (BULLET_SCORE_INTERVAL + (pos + speed) MOD 64) then
                                    last_bullet_score <= score;
                                    game_state.crows(i).bullets(j).in_screen <= '1';
                                    game_state.crows(i).bullets(j).height <= 70;
                                end if;
                            else
                                if game_state.crows(i).pos >= game_state.player1.pos and game_state.crows(i).pos <= game_state.player1.pos + 80 then
                                    if game_state.crows(i).bullets(j).height > 250 then
                                        game_state.crows(i).bullets(j).in_screen <= '0';
                                        game_state.player1.life <= game_state.player1.life - 1;
                                        if game_state.player1.life = 0 then 
                                            game_state.state <= 2;
                                        end if;
                                    end if;
                                end if;
                                if pos_cnt = 0 then
                                    if game_state.crows(i).bullets(j).height > 400 then
                                        game_state.crows(i).bullets(j).in_screen <= '0';
                                    elsif speed > 15 then 
                                        game_state.crows(i).bullets(j).height <= game_state.crows(i).bullets(j).height + 5;
                                    else
                                        game_state.crows(i).bullets(j).height <= game_state.crows(i).bullets(j).height + 4;
                                    end if;
                                end if;
                            end if;
                        end loop;
                    end if;                
				end loop;
            end if;
        end if;
    end process;
end architecture game_logic_bhv;