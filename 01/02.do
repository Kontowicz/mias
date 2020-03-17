vcom 01.vhd
vsim work.gen
add wave CLK
add wave S1
add wave S2
add wave S3
add wave S4
force CLK 0 0, 1 20 -repeat 40
force S1 1 0, 0 10 -r 20
force S2 1 0, 0 10, 1 30, 0 50
force S3 "01" 0, "00" 10 -cancel
force S3 "11" 20
force S4 2 10, 5 40
run 100ns
wave zoom full