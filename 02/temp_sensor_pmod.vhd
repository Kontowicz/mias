
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tsp is
    port(
       -- clk : in std_logic;
        --rst : in std_logic;
        scl : inout std_logic := '1';
        sda : inout std_logic := '1'
    );                   
end tsp;

architecture behav of tsp IS
    signal resolution : integer := 9;
    signal temperature : std_logic_vector (7 DOWNTO 0)  := "01010101";

    signal bit_counter : integer := 0;
    signal reset_bit_counter : std_logic := '0';
    signal start : std_logic := '0';
    signal read_write : std_logic := 'Z'; -- 0 write data, 1 read data

    signal receive_reg : std_logic_vector (7 downto 0) := "00000000";
    signal send_register : std_logic_vector (7 downto 0) := "00000000";
    

    begin

    start_stop : process( sda, scl )
        begin
            if falling_edge(sda) and scl = '1' then
                start <= '1';
                reset_bit_counter <= '1';
            end if;
            if rising_edge(sda) and scl = '1' then
                start <= '0';
            end if;
            reset_bit_counter <= '0';
    end process ; -- start_stop

    read_data : process( start, scl )
        begin
            if start = '1' and bit_counter < 8 then
                receive_reg(bit_counter) <= sda;
            end if;
            if bit_counter = 8 then
                sda <= '0'; --ACK
                if receive_reg = "10010000" then
                    read_write <= '0';
                    -- write 
                        -- czytaj adres rejestru
                        -- wpisz otrzymywane dane do rejestru
                elsif receive_reg = "10010001" then
                    read_write <= '1';
                    -- read
                        -- czytaj adres rejestru
                        -- wyślij dane z rejestru
                end if;
            end if;
    end process ; -- read_data

   -- write_data : proces ()

    bit_cnt : process(sda, reset_bit_counter) begin
        if reset_bit_counter = '1' then
            bit_counter <= 0;
        end if;
        if start = '1' then
            bit_counter <= bit_counter + 1;
        end if;
    end process;

end architecture behav;