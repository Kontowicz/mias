library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control is
    generic (
        addres_line : integer := 7;
        data_size : integer := 7;
        period : time := 20 ns
    );
    port (
        CSn : out std_logic := '1';
        OEn : out std_logic := '1';
        WEn : out std_logic := '1';
        inc_addr : out std_logic := '0';
        ld_data : out std_logic := '0';
        en_data : out std_logic := '0';
        inc_data : out std_logic := '0'
    );
end control;

architecture behav of control is
        type state is (Idle, Load_data, Increment_data, Save_data, Next_addr, Done, End_state);
        signal current_state, next_state : state := Idle;
        signal clock : std_logic := '0' ;
        signal cnt : integer := 0;
    begin

        process begin
            wait for period/2;
            clock <= not clock;
        end process;

        control : process( clock )
            begin
                case current_state is
                    when Idle =>
                        if rising_edge(clock) then
                            CSn <= '0';
                            next_state <= Load_data;
                        end if;

                    when Load_data =>
                        if rising_edge(clock) then
                            OEn <= '0';
                            ld_data <= '1' after 2 ns;
                            next_state <= Increment_data;
                        end if;

                    when Increment_data =>
                        if rising_edge(clock) then
                            OEn <= '1';
                            ld_data <= '0';
                            inc_data <= '1';
                            next_state <= Save_data;
                        end if;

                    when Save_data =>
                        if rising_edge(clock) then
                            inc_data <= '0';
                            WEn <= '0' after 2 ns;
                            en_data <= '1';
                            next_state <= Next_addr;
                        end if;

                    when Next_addr =>
                        if rising_edge(clock) then
                            if WEn = '0' then
                                cnt <= cnt + 1;
                            end if;
                            en_data <= '0';
                            WEn <= '1';
                            inc_addr <= '1';
                            next_state <= Done;
                        end if;

                    when Done =>
                        if rising_edge(clock) then
                            inc_addr <= '0';
                            next_state <= Load_data;
                            if cnt = ((2**data_size - 1) * (2**addres_line)) + 1 then
                                next_state <= End_state;
                            end if;
                            
                        end if;

                    when End_state =>
                        if rising_edge(clock) then
                            next_state <= End_state;
                        end if;
                end case;
        end process ; -- control

        fsm_state : process(clock)
            begin
                if rising_edge(clock) then
                    current_state <= next_state;
                end if;
            
        end process ; -- fsm_state
end behav ; -- behav