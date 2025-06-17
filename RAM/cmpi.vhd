library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmpi is
    port (
        clk           : in std_logic;
        rst           : in std_logic;
        wr_en         : in std_logic;
        a_in          : in signed(15 downto 0);  -- valor a ser comparado
        carry_out     : out std_logic;
        overflow_out  : out std_logic;
        zero_out      : out std_logic
    );
end entity;

architecture a_cmpi of cmpi is
    constant IMM_VAL : signed(15 downto 0) := to_signed(42, 16);  -- valor imediato
    signal result    : signed(16 downto 0);  -- 1 bit extra para verificar carry
    signal zero_s, carry_s, overflow_s : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            zero_s     <= '0';
            carry_s    <= '0';
            overflow_s <= '0';
        elsif rising_edge(clk) then
            if wr_en = '1' then
                -- operação: a_in - IMM_VAL (extendido para 17 bits)
                result <= ('0' & a_in) - ('0' & IMM_VAL);

                -- flag zero
                if a_in = IMM_VAL then
                    zero_s <= '1';
                else
                    zero_s <= '0';
                end if;

                -- flag carry (em subtração, indica empréstimo)
                if a_in < IMM_VAL then
                    carry_s <= '1';
                else
                    carry_s <= '0';
                end if;

                -- flag overflow (para subtração com sinal)
                if (a_in(15) /= IMM_VAL(15)) and (a_in(15) /= result(15)) then
                    overflow_s <= '1';
                else
                    overflow_s <= '0';
                end if;
            end if;
        end if;
    end process;

    carry_out     <= carry_s;
    overflow_out  <= overflow_s;
    zero_out      <= zero_s;
end architecture;
