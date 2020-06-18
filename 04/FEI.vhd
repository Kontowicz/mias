-- Forward Euler Integrator

library ieee;
use ieee.std_logic_1164.all;
use ieee.MATH_REAL.all;

entity myInt_FEI is 
    generic (
        initial : real := 0.0
    );
    port (
        input_port : in real;
        clk : in std_logic;
        output_port : out real := initial
    );
end entity myInt_FEI;

architecture behav of myInt_FEI is
    signal delay_out : real;
    --signal clk_signal : std_logic;
    signal lc_out : real;
begin 
    -- clock_dev : entity work.clock generic map(
    --     start => '0',
    --     period => 10 ns
    -- ) port map (
    --     clk => clk_signal
    -- );

    lc : entity work.linearCombination generic map(
        inital => 1.0,
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

    output_port <= delay_out;

end architecture behav;  