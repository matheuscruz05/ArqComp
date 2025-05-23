# Microprocessador - Segunda Entrega

Projeto de microprocessador desenvolvido em **VHDL** para a disciplina de Organização e Projeto de Computadores. A segunda entrega abrange a implementação do **banco de registradores**, do **acumulador** e sua integração com a **ULA**.

## ✅ Especificações do Projeto

### 🔧 **Banco de Registradores**

- O **banco de registradores** é composto por **6 registradores** de **16 bits**. Cada registrador pode ser lido e escrito conforme necessário.
- O **banco de registradores** interage com a **ULA**, permitindo que ela execute operações aritméticas e lógicas entre os valores armazenados nos registradores ou constantes.

### 🔧 **Acumulador**

- O **acumulador** armazena o resultado das operações realizadas pela **ULA**.
- Ele é atualizado com o resultado da operação de **soma** ou **subtração** realizada pela **ULA** e pode interagir com os registradores.

### 🔧 **Operações**

- **Operações de Soma e Subtração**: A **ULA** realiza operações entre o **acumulador** e os **registradores** ou constantes.
- **Testes de Comparação**: A **ULA** também realiza comparações e o microprocessador verifica as **flags** de igualdade e menor que.

---

## 🧪 Casos de Teste Realizados

Todos os testes foram implementados no **testbench** (`banco_regs_ula_tb.vhd`) com temporizações de **100 ns** entre cada um.

### 🧮 Operações no Banco de Registradores

| Operação                      | Registrador Selecionado | Operando | Valor Esperado | Justificativa               |
| ----------------------------- | ----------------------- | -------- | -------------- | --------------------------- |
| **Escrita no Registrador**    | r1 (reg_wr = "001")     | 2        | 2              | Escrita no r1 com valor 2   |
| **Leitura e Soma**            | r1 (sel_reg = "001")    | 3        | 5              | Leitura de r1 + constante 3 |
| **Escrita no Registrador r5** | r5 (reg_wr = "101")     | 8        | 8              | Escrita no r5 com valor 8   |
| **Leitura e Soma**            | r5 (sel_reg = "101")    | 2        | 10             | Leitura de r5 + constante 2 |

### 🚩 **Verificação das Flags**

| Caso           | Z (Zero) | C (Carry) | N (Negative) | V (Overflow) | Justificativa                    |
| -------------- | -------- | --------- | ------------ | ------------ | -------------------------------- |
| **Soma 2 + 3** | 0        | 0         | 0            | 0            | Resultado positivo, sem overflow |
| **Soma 8 + 2** | 0        | 0         | 0            | 0            | Resultado positivo, sem overflow |

---

## ✅ Constantes do Projeto

### 1. **Para a ULA (Unidade Lógica e Aritmética)**

**`operation`**: Este sinal seleciona a operação que a **ULA** deve realizar. Aqui estão os valores para as diferentes operações:

| **Valor de `operation`** | **Operação Realizada**      |
| ------------------------ | --------------------------- |
| `00`                     | **Soma (ADD)**              |
| `01`                     | **Subtração (SUB)**         |
| `10`                     | **AND** (Operação lógica E) |
| `11`                     | **OR** (Operação lógica OU) |

---

### 2. **Para o Banco de Registradores (relacionado com a ULA)**

**`operando_selector`**: Esse sinal determina qual valor será utilizado para a operação pela **ULA**. Pode ser uma **constante** ou o **valor de um registrador** (registrador r1 no seu caso). Aqui estão os valores para cada seleção:

| **Valor de `operando_selector`** | **Descrição**                                                                  |
| -------------------------------- | ------------------------------------------------------------------------------ |
| `0`                              | **Usa a constante** (valor fornecido por `operando_cte`)                       |
| `1`                              | **Usa o valor do registrador r1** (valor armazenado no banco de registradores) |

---

## 🛠️ Ferramentas utilizadas

- **Simulador**: `GHDL`
- **Visualização de ondas**: `GTKWave`
- **Sistema operacional**: Ubuntu

---

## 📁 Arquivos da entrega

- **`banco_regs.vhd`** — Código fonte do banco de registradores.
- **`acumulador.vhd`** — Código fonte do acumulador.
- **`banco_regs_ula.vhd`** — Integração do banco de registradores com a ULA.
- **`banco_regs_ula_tb.vhd`** — Testbench cobrindo todos os casos de interesse.
- **`run_simulation.sh`** — Script de compilação e simulação.
- **`README.md`** — Documento descritivo do projeto.

---

## 📌 Observações

- **Integração**: O **banco de registradores** e o **acumulador** estão totalmente integrados à **ULA** para realizar operações aritméticas e lógicas.
- **Testes**: Todos os testes de leitura e escrita no banco de registradores, além das operações de soma e subtração, foram realizados e validados.
- **Próximos Passos**: Este projeto está pronto para ser expandido com mais funcionalidades, como instruções de comparação mais complexas (CMPI) e operações de salto condicional.

---

Esse é o **README.md** atualizado, incluindo as tabelas de **constantes de operação** da ULA e de **seleção de operando** para o banco de registradores. Você pode copiá-lo diretamente e colá-lo no arquivo **README.md** do seu projeto. Se precisar de mais modificações ou ajustes, estou à disposição!
