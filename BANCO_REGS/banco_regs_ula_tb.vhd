library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_ula_tb is
end entity;

architecture a_banco_regs_ula_tb of banco_regs_ula_tb is 

    -- Instância do componente banco_regs_ula
    component banco_regs_ula is
        port (
            clk:                 in std_logic;
            rst:                 in std_logic;
            wr_en:               in std_logic;
            data_wr:             in unsigned(15 downto 0);
            reg_wr:              in unsigned(2 downto 0);  -- 3 bits para 6 registradores
            sel_reg:             in unsigned(2 downto 0);  -- 3 bits para 6 registradores
            ula_operation_sel:   in unsigned(1 downto 0);
            operando_cte:        in unsigned(15 downto 0);
            operando_selector:   in std_logic;
            out_ula:             out unsigned(15 downto 0)
        );
    end component;

    -- Constantes e sinais
    constant period_time : time := 100 ns; 
    signal finished : std_logic := '0';

    -- Sinais do testbench
    signal clk, rst, wr_en : std_logic;
    signal data_wr : unsigned(15 downto 0);
    signal reg_wr : unsigned(2 downto 0);
    signal sel_reg : unsigned(2 downto 0);
    signal ula_operation_sel : unsigned(1 downto 0);
    signal operando_cte : unsigned(15 downto 0);
    signal operando_selector : std_logic;
    signal out_ula : unsigned(15 downto 0);

begin

    -- Instância do banco de registradores e ULA
    uut: banco_regs_ula port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        sel_reg => sel_reg,
        ula_operation_sel => ula_operation_sel,
        operando_cte => operando_cte,
        operando_selector => operando_selector,
        out_ula => out_ula
    );
       
    -- Processo para reset global
    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 2;
        rst <= '0';
        wait;
    end process;
    
    -- Processo de simulação
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    -- Gerador de clock
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;
    
    -- Processo principal do testbench que define os casos de teste
    process
    begin
        -- Reset inicial
        wait for 200 ns;
        
        -- Teste 1: Escrever no registrador r1 com valor 2
        sel_reg <= "001";  -- Seleciona o registrador r1
        operando_selector <= '0'; -- operando = constante
        operando_cte <= "0000000000000011"; -- 3 (valor constante)
        ula_operation_sel <= "00"; -- Operação de soma

        wr_en <= '1';
        reg_wr <= "001"; -- Escreve no r1
        data_wr <= "0000000000000010"; -- 2 (valor a ser escrito)

        wait for 100 ns;

        -- Teste 2: Ler de r1 e adicionar valor de registrador r1 com constante
        sel_reg <= "001";  -- Seleciona o registrador r1
        operando_selector <= '1'; -- Operando = valor do registrador
        wr_en <= '0'; -- Desabilita a escrita para apenas ler

        wait for 100 ns;

        -- Teste 3: Escrever no registrador r5 com valor 8
        wr_en <= '1';
        reg_wr <= "101"; -- Escreve no r5
        data_wr <= "0000000000001000"; -- 8

        wait for 100 ns;

        -- Teste 4: Ler de r5 e adicionar o valor de r5 com constante
        sel_reg <= "101"; -- Seleciona o registrador r5
        operando_selector <= '1'; -- Operando = valor do registrador
        wr_en <= '0'; -- Desabilita a escrita

        wait for 100 ns;

        -- Teste 5: Operação de soma com valores de r1 e r5
        operando_selector <= '1';  -- operando = registrador
        sel_reg <= "001";  -- Seleciona r1
        operando_cte <= "0000000000000010"; -- Valor a ser somado
        ula_operation_sel <= "00"; -- Operação de soma

        wait for 100 ns;

        -- Teste 6: Confirmar que a operação de soma foi realizada corretamente
        sel_reg <= "101"; -- Seleciona r5 para verificar
        operando_selector <= '1';  -- operando = registrador
        wr_en <= '0'; -- Desabilita a escrita

        wait for 100 ns;

        -- Finaliza o testbench
        wait;
    end process;
    
end architecture;
