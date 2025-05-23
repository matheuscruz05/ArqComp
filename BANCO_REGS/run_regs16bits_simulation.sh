#!/bin/bash

# Limpeza de arquivos antigos
rm -f *.o *.cf *.ghw work-obj93.cf

# Compilação dos arquivos VHDL
ghdl -a regs16bits.vhd
ghdl -a regs16bits_tb.vhd

# Elaboração do testbench
ghdl -e regs16bits_tb

# Execução da simulação com geração de waveform (.ghw)
ghdl -r regs16bits_tb --wave=regs16bits_tb.ghw

# Visualização do waveform gerado
gtkwave regs16bits_tb.ghw
