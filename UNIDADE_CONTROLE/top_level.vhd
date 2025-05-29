--************************************
-- Matheus Cruz da Silva - 2306352
-- Gabriel Mororó - 2306298
--************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity;

architecture a_top_level of top_level is

    component uc is
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            instr       : in unsigned(13 downto 0);
            jump_en     : out std_logic;
            pc_wr_en    : out std_logic
        );
    end component;

    component rom is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(13 downto 0)
        );
    end component;

    component pc is
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            wr_en     : in std_logic;
            data_in   : in unsigned(6 downto 0);
            data_out  : out unsigned(6 downto 0)
        );
    end component;

    signal pc_out, next_pc, jump_addr : unsigned(6 downto 0);
    signal instr                      : unsigned(13 downto 0);
    signal jump_en, pc_wr_en          : std_logic;

begin

    -- ROM conectada diretamente ao PC
    rom_uut: rom port map (
        clk      => clk,
        endereco => pc_out,
        dado     => instr
    );

    -- UC recebe a instrução e define controle de PC
    uc_uut: uc port map (
        clk      => clk,
        rst      => rst,
        instr    => instr,
        jump_en  => jump_en,
        pc_wr_en => pc_wr_en
    );

    -- PC recebe o próximo endereço
    pc_uut: pc port map (
        clk      => clk,
        rst      => rst,
        wr_en    => pc_wr_en,
        data_in  => next_pc,
        data_out => pc_out
    );

    -- Lógica de próximo PC: ou jump, ou PC+1
    next_pc <= instr(6 downto 0) when jump_en = '1' else
               pc_out + 1;

end architecture;
