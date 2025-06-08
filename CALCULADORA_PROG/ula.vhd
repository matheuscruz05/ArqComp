library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        inputA, inputB : in unsigned(15 downto 0); -- Entradas de 16 bits
        selec_op       : in unsigned(1 downto 0);  -- Seletor da operação
        result         : out unsigned(15 downto 0);-- Saída do resultado
        flag_overflow  : out std_logic;            -- Overflow aritmético
        flag_carry     : out std_logic;            -- Carry
        flag_zero      : out std_logic             -- Z = 1 se resultado = 0
    );
end entity;

architecture a_ula of ula is
    signal sum, sub, comp2         : unsigned(15 downto 0);
    signal internal_result         : unsigned(15 downto 0);
    signal soma_17b, subtracao_17b : unsigned(16 downto 0);
begin

    -- Soma
    sum <= inputA + inputB;

    -- Subtração (complemento de dois)
    comp2 <= not(inputB) + 1;
    sub <= inputA + comp2;

    -- Operações expandidas para cálculo de carry
    soma_17b      <= ('0' & inputA) + ('0' & inputB);
    subtracao_17b <= ('0' & inputA) - ('0' & inputB);

    -- Multiplexador de operação
with selec_op select
    internal_result <= sum            when "00",  -- ADD
                       sub            when "01",  -- SUB
                       (others => '0') when "10",  -- SUBI / CMPI (sem saída)
                       (others => '0') when "11",  -- CMPI
                       (others => '0') when others;


    result <= internal_result;

    -- Zero flag
    flag_zero <= '1' when internal_result = 0 else '0';


    -- Carry flag
    flag_carry <=
        soma_17b(16) when selec_op = "00" else -- ADD
        subtracao_17b(16) when (selec_op = "01" or selec_op = "10" or selec_op = "11") else -- SUB, SUBI, CMPI
        '0';

    -- Overflow flag
    flag_overflow <=
        '1' when (selec_op = "00" and inputA(15) = inputB(15) and internal_result(15) /= inputA(15)) or
              ((selec_op = "01" or selec_op = "10" or selec_op = "11") and inputA(15) /= inputB(15) and internal_result(15) /= inputA(15))
        else '0';

end architecture;