
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pulse is
    generic (
        delay : integer := 1;
        w_pulse : integer := 1;
        initial : real := 0.0
    );
    port(
        clock_port: in std_logic;
        output_port: out real := initial
    );
end entity pulse;

architecture behav of pulse is
    signal out_sig : real := initial;
    signal counter : integer := 0;
    begin
    s : process(clock_port) begin
        if rising_edge(clock_port) then
            if counter >= delay + w_pulse then
                out_sig <= 0.0;
            elsif counter >= delay then
                out_sig <= 1.0;
            else 
                out_sig <= initial;
            end if;
            counter <= counter + 1;
        end if;
    end process;
    
    output_port <= out_sig;
end architecture behav;  