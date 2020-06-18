
-- Sigma delta

library ieee;
use ieee.std_logic_1164.all;
use ieee.MATH_REAL.all;
use work.all;
use work.sine_package.all;

entity sigma_delta is 
    generic (
        initial : std_logic := '0'
    );
    port (
        input_port : in real;
        output_port : out std_logic := initial;
        clk_port : in std_logic;
        lc_out_port : out real;
        integrator_out_port : out real;
        adc_out_port : out std_logic;
        dac_out_port : out real
    );
end entity sigma_delta;

architecture behav of sigma_delta is
    signal clk_signal : std_logic;

    signal adc_out : std_logic;
    signal dac_out : real;
    signal lc_out_01 : real;
    signal fei_out : real;

begin 

    clk_signal <= clk_port;

    lc_01 : entity work.linearCombination generic map(
        inital => 1.0,
        coeffA => 1.0,
        coeddB => -1.0
    ) port map(
        inputA => input_port,
        inputB => dac_out,
        outputt => lc_out_01
    );

    lc_out_port <= lc_out_01;

    fei_dev : entity work.myInt_FEI generic map(
        initial => 0.0
    ) port map (
        input_port => lc_out_01,
        clk => clk_signal,
        output_port => fei_out
    );

    integrator_out_port <= fei_out;

    adc_dev : entity work.adc port map(
        input_port => fei_out,
        output_port => adc_out
    );

    adc_out_port <= adc_out;

    dac_dev : entity work.dac port map(
        input_port => adc_out,
        output_port => dac_out
    );
    dac_out_port <= dac_out;

    output_port <= adc_out;

end architecture behav;  