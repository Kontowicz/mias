# do run.do <input_filename> <output_filename> <OSR>

vcom decymator.vhd clock.vhd decimator_tb.vhd
vsim work.decimator_tb -gin_file=$1 -gout_file=$2 -gOSR=$3
add wave *
add wave -position insertpoint sim:/decimator_tb/d_decimator/*
run -all