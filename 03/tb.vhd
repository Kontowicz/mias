LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;

entity tb is
    port(
        tx_port : out std_logic 
    );
    
end tb ;

architecture arch of tb is
    signal clock : std_logic;
    signal reset_n : std_logic;
    signal tx_enable : std_logic;
    signal tx_data_s : std_logic_vector(8 - 1 downto 0);
    signal tx_busy : std_logic;
    signal rx_data_s : std_logic_vector(8 - 1 downto 0);
    signal rx_busy : std_logic;
    signal rx_error : std_logic;

    signal rx : std_logic;
    signal tx : std_logic;

    begin   
        tx_port <= tx;

        user_logic_dev : entity work.user_logic generic map(
            N => 8,
            period => 20 ns
        ) port map(
            clk => clock,
            reset_n => reset_n,

            tx_ena => tx_enable,
            tx_data => tx_data_s,
            tx_busy => tx_busy,
    
            rx_data => rx_data_s, 
            rx_busy => rx_busy,
            rx_error => rx_error
        );

        uart_dev : entity work.uart generic map(
            d_width => 8,
            parity => 0
        )port map(
            clk		=> clock,
            reset_n => reset_n,

            tx_ena => tx_enable,
            tx_data	=> tx_data_s,
            tx_busy => tx_busy,

            tx => tx,

            rx => rx,

            rx_busy => rx_busy,
            rx_error => rx_error,
            rx_data => rx_data_s
        );
        

        cb_dev : entity work.cb port map(
            reset_n => reset_n,
            clock => clock,
            rx => tx,
            tx => rx
        );


end architecture ; -- arch