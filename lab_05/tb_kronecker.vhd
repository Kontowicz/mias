library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.all;

entity tb is
end entity tb;

architecture a of tb is

    signal clk_signal : std_logic;
    signal kronecker_signal_puls : real;

    signal bei_out : real;
    signal fei_out : real;
    signal bi_out : real;
begin
     kronecker_dev : entity work.pulse generic map(
         delay => 4,
         w_pulse => 2,
         initial => 0.0
     ) port map(
         clock_port => clk_signal,
         output_port => kronecker_signal_puls
     );

    clock_dev : entity work.clock generic map(
        start => '0',
        period => 10 ns
    ) port map(
        clk => clk_signal
    );

    bei_dev : entity work.myInt_BEI generic map(
        initial => 0.0
    ) port map (
        input_port => kronecker_signal_puls,
        clk => clk_signal,
        output_port => bei_out
    );

    fei_dev : entity work.myInt_FEI generic map(
        initial => 0.0
    ) port map (
        input_port => kronecker_signal_puls,
        clk => clk_signal,
        output_port => fei_out
    );

    bi_dev : entity work.myInt_BI generic map(
        initial => 0.0
    ) port map(
        input_port => kronecker_signal_puls,
        clk => clk_signal,
        output_port => bi_out
    );

end architecture a;