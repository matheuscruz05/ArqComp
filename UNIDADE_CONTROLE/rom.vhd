library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk:        in std_logic;
        endereco:   in unsigned(6 downto 0);
        dado:       out unsigned(13 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(13 downto 0);
    constant conteudo_rom: mem := (
        0  => "00000000001111",
        1  => "00000000010000",
        2  => "00000000001100",
        3  => "11110000000100",
        4  => "00100000100000",
        5  => "00000000000000",
        6  => "11110000000000",
        7  => "11110000000000",
        8  => "00000000000000",
        9  => "00010010100100",
        10 => "11110000000000",
        others => (others => '0')
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
