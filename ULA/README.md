# ULA - Primeira Entrega

Projeto desenvolvido em VHDL para a disciplina de Organização e Projeto de Computadores.

## ✅ Especificações da ULA

- **Entradas de dados**: `inputA`, `inputB` – 16 bits (tipo: `unsigned`)
- **Saída**: `result` – 16 bits
- **Operações suportadas (via seletor `selec_op`)**:
  - `"00"` → Soma (`A + B`)
  - `"01"` → Subtração (`A - B`)
- **Flags implementadas**:
  - `flag_zero` (Z): Resultado igual a zero
  - `flag_carry` (C): Carry da soma ou borrow da subtração
  - `flag_negative` (N): Bit mais significativo do resultado (sinal em complemento de 2)
  - `flag_overflow` (V): Estouro em operações com sinal

---

## 🧪 Casos de Teste Realizados

Todos os testes foram implementados no testbench (`tb_ULA.vhd`) com temporizações de 50 ns entre cada um.

### 🧮 Operações aritméticas

| Operação           | inputA | inputB | sel_op | Resultado Esperado |
| ------------------ | ------ | ------ | ------ | ------------------ |
| Soma               | 85     | 60     | "00"   | 145                |
| Subtração          | 85     | 60     | "01"   | 25                 |
| Subtração Negativa | 60     | 85     | "01"   | -25 (0xFFE7)       |
| Soma com Overflow  | 32760  | 10     | "00"   | 32770 (0x8002)     |

### 🚩 Verificação das Flags

| Caso              | Z   | C   | N   | V   | Justificativa                            |
| ----------------- | --- | --- | --- | --- | ---------------------------------------- |
| Soma 85 + 60      | 0   | 0   | 0   | 0   | Resultado positivo, sem overflow         |
| Subtração 85 - 60 | 0   | 0   | 0   | 0   | Sem borrow, resultado positivo           |
| Subtração 60 - 85 | 0   | 1   | 1   | 0   | Borrow detectado, resultado negativo     |
| Soma 32760 + 10   | 0   | 0   | 1   | 1   | Overflow com sinal (positivo → negativo) |

---

## 🛠️ Ferramentas utilizadas

- Simulador: `GHDL`
- Visualização de ondas: `GTKWave`
- Sistema operacional: Ubuntu

---

## 📁 Arquivos da entrega

- `ULA.vhd` — Código fonte da ULA
- `tb_ULA.vhd` — Testbench cobrindo todos os casos de interesse
- `run_ula.sh` — Script de compilação e simulação
- `README.md` — Documento descritivo do projeto

---

## 📌 Observações

- Projeto compatível com futura integração ao processador com acumulador.
- Extensível para suportar `CMPI`, `CLZ` e outras instruções específicas para validação e controle de fluxo.
