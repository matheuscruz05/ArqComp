library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is 
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0); -- dado a ser escrito no registrador
        reg_wr:         in unsigned(2 downto 0);  -- escolhe em qual registrador escrever (3 bits para 6 registradores)
        sel_reg:        in unsigned(2 downto 0);  -- escolhe qual registrador ler
        data_out:       out unsigned(15 downto 0) -- saída do registrador
    );
end entity;

architecture a_banco_regs of banco_regs is

    component regs16bits is
        port (
            clk:        in std_logic;
            rst:        in std_logic;
            wr_en:      in std_logic;
            data_in:    in unsigned(15 downto 0);
            data_out:   out unsigned(15 downto 0)
        );
    end component;

    -- Sinais para controle de leitura e escrita de 6 registradores
    signal wr_en_regs : std_logic_vector(5 downto 0);
    signal r0_out, r1_out, r2_out, r3_out, r4_out, r5_out : unsigned(15 downto 0);

begin

    -- Controle de escrita nos registradores
    wr_en_regs(0) <= '1' when reg_wr = "000" and wr_en = '1' else '0';
    wr_en_regs(1) <= '1' when reg_wr = "001" and wr_en = '1' else '0';
    wr_en_regs(2) <= '1' when reg_wr = "010" and wr_en = '1' else '0';
    wr_en_regs(3) <= '1' when reg_wr = "011" and wr_en = '1' else '0';
    wr_en_regs(4) <= '1' when reg_wr = "100" and wr_en = '1' else '0';
    wr_en_regs(5) <= '1' when reg_wr = "101" and wr_en = '1' else '0';

    -- Instanciação dos 6 registradores
    reg0: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(0),
        data_in => data_wr,
        data_out => r0_out
    );

    reg1: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(1),
        data_in => data_wr,
        data_out => r1_out
    );

    reg2: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(2),
        data_in => data_wr,
        data_out => r2_out
    );

    reg3: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(3),
        data_in => data_wr,
        data_out => r3_out
    );

    reg4: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(4),
        data_in => data_wr,
        data_out => r4_out
    );

    reg5: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(5),
        data_in => data_wr,
        data_out => r5_out
    );

    -- Seleção do registrador para leitura
    data_out <= r0_out when sel_reg = "000" else
                r1_out when sel_reg = "001" else
                r2_out when sel_reg = "010" else
                r3_out when sel_reg = "011" else
                r4_out when sel_reg = "100" else
                r5_out when sel_reg = "101" else
                "0000000000000000"; -- Se nenhum registrador for selecionado, retorna 0

end architecture;
