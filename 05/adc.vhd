
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adc is 
    port (

        input_port : in real;
        output_port : out std_logic
    );
end entity adc;

architecture behav of adc is
    signal output_signal : std_logic;

    begin
        sample : process(input_port) begin
            if input_port >= 0.0 then
                output_signal <= '1';
            else
                output_signal <= '0';
            end if;
        end process;
        
        output_port <= output_signal;

end architecture behav;  