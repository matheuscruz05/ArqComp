library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk:        in std_logic;
        endereco:   in unsigned(6 downto 0);
        dado:       out unsigned(13 downto 0);
        rd_rom:     in std_logic
    );
end entity;


-- 0000 NOP
-- 0001 SW
-- 0010 LD
-- 0011 MOV (A,R) or (R,A)
-- 0100 ADD
-- 0101 SUBI
-- 0110 SUB
-- 0111 LW
-- 1000 MOV (R,R)
-- 1001 BEQ
-- 1010 JUMP
-- 1011 BCS
-- 1100 CMPI
-- 1101
-- 1110
-- 1111

architecture a_rom of rom is
     type mem is array (0 to 127) of unsigned(13 downto 0);
      constant conteudo_rom: mem := (
                0   =>  B"0010_0_000_000000", -- LD R0,0     -- R0 = 0
                1   =>  B"0010_0_001_000001", -- LD R1,1     -- R1 = 1
                2   =>  B"0010_0_101_001111", -- LD R5,15    -- R7 = 15
                3   =>  B"0010_0_010_000000", -- LD R2,0     -- POSICAO
                4   =>  B"0010_0_011_000001", -- LD R3,1     -- INCREMENTADOR
                5   =>  B"0011_1_000_000000", -- MOV A,R0
                6   =>  B"0001_1_010_000000", -- SW A,0(R2)  -- armazena valor 1 posição
                7   =>  B"0011_1_001_000000", -- MOV A,R1
                8   =>  B"0001_1_010_000001", -- SW A,1(R2)  -- armazena valor 2 posição
                9   =>  B"1010_0_000_001111", -- JUMP 15

                10  =>  B"0111_1_010_000000", -- LW A,0(R2)
                11  =>  B"0011_0_000_000000", -- MOV R0,A
                12  =>  B"0111_1_010_000001", -- LW A,1(R2)
                13  =>  B"0011_0_001_000000", -- MOV R1,A
                14  =>  B"1010_0_000_010000", -- JUMP 16

                15  =>  B"1010_0_000_001010",
                16  =>  B"0011_1_000_000000", -- MOV A,R0
                17  =>  B"0100_1_001_000000", -- ADD A,R1
                18  =>  B"0001_0_010_000010", -- SW A,2(R2)  -- ARMAZENA O RESULTADO NA MEMORIA
                19  =>  B"0011_1_010_000000", -- MOV A,R2
                20  =>  B"0100_0_011_000000", -- ADD A,R3
                21  =>  B"0011_0_010_000000", -- MOV R2,A
                22  =>  B"1100_0_101_000000", -- CMPi A,R5
                23  =>  B"1011_0_000_110111", -- BCS -9

                24  =>  B"0111_0_011_000000", -- LW A,0(R3) - Vai carregar A = 1
                25  =>  B"0011_0_100_000000", -- MOV R4,A
                26  =>  B"0111_0_011_000100", -- LW A,4(R3)
                27  =>  B"0100_0_100_000000", -- ADD A,R4
                28  =>  B"0111_0_100_000000", -- LW A,0(R4)
                29  =>  B"0001_0_100_011000", -- SW A,24(R4)    
                others => (others => '0')
    );

               
            

begin
    process(clk)
    begin
        if rising_edge(clk) and rd_rom = '1' then  
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
