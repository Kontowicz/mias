library ieee;
use IEEE.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cb is
    generic (
        d_width		:	INTEGER		:= 8 			--data bus width
     );
    port (
        reset_n : in std_logic;
        clock : in std_logic;
        tx : out std_logic;
        rx : in std_logic
    ) ;
end cb;

architecture behav of cb is
        signal tx_ena : std_logic;
        signal tx_data	: STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
        signal rx_busy	: STD_LOGIC;										--data reception in progress
        signal rx_error	: STD_LOGIC;										--start, parity, or stop bit error detected
        signal rx_data	: STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);	--data received
        signal tx_busy	: STD_LOGIC;  
        
        signal received_data : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);	--data received
        signal message_buff : string(1 to 11);
        signal respond_message_buff : string(1 to 11);
        
        type state is (Idle, Receiving, Check, Respond);
        signal p_state, n_state : state := Idle;
        
    begin

        uart_cb_dev : entity work.uart
            port map(
                clk		=> clock,
                reset_n	=> reset_n,
                tx_ena	=> tx_ena,										--initiate transmission
                tx_data	=> tx_data,  --data to transmit
                rx => rx,
                rx_busy	=>  rx_busy,										--data reception in progress
                rx_error => rx_error,										--start, parity, or stop bit error detected
                rx_data	=> rx_data,	--data received
                tx_busy	=> tx_busy,  									--transmission in progress
                tx => tx
        );

        fsm : process( clock, p_state, rx_busy )
            variable respond_size : INTEGER := 0;
            variable cnt : INTEGER := 0;
            begin
                case p_state is 
                    when Idle =>
                        message_buff <= "           ";
                        if falling_edge(rx_busy) then 
                            received_data <= rx_data;
                            message_buff <= message_buff & character'val(to_integer(unsigned(received_data))); --????
                            n_state <= Receiving;
                        else 
                            n_state <= Idle;
                        end if;

                    when Receiving =>
                        if falling_edge(rx_busy) then 
                            received_data <= rx_data;
                            if received_data = "00000000" then
                                -- PADDIND
                                for I in cnt to 11 loop
                                    message_buff <= message_buff & ' ';
                                end loop;

                                n_state <= Check;
                            else
                                message_buff <= message_buff & character'val(to_integer(unsigned(received_data))); --????    
                                cnt := cnt + 1;
                                n_state <= Receiving;
                            end if;
                        end if;
                        
                    when Check =>
                        case message_buff is
                            when "Hello      " => 
                                respond_message_buff <= "olleH";
                                respond_size := 5;
                                n_state <= Respond;
                            when "Temperature" => 
                                respond_message_buff <= "02";
                                respond_size := 2;
                                n_state <= Respond;
                            when "Bye        " =>
                                respond_message_buff <= "eyB";
                                respond_size := 3;
                                n_state <= Respond;
                            when others => 
                                n_state <= Idle;
                        end case;

                    when Respond => 
                        if rising_edge(clock) then
                            if respond_size = 0 then
                                n_state <= Idle;
                            elsif tx_busy = '0' then
                                tx_data <= std_logic_vector(to_unsigned(character'pos(respond_message_buff(respond_size)),8)); --std_logic_vector(to_unsigned(respond_message_buff(respond_size),8));
                                tx_ena <= '1';
                                respond_size := respond_size - 1;
                                n_state <= Respond;
                            else 
                                tx_ena <= '0';
                                n_state <= Respond;
                            end if;
                        end if;
                end case;
        end process ; -- fsm
        
        machine : process (reset_n, clock )
            begin
                if rising_edge(clock) then
                    p_state <= n_state;
                end if;

                if falling_edge(reset_n) then
                    p_state <= Idle;
                end if;
        end process;

end behav ; -- behav