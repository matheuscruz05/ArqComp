# 🧠 Microprocessador – Parte 4: Unidade de Controle Rudimentar

## 🎯 Objetivo

Nesta etapa do projeto, foi desenvolvida a **unidade de controle rudimentar** do microprocessador. O objetivo principal foi implementar e validar os seguintes blocos funcionais:

- ROM síncrona com instruções
- Contador de Programa (PC)
- Máquina de estados com flip-flop T
- Unidade de Controle (UC)
- Módulo top-level integrando os componentes
- Testes individuais para cada módulo (testbenches)

---

## 🧩 Componentes Desenvolvidos

### 1. **ROM (`rom.vhd`)**

- Memória síncrona de 128 posições, com 14 bits por instrução.
- Leitura controlada por clock (`rising_edge(clk)`), sem `rd_en`.
- Conteúdo definido em `conteudo_rom`, incluindo instruções como `JUMP`.

### 2. **PC (`pc.vhd`)**

- Registrador de 7 bits.
- Controlado por sinais `clk`, `rst`, `wr_en`.
- Atualiza o valor apenas quando `wr_en = '1'`.

### 3. **Flip-Flop T / Máquina de Estados (`state_machine.vhd`)**

- Alterna entre dois estados (`fetch` e `decode/execute`) a cada borda de subida do clock.
- Resetado para o estado `0`.

### 4. **Unidade de Controle (`uc.vhd`)**

- Recebe a instrução da ROM.
- Alterna entre os dois estados e controla:
  - `pc_wr_en`: ativo no estado decode.
  - `jump_en`: ativo quando a instrução possui opcode `1111` (JUMP) no estado decode.

### 5. **Módulo de Integração (`top_level.vhd`)**

- Integra ROM, UC, PC e máquina de estados.
- Controla o fluxo `fetch → decode`, e determina se o próximo PC será `PC+1` ou o endereço do `JUMP`.

---

## 🧪 Testes e Verificações

### ✅ **ROM (`rom_tb.vhd`)**

- 📌 Verifica se o valor retornado na saída `dado` corresponde ao endereço fornecido.
- ✅ ROM é síncrona: os dados mudam somente na borda de subida do clock.
- ✅ Resultado validado com GTKWave — valores como `0B => 000C` retornam corretamente.

### ✅ **PC (`pc_tb.vhd`)**

- 📌 Verifica comportamento com `rst` e `wr_en`.
- ✅ `rst = 1` força `data_out = 0`.
- ✅ Quando `wr_en = 1`, `data_out` segue `data_in` na borda de clock.
- ✅ Quando `wr_en = 0`, valor permanece constante.

### ✅ **Máquina de Estados (`state_machine_tb.vhd`)**

- 📌 Simula alternância entre `0` e `1` a cada ciclo de clock.
- ⚠️ Observação: o `rst` deve ser desativado (passar de `1` para `0`) para liberar a alternância.
- ✅ Após liberação do `rst`, `state` alterna como esperado.

### ✅ **Unidade de Controle (`uc_tb.vhd`)**

- 📌 Decodifica o `opcode` da instrução e ativa `jump_en` apenas se for `1111` no estado decode.
- ✅ `pc_wr_en` fica ativo nos ciclos de decode.
- ✅ `jump_en` ativado apenas no ciclo correto.
- ⚠️ `rst` deve ser liberado para ativar a máquina de estados.

### ✅ **Top Level (`top_level_tb.vhd`)**

- 📌 Valida o comportamento completo: `ROM → UC → PC`.
- ✅ `pc_out` incrementa a cada ciclo decode.
- ✅ Quando detecta um `JUMP`, o `pc_out` salta para o endereço contido na instrução (após 1 ciclo).
- ✅ Sinais `next_pc` e `instr` se comportam conforme esperado.

---

## 🛠️ Scripts de Simulação

Cada testbench possui um script `.sh` com o seguinte padrão:

```bash
#!/bin/bash

rm -f *.o *.cf *.ghw work-obj93.cf

ghdl -a arquivos_necessarios.vhd
ghdl -e nome_do_testbench
ghdl -r nome_do_testbench --wave=nome_do_testbench.ghw

gtkwave nome_do_testbench.ghw


```
