#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a regs7bits.vhd
ghdl -a pc.vhd
ghdl -a rom.vhd
ghdl -a uc.vhd
ghdl -a top_level.vhd
ghdl -a top_level_tb.vhd

ghdl -e top_level_tb
ghdl -r top_level_tb --wave=top_level_tb.ghw

gtkwave top_level_tb.ghw
