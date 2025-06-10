@echo off
set TESTBENCH=processador_tb

:: Compila todos os arquivos VHDL
ghdl -a *.vhd

:: Compila o testbench
ghdl -a %TESTBENCH%.vhd
ghdl -e %TESTBENCH%

:: Executa a simulação e gera o arquivo de waveform
ghdl -r %TESTBENCH% --wave=%TESTBENCH%.ghw

:: Abre o GTKWave
gtkwave %TESTBENCH%.ghw

:: Limpa arquivos gerados
del /f /q work-obj93.cf

