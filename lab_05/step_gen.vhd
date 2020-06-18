library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity step is
    generic (
        delay : integer := 5;
        initial : real := 0.0
    );
    port(
        clock_port: in std_logic;
        output_port: out real := initial
    );
end entity step;

architecture behav of step is
    signal out_sig : real := initial;
    signal counter : integer := 0;
    begin
    s : process(clock_port) begin
        if rising_edge(clock_port) then
            if counter >= delay then
                out_sig <= 1.0;
            else 
                out_sig <= initial;
            end if;
            counter <= counter + 1;
        end if;
    end process;
    
    output_port <= out_sig;
end architecture behav;  