vcom 03.vhd
vsim work.comparator
set t 50
add wave *
force A(0) 0 0, 1 [expr 1*$t]ns -r [expr 2*$t]ns
force A(1) 0 0, 1 [expr 2*$t]ns -r [expr 4*$t]ns
force B(0) 0 0, 1 [expr 4*$t]ns -r [expr 8*$t]ns
force B(1) 0 0, 1 [expr 8*$t]ns -r [expr 16*$t]ns
run [expr 100*$t]ns
wave zoom full
