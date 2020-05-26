library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity tb is               
end tb;

architecture behav of tb IS
        signal clock_signal : std_logic;
        signal reset_n : std_logic;
        signal i2c_ack_err : std_logic;
        signal temperature : std_logic_vector(7 downto 0);
        -- signal scl1 : std_logic;
        -- signal sda1 : std_logic;
        signal scl : std_logic := '1';
        signal sda : std_logic := '1';
    begin
        -- scl <= '1';
        -- sda <= '1';

        user_logic_dev : entity work.user_logic 
            port map(
                clock_signal,
                reset_n,
                i2c_ack_err,
                temperature
        );

        temp_sensor : entity work.pmod_temp_sensor_tcn75a generic map(
            resolution => 8
        ) port map(
            clock_signal,
            reset_n,
            scl,
            sda,
            i2c_ack_err,
            temperature
        );
        
        tsp_dev : entity work.tsp port map(
            scl,
            sda
        );
end architecture behav;