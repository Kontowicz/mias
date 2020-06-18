library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dac is 
    port (
        input_port : in std_logic;
        output_port : out real
    );
end entity dac;

architecture behav of dac is
    signal output_signal : real;

    begin
        s : process(input_port) begin
            if input_port = '1' then
                output_signal <= 1.0;
            else
                output_signal <= -1.0;
            end if;
        end process;
        
        output_port <= output_signal;

end architecture behav;  