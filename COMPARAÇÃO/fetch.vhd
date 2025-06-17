library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port( 
        clk                 : in std_logic;
        rst                 : in std_logic;
        rd_rom              : in std_logic;
        wr_pc               : in std_logic;
        jump_en             : in std_logic;
        jump_abs            : in std_logic;
        instruction         : out unsigned(13 downto 0)
    );
end entity;

architecture a_fetch of fetch is

    signal data_in_pc                      : unsigned(6 downto 0) := "0000000";
    signal data_out_pc                     : unsigned(6 downto 0);
    signal instruction_s                   : unsigned(13 downto 0);
    signal wr_pc_s                         : std_logic;

    component rom is port (
        clk:        in std_logic;
        endereco:    in unsigned(6 downto 0);
        dado:       out unsigned(13 downto 0)
    );
    end component;

    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
    );
    end component;

    signal inst: unsigned(5 downto 0);
begin

    rom_uut: rom port map (
        clk => clk,
        endereco => data_out_pc,
        dado => instruction_s

    );

    pc_uut: pc port map (
        clk => clk,
        rst => rst,
        wr_en => wr_pc_s,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    instruction <= instruction_s;
    wr_pc_s <= '1' when wr_pc = '1' or jump_en = '1' else '0';
  

    data_in_pc <=   '0' & instruction_s(5 downto 0) when jump_abs='1' else
                    data_out_pc + ('1' & instruction_s(5 downto 0)) when jump_en='1' else 
                    data_out_pc + "0000001";
end architecture;