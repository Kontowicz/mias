-- Bilinear Integrator 

library ieee;
use ieee.std_logic_1164.all;
use ieee.MATH_REAL.all;

entity myInt_BI is 
    generic (
        initial : real := 0.0
    );
    port (
        input_port : in real;
        clk : in std_logic;
        output_port : out real := initial
    );
end entity myInt_BI;

architecture behav of myInt_BI is

    --signal clk_signal : std_logic;
    signal lc1_out : real;
    signal lc2_out : real;

    signal delay_out1 : real;
    signal delay_out2 : real;
begin 
    -- clock_dev : entity work.clock generic map(
    --     start => '0',
    --     period => 10 ns
    -- ) port map (
    --     clk => clk_signal
    -- );

    lc1 : entity work.linearCombination generic map(
        inital => 1.0,
        coeffA => 1.0,
        coeddB => 1.0
    ) port map(
        inputA => input_port,
        inputB => delay_out1,
        outputt => lc1_out
    );

    zd1 : entity work.ZDelay generic map(
        count => 0,
        initial => 0.0
    ) port map(
        inputt => input_port,
        clk => clk,
        outputt => delay_out1
    );

    lc2 : entity work.linearCombination generic map(
        inital => 1.0,
        coeffA => 1.0,
        coeddB => 1.0
    ) port map(
        inputA => lc1_out,
        inputB => delay_out2,
        outputt => lc2_out
    );

    zd2 : entity work.ZDelay generic map(
        count => 0,
        initial => 0.0
    ) port map(
        inputt => lc2_out,
        clk => clk,
        outputt => delay_out2
    );
    output_port <= lc2_out;

end architecture behav;  
