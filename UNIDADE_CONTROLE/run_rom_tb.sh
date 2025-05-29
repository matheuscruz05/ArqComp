#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a rom.vhd
ghdl -a rom_tb.vhd

ghdl -e rom_tb
ghdl -r rom_tb --wave=rom_tb.ghw

gtkwave rom_tb.ghw
