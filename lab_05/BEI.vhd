-- Backward Euler Integorator

library ieee;
use ieee.std_logic_1164.all;
use ieee.MATH_REAL.all;

entity myInt_BEI is 
    generic (
        initial : real := 0.0
    );
    port (
        input_port : in real;
        clk : in std_logic;
        output_port : out real := initial
    );
end entity myInt_BEI;

architecture behav of myInt_BEI is
    signal delay_out : real;
    signal lc_out : real;
begin 
    lc : entity work.linearCombination generic map(
        inital => 0.0,
        coeffA => 1.0,
        coeddB => 1.0
    ) port map(
        inputA => input_port,
        inputB => delay_out,
        outputt => lc_out
    );

    zd : entity work.ZDelay generic map(
        count => 0,
        initial => 0.0
    ) port map(
        inputt => lc_out,
        clk => clk,
        outputt => delay_out
    );

    output_port <= lc_out;

end architecture behav;  