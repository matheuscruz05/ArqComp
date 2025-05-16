#!/bin/bash

# Limpeza de cache e arquivos antigos
rm -f *.o *.cf tb_ULA.ghw
rm -f work-obj93.cf

# Compilação
ghdl -a ULA.vhd
ghdl -a tb_ULA.vhd

# Elaboração
ghdl -e tb_ULA

# Execução com geração de waveform
ghdl -r tb_ULA --wave=tb_ULA.ghw

# Visualização
gtkwave tb_ULA.ghw
