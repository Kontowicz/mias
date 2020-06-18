vcom 02.vhd 03.vhd 04.vhd sine_package.vhd sine_wave.vhd tb.vhd -2008
vsim work.tb
add wave *
run 50 us
wave zoom full