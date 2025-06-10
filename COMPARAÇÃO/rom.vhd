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
                0  => B"0010_0_011_000000",  -- LD R3, 0
                1  => B"0010_0_100_000000",  -- LD R4, 0
                2  => B"0011_1_011_000000",  -- MOV A, R3
                3  => B"0100_1_100_000000",  -- ADD A, R4
                4  => B"0011_0_100_000000",  -- MOV R4,A
                5  => B"0011_1_011_000000",  -- MOV A, R3
                6  => B"0010_0_011_000001",  -- LD R3, 1
                7  => B"0100_1_011_000001",  -- ADD A,R3
                8  => B"0011_0_011_000000",  -- MOV R3,A
                9  => B"0101_1_000_011110",  -- SUBI A,30
                10 => B"1011_0_011_110111",  -- BLO (A < 0),-9(volta 9 endereços) -- BRANCH
                11 => B"1000_0_100_000101",  -- MOV R5,R4
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
