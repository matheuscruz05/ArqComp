#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a regs7bits.vhd
ghdl -a pc.vhd
ghdl -a pc_tb.vhd

ghdl -e pc_tb
ghdl -r pc_tb --wave=pc_tb.ghw

gtkwave pc_tb.ghw

