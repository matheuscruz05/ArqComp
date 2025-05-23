--************************************
-- Matheus Cruz da Silva - 2306352
-- Gabriel Mororó - 2306298
--************************************
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_regs_ula is
    port (
        clk:                 in std_logic;
        rst:                 in std_logic;
        wr_en:               in std_logic;            -- Write enable para os registradores
        data_wr:             in unsigned(15 downto 0); -- Dados a serem escritos nos registradores
        reg_wr:              in unsigned(2 downto 0);  -- Escolhe em qual registrador escrever (3 bits para 6 registradores)
        sel_reg:             in unsigned(2 downto 0);  -- Escolhe qual registrador ler (3 bits para 6 registradores)
        ula_operation_sel:   in unsigned(1 downto 0);  -- Operação da ULA (ADD, SUB, etc.)
        operando_cte:        in unsigned(15 downto 0); -- Valor constante (se necessário)
        operando_selector:   in std_logic;             -- Define se o operando é uma constante ou um registrador
        out_ula:             out unsigned(15 downto 0) -- Saída da ULA
    );
end entity;

architecture a_banco_regs_ula of banco_regs_ula is

    -- Componentes
    component banco_regs is
        port (
            clk:            in std_logic;
            rst:            in std_logic;
            wr_en:          in std_logic;
            data_wr:        in unsigned(15 downto 0);
            reg_wr:         in unsigned(2 downto 0);  -- 3 bits para 6 registradores
            sel_reg:        in unsigned(2 downto 0);  -- 3 bits para 6 registradores
            data_out:       out unsigned(15 downto 0)
        );
    end component;

    component acumulador is
        port (
            clk:            in std_logic;
            rst:            in std_logic;
            wr_en:          in std_logic;
            data_in:        in unsigned(15 downto 0);
            data_out:       out unsigned(15 downto 0)
        );
    end component;

    component ula is
        port (
            inputA:         in unsigned(15 downto 0);
            inputB:         in unsigned(15 downto 0);
            selec_op:       in unsigned(1 downto 0);
            result:         out unsigned(15 downto 0);
            flag_zero:      out std_logic;
            flag_carry:     out std_logic;
            flag_negative:  out std_logic;
            flag_overflow:  out std_logic;
            opt_equal:      out std_logic;
            opt_less:       out std_logic
        );
    end component;

    -- Sinais internos
    signal data_out_reg, data_out_acumulador : unsigned(15 downto 0);
    signal operando_banco, operando_acumulador : unsigned(15 downto 0);
    signal ula_result  : unsigned(15 downto 0);
    signal operando_selecionado : unsigned(15 downto 0);

begin

    -- Instanciação do banco de registradores
    banco_regs_uut: banco_regs port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        sel_reg => sel_reg,
        data_out => data_out_reg
    ); 

    -- Instanciação da ULA
    ula_uut: ula port map(
        inputA => data_out_acumulador,    -- primeira entrada vai ser a saída do acumulador
        inputB => operando_selecionado,   -- segunda entrada pode ser o registrador ou a constante
        selec_op => ula_operation_sel, 
        result => ula_result,
        flag_zero => open,  -- Flags podem ser usadas futuramente se necessário
        flag_carry => open,
        flag_negative => open,
        flag_overflow => open,
        opt_equal => open,
        opt_less => open
    );

    -- Instanciação do acumulador
    acumulador_uut: acumulador port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => ula_result,
        data_out => data_out_acumulador
    );

    -- Seleção do operando para a ULA
    -- Operando 1 = Acumulador
    -- Operando 2 = Banco de registradores ou constante
    operando_selecionado <= operando_cte when operando_selector = '0' else  -- se o operando_selector for 0, o operando vai ser a constante 
                            data_out_reg when operando_selector = '1' else  -- se o operando_selector for 1, o operando vai ser a saída do registrador
                            "0000000000000000";    -- caso não selecione nenhum operando, coloca 0

    -- Pino de saída extra para debug
    out_ula <= ula_result;

end architecture;
