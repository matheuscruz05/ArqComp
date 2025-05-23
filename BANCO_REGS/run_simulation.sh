#!/bin/bash

# Limpeza de cache e arquivos antigos
rm -f *.o *.cf *.ghw work-obj93.cf

# Compilação dos arquivos VHDL
ghdl -a acumulador.vhd
ghdl -a banco_regs.vhd
ghdl -a banco_regs_ula.vhd
ghdl -a regs16bits.vhd
ghdl -a ula.vhd
ghdl -a banco_regs_ula_tb.vhd  # Testbench

# Elaboração do testbench (tb_banco_regs_ula)
ghdl -e banco_regs_ula_tb

# Execução da simulação com geração de waveform (.ghw)
ghdl -r banco_regs_ula_tb --wave=banco_regs_ula_tb.ghw

# Visualização do waveform gerado
gtkwave banco_regs_ula_tb.ghw
