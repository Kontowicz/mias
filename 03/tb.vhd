
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.all;
use work.sine_package.all;

entity tb is
end entity tb;

architecture bench of tb is
  signal clock, reset, enable: std_logic;
  signal wave_out: sine_vector_type;
  constant clock_period: time := 50 ns;
  constant sample_hold_clk_period : time := 10 ns;

  signal sample_hold_clk : std_logic;
  signal sample_hold_out_signal : real;
  signal ZDelay_out_signal : real;
  signal linearCombination_out_signal : real;

  begin
    reset <= '0' after 2 ns;
    enable <= '1' after 2 ns;
    sine_gen: entity sine_wave port map ( clock, reset, enable, wave_out );

    sample_hold_device : entity work.sample_hold
      generic map (initial=>0.0, vec_length=>8)
      port map (	clk => sample_hold_clk,
                    inputt => wave_out,
                    outputt => sample_hold_out_signal);

    ZDelay_device : entity work.ZDelay
      generic map (count=>10, initial=>0.0)
      port map (	clk => sample_hold_clk,
                      inputt => sample_hold_out_signal,
                      outputt => ZDelay_out_signal);

    linearCombination_device : entity work.linearCombination
      generic map (inital=>0.0, coeffA=>1.0, coeddB => 10.0)
      port map (
                      inputA => sample_hold_out_signal,
                      inputB => ZDelay_out_signal,
                      outputt => linearCombination_out_signal);

    sh_clk: process
    begin
        sample_hold_clk <= '1', '0' after sample_hold_clk_period / 2;
        wait for sample_hold_clk_period;
    end process;

    clocking: process
    begin
        clock <= '1', '0' after clock_period / 2;
        wait for clock_period;
    end process;

end;
