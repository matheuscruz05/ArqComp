library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
    port(
        inputA, inputB : in unsigned(15 downto 0); -- Entradas de 16 bits
        selec_op       : in unsigned(1 downto 0);  -- Seletor da operação
        result         : out unsigned(15 downto 0);-- Saída do resultado
        flag_zero      : out std_logic;            -- Z = 1 se resultado = 0
        flag_carry     : out std_logic;            -- Carry
        flag_negative  : out std_logic;            -- Sinal (MSB do resultado)
        flag_overflow  : out std_logic;            -- Overflow aritmético
        opt_equal      : out std_logic;
        opt_less       : out std_logic
    );
end entity;

architecture a_ULA of ULA is
    signal sum, sub, comp2 : unsigned(15 downto 0);
    signal internal_result : unsigned(15 downto 0);
    signal carry_aux       : std_logic;
    
begin

    -- Soma
    sum <= inputA + inputB;

    -- Subtração usando complemento de 2
    comp2 <= not(inputB) + 1;
    sub <= inputA + comp2;

    -- Comparações
    opt_equal <= '1' when (inputA = inputB) and (selec_op = "10") else '0';  -- Igualdade
    opt_less  <= '1' when (inputA < inputB) and (selec_op = "11") else '0';  -- Menor que


    with selec_op select
    internal_result <= sum when "00",   -- Se selec_op for "00", seleciona a soma
                    sub when "01",   -- Se selec_op for "01", seleciona a subtração
                    (others => '0') when "10",  -- Para comparação de igualdade
                    (others => '0') when "11",  -- Para comparação de menor que
                    "0000000000000000" when others;  -- Caso contrário, coloca zero

    -- Saída principal
    result <= internal_result;

    -- Flags
    flag_zero     <= '1' when internal_result = 0 else '0';
    flag_negative <= internal_result(15);

    -- Carry e Overflow são válidos apenas para soma e subtração
    carry_aux <= '1' when (selec_op = "00" and sum < inputA) or
                          (selec_op = "01" and inputA < inputB) else '0';

    flag_carry <= carry_aux;

    flag_overflow <= '1' when (selec_op = "00" and inputA(15) = inputB(15) and internal_result(15) /= inputA(15)) or
                              (selec_op = "01" and inputA(15) /= inputB(15) and internal_result(15) /= inputA(15))
                     else '0';

end architecture;
