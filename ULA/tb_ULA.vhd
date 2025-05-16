-- Matheus Cruz da Silva - 2306352
-- Gabriel Mororó - 2306298
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ULA is
end;

architecture a_tb_ULA of tb_ULA is
    component ULA
        port(
            inputA, inputB : in unsigned(15 downto 0);
            selec_op       : in unsigned(1 downto 0);
            result         : out unsigned(15 downto 0);
            flag_zero      : out std_logic;
            flag_carry     : out std_logic;
            flag_negative  : out std_logic;
            flag_overflow  : out std_logic;
            opt_equal      : out std_logic;
            opt_less       : out std_logic
        );
    end component;

    -- Entradas
    signal inA, inB : unsigned(15 downto 0);
    signal sel_op   : unsigned(1 downto 0);

    -- Saída
    signal outR     : unsigned(15 downto 0);

    -- Flags
    signal fZ, fC, fN, fV : std_logic;
    signal fEq, fLt : std_logic;  -- Flags para as comparações


begin

    -- Instanciação da ULA
    uut: ULA port map(
        inputA        => inA,
        inputB        => inB,
        selec_op      => sel_op,
        result        => outR,
        flag_zero     => fZ,
        flag_carry    => fC,
        flag_negative => fN,
        flag_overflow => fV,
        opt_equal     => fEq,  -- Para verificar a flag de igualdade
        opt_less      => fLt   -- Para verificar a flag de menor que
    );

    -- Processo de teste
    process
    begin
        -- Soma: 85 + 60
        sel_op <= "00";
        inA <= to_unsigned(85, 16);
        inB <= to_unsigned(60, 16);
        wait for 50 ns;

        -- Subtração: 85 - 60
        sel_op <= "01";
        inA <= to_unsigned(85, 16);
        inB <= to_unsigned(60, 16);
        wait for 50 ns;

        -- Subtração com negativo: 60 - 85
        sel_op <= "01";
        inA <= to_unsigned(60, 16);
        inB <= to_unsigned(85, 16);
        wait for 50 ns;

        -- Soma com overflow: 32760 + 10
        sel_op <= "00";
        inA <= to_unsigned(32760, 16);
        inB <= to_unsigned(10, 16);
        wait for 50 ns;

        -- Comparação de igualdade: 85 == 85
        sel_op <= "10";  -- Comparação de igualdade
        inA <= to_unsigned(85, 16);  -- Esperado: fEq = 1
        inB <= to_unsigned(85, 16);  -- Esperado: fEq = 1
        wait for 50 ns;

        -- Comparação de menor que: 60 < 85
        sel_op <= "11";  -- Comparação de menor que
        inA <= to_unsigned(60, 16);  -- Esperado: fLt = 1
        inB <= to_unsigned(85, 16);  -- Esperado: fLt = 1
        wait for 50 ns;

        -- Comparação de menor que (invertendo a ordem): 85 < 60
        sel_op <= "11";  -- Comparação de menor que
        inA <= to_unsigned(85, 16);  -- Esperado: fLt = 0
        inB <= to_unsigned(60, 16);  -- Esperado: fLt = 0
        wait for 50 ns;

        wait;
    end process;

end architecture;
