

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.all;
use work.sine_package.all;

entity tb is
    port(
        sinus_orginal : out sine_vector_type;
        sinus_real : out real;
        linear_combination: out real;
        integrator : out real;
        adc_cout : out std_logic;
        dac_cout : out real;
        decimator_out_port : out integer
      );
end entity tb;

architecture bench of tb is
  signal clock, clock_sd, reset, enable: std_logic;
  signal wave_out: sine_vector_type;
  signal wave_out_real : real;
  constant clock_period: time := 40 ns;
  constant clock_period_sd: time := 5 ns;
  signal sigma_delta_signal : std_logic;
  signal decimator_out : integer;

  signal lc_out_sd_signal : real;
  signal int_out_sd_signal : real;
  signal adc_out_sd_signal : std_logic;
  signal dac_out_sd_signal : real;

  begin
    reset <= '0' after 2 ns;
    enable <= '1' after 2 ns;

    clocking: process
    begin
        clock <= '1', '0' after clock_period / 2;
        wait for clock_period;
    end process;

    clocking_sd: process
    begin
        clock_sd <= '1', '0' after clock_period_sd / 2;
        wait for clock_period_sd;
    end process;

    sine_gen: entity sine_wave port map ( clock, reset, enable, wave_out );

    sample_hold_dev : entity work.sample_hold generic map(
        initial => 0.0,
        vec_length => 8
    )
    port map(
        inputt =>wave_out,
        clk =>clock_sd,
        outputt => wave_out_real
    );

    sigma_delta_dev : entity work.sigma_delta generic map(
        initial => '0'
    ) port map(
        input_port => wave_out_real,
        output_port => sigma_delta_signal,
        clk_port => clock_sd,
        lc_out_port => lc_out_sd_signal,
        integrator_out_port => int_out_sd_signal,
        adc_out_port => adc_out_sd_signal,
        dac_out_port => dac_out_sd_signal
    );

    decimator_dev : entity work.decimator generic map(
        delay => 2 ns,
        FS => 0, 
        OSR => 5
    ) port map (
        clk => clock,
        data_in => sigma_delta_signal,
        data_out => decimator_out
    );
    dac_cout <= dac_out_sd_signal;
    sinus_orginal <= wave_out;
    sinus_real <= wave_out_real;
    linear_combination <= lc_out_sd_signal;
    integrator <= int_out_sd_signal;
    adc_cout <= adc_out_sd_signal;
    decimator_out_port <= decimator_out;
end;
