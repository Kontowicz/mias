library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ZDelay is
    generic (
        count : integer := 10;
        initial : real := 0.0
    );

    port (
        inputt : in real;
        clk : in std_logic;
        outputt : out real := initial
    );
end entity ZDelay;

architecture arch_delay of ZDelay is
    type holds_array is array (0 to count) of real;
    signal shift_register : holds_array := (others => initial);
    signal out_signal : real := initial;

begin

    sample : process(clk) begin
        if rising_edge(clk) then
            out_signal <= shift_register(count);
            for i in count downto 1 loop
                shift_register(i) <= shift_register(i-1);
            end loop;
            shift_register(0) <= inputt;
        end if;
    end process;

    outputt <= out_signal;
end arch_delay ; -- arch_delay