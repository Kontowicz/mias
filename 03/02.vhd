library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sample_hold is 
    generic (
        initial : real := 0.0;
        vec_length : integer := 8
    );
    port (
        inputt : in std_logic_vector(vec_length - 1 downto 0);
        clk : in std_logic;
        outputt : out real := initial
    );
end entity sample_hold;

architecture behav of sample_hold is
    signal output_signal : real := initial;

    begin
        sample : process(clk) begin
            if rising_edge(clk) then
                output_signal <= Real(to_integer(signed(inputt)));--input;
            end if;
        end process;
        
    outputt <= output_signal;

end architecture behav;  