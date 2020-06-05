library ieee;
use IEEE.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_logic is
    generic (
        N : integer := 8;
        period : time := 20 ns;
        d_width		:	INTEGER		:= 8 			--data bus width
    );
    port (
        clk : out std_logic := '0';
        reset_n : out std_logic;

        tx_ena : out std_logic;
        tx_data : out std_logic_vector(N - 1 downto 0);
        tx_busy : in std_logic;

        rx_data : in std_logic_vector(N - 1 downto 0);
        rx_busy : in std_logic;
        rx_error : in std_logic
    ) ;
end user_logic ;

architecture behav of user_logic is
        signal clock : std_logic := '0';
        signal tx_register : std_logic_vector(N - 1 downto 0) := "01011010";
        signal rx_register : std_logic_vector(N - 1 downto 0) := "01000010";
        type state is (Idle, Hello, Send_hello, Receiving_1, Temperature, Send_temp, Receiving_2, Bye, Send_bye, Receiving_3);
        signal current_state, next_state : state := Idle;
        signal message_buff : string(1 to 11);
        signal rx_message_buff : string(1 to 11);
		
		signal prev_rx	: STD_LOGIC;

    begin
        reset_n <= '0', '1' after 1000 ns;

        process begin
            wait for period/2;
            clock <= not clock;
        end process;
        clk <= clock;


    machine : process( clock )
        variable cnt : integer := 0;
        variable message_len : integer := 0;
        begin
            case current_state is
                when Idle =>
                    if rising_edge(clock) then
                        if cnt > 100 then
                            next_state <= Hello;
						else 
							next_state <= Idle;
							cnt := cnt + 1;
						end if;
                    end if;
                    
                when Hello =>
                    if rising_edge(clock) then
                        message_buff <= "olleH      ";
                        message_len := 5;
                        next_state <= Send_hello;
                    end if;
                when Send_hello =>
                    if rising_edge(clock) then
                        if message_len = 0 then
							if tx_busy = '0' then 
                                tx_data <= "00000000";
								tx_ena <= '1' , '0' after 100 ns;
								cnt := 1;
                                next_state <= Receiving_1;
							else 
								next_state <= Send_hello;
							end if;

                        elsif tx_busy = '0' then
                            tx_data <= std_logic_vector(to_unsigned(character'pos(message_buff(message_len)),8));
                            tx_ena <= '1','0' after 100 ns;
                            message_len := message_len - 1;
                            next_state <= Send_hello;
                        else
                            next_state <= Send_hello;
                        end if;
                    end if;

                when Receiving_1 =>
					if rising_edge(clock) then
						prev_rx <= rx_busy;
						if prev_rx = '1' and rx_busy = '0' then
							if rx_data = "00000000" then
								for I in cnt to 11 loop
										rx_message_buff(I) <= ' ';
								end loop;
								next_state <= Temperature;
							else
								rx_message_buff(cnt) <= character'val(to_integer(unsigned(rx_data))); --????    
								cnt := cnt + 1;
								next_state <= Receiving_1;
							end if;
						end if;
					end if;
                when Temperature =>
                    if rising_edge(clock) then
                        message_buff <= "erutarepmeT";
                        message_len := 11;
                        next_state <= Send_temp;
                    end if;
                
                when Send_temp =>
                    if rising_edge(clock) then
                        if message_len = 0 then
							if tx_busy = '0' then 
                                tx_data <= "00000000";
								tx_ena <= '1' , '0' after 100 ns;
								cnt := 1;
                                next_state <= Receiving_2;
							else 
								next_state <= Send_temp;
							end if;

                        elsif tx_busy = '0' then
                            tx_data <= std_logic_vector(to_unsigned(character'pos(message_buff(message_len)),8));
                            tx_ena <= '1','0' after 100 ns;
                            message_len := message_len - 1;
                            next_state <= Send_temp;
                        else
                            next_state <= Send_temp;
                        end if;
                    end if;

                when Receiving_2 =>
                    if rising_edge(clock) then
						prev_rx <= rx_busy;
						if prev_rx = '1' and rx_busy = '0' then
							if rx_data = "00000000" then
								for I in cnt to 11 loop
										rx_message_buff(I) <= ' ';
								end loop;
								next_state <= Bye;
							else
								rx_message_buff(cnt) <= character'val(to_integer(unsigned(rx_data))); --????    
								cnt := cnt + 1;
								next_state <= Receiving_2;
							end if;
						end if;
					end if;

                when Bye =>
                    if rising_edge(clock) then
                        message_buff <= "eyB        ";
                        message_len := 3;
                        next_state <= Send_bye;
                    end if;

                when Send_bye =>
                    if rising_edge(clock) then
                        if message_len = 0 then
							if tx_busy = '0' then 
                                tx_data <= "00000000";
								tx_ena <= '1' , '0' after 100 ns;
								cnt := 1;
                                next_state <= Receiving_3;
							else 
								next_state <= Send_bye;
							end if;

                        elsif tx_busy = '0' then
                            tx_data <= std_logic_vector(to_unsigned(character'pos(message_buff(message_len)),8));
                            tx_ena <= '1','0' after 100 ns;
                            message_len := message_len - 1;
                            next_state <= Send_bye;
                        else
                            next_state <= Send_bye;
                        end if;
                    end if;
                
                when Receiving_3 =>
					if rising_edge(clock) then
						prev_rx <= rx_busy;
						if prev_rx = '1' and rx_busy = '0' then
							if rx_data = "00000000" then
								for I in cnt to 11 loop
										rx_message_buff(I) <= ' ';
								end loop;
								next_state <= Idle;
							else
								rx_message_buff(cnt) <= character'val(to_integer(unsigned(rx_data))); --????    
								cnt := cnt + 1;
								next_state <= Receiving_3;
							end if;
						end if;
					end if;

            end case;
    end process ; -- transmit

    machine_state : process( clock )
        begin
            if falling_edge( clock ) then
                current_state <= next_state;
            end if;        
    end process ; -- machine_state


end architecture ; -- arch