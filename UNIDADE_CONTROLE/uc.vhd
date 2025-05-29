library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        instr       : in unsigned(13 downto 0);
        pc_wr_en    : out std_logic;
        jump_en     : out std_logic
    );
end entity;

architecture a_uc of uc is
    signal estado  : std_logic := '0';  -- 0 = fetch, 1 = decode
    signal opcode  : unsigned(3 downto 0);
begin

    -- Máquina de estados tipo T
    process(clk, rst)
    begin
        if rst = '1' then
            estado <= '0';
        elsif rising_edge(clk) then
            estado <= not estado;
        end if;
    end process;

    opcode <= instr(13 downto 10);

    -- PC só escreve em estado decode
    pc_wr_en <= estado;

    -- JUMP apenas se opcode = 1111 e em estado decode
    jump_en <= '1' when (estado = '1' and opcode = "1111") else '0';

end architecture;
