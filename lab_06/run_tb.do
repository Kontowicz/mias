vcom decymator.vhd 02.vhd 03.vhd 04.vhd 05.vhd adc.vhd clock.vhd dac.vhd FEI.vhd sigma_delta.vhd sine_package.vhd sine_wave.vhd tb.vhd -2008
vsim work.tb
add wave /tb/sinus_orginal
add wave /tb/sinus_real
add wave /tb/linear_combination
add wave /tb/integrator
add wave /tb/adc_cout
add wave /tb/decimator_out_port
run 100us