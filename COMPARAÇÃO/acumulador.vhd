library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
    port(
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0); -- Dados a serem armazenados no acumulador
        data_out:       out unsigned(15 downto 0)  -- Saída do valor armazenado no acumulador
    );
end entity;

architecture a_acumulador of acumulador is 

    -- Componente de registrador de 16 bits, que será usado para o acumulador
    component regs16bits is
        port(
            clk:        in std_logic;
            rst:        in std_logic;
            wr_en:      in std_logic;
            data_in:    in unsigned(15 downto 0);
            data_out:   out unsigned(15 downto 0)
        );
    end component;

begin

    -- Instanciação do registrador (acumulador) que armazena os resultados da ULA
    reg: regs16bits port map(
        clk => clk,               -- Clock
        rst => rst,               -- Reset
        wr_en => wr_en,           -- Habilita ou desabilita a escrita
        data_in => data_in,       -- Dados da ULA a serem armazenados no acumulador
        data_out => data_out      -- Saída do acumulador
    );

end architecture;
