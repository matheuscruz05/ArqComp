library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs16bits_tb is
end entity;

architecture a_regs16bits_tb of regs16bits_tb is 

    -- Instância do componente regs16bits
    component regs16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Constantes e sinais
    constant period_time : time := 100 ns;
    signal   finished    : std_logic := '0';
    signal data_in, data_out : unsigned(15 downto 0);
    signal clk, rst, wr_en    : std_logic;       

begin

    -- Instância do registrador
    uut: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
    );

    -- Geração do Reset
    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 2;  -- Espera 2 ciclos de clock para garantir
        rst <= '0';
        wait;
    end process;

    -- Definição do tempo de simulação
    sim_time_proc: process
    begin
        wait for 10 us;  -- Tempo total da simulação
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Geração do clock
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

    -- Processo que define os casos de teste
    process
    begin
        -- Teste de escrita no registrador
        wait for 200 ns;
        wr_en <= '0';  -- Desabilita a escrita
        data_in <= "1111111111111111";  -- Dados a serem escritos
        wait for 200 ns;

        -- Teste de escrita no registrador
        data_in <= "1000110111100001";  -- Dados diferentes
        wait for 200 ns;

        -- Ativa a escrita e escreve no registrador
        wr_en <= '1';
        data_in <= "0100100100011011";  -- Dados a serem escritos
        wait for 200 ns;

        -- Teste de nova escrita no registrador
        data_in <= "1111111111111111";  -- Dados a serem escritos
        wait for 200 ns;

        -- Tenta escrever com wr_en = 0 (não deve modificar)
        wr_en <= '0';
        data_in <= "1111111111111111";  -- Esperado: 0000000000000000
        wait for 200 ns;

        -- Teste adicional com wr_en = 0 (não deve modificar)
        wr_en <= '0';
        data_in <= "1111111111111111";  -- Esperado: 0000000000000000
        wait for 200 ns;

        -- Ativa a escrita novamente
        wr_en <= '1';
        data_in <= "1111111111111111";  -- Dados a serem escritos
        wait for 200 ns;

        -- Teste de escrita com outro valor
        wr_en <= '0';
        data_in <= "0000111111111111";  -- Esperado: 0000111111111111
        wait for 200 ns;

        -- Finaliza a simulação
        wait;
    end process;

end architecture;
