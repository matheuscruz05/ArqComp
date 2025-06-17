#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a state_machine.vhd
ghdl -a state_machine_tb.vhd

ghdl -e state_machine_tb
ghdl -r state_machine_tb --wave=state_machine_tb.ghw

gtkwave state_machine_tb.ghw
