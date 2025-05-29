#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a uc.vhd
ghdl -a uc_tb.vhd

ghdl -e uc_tb
ghdl -r uc_tb --wave=uc_tb.ghw

gtkwave uc_tb.ghw
