library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
    port( 
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(13 downto 0);
        rd_rom          : out std_logic;
        wr_pc           : out std_logic;
        jump_en         : out std_logic;
        operation       : out unsigned(1 downto 0);
        inputA           : out unsigned(15 downto 0);
        inputB           : out unsigned(15 downto 0);
        ula_out         : in unsigned(15 downto 0)
    );
end entity;

architecture a_decode of decode is

    component uc is   port (
        clk         : in std_logic;
        rst         : in std_logic;
        instr       : in unsigned(13 downto 0);
        pc_wr_en    : out std_logic;
        jump_en     : out std_logic;
        mov_a_reg       : out std_logic;
        mov_reg_a       : out std_logic;
        op_ula          : out std_logic;
        wr_banco        : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic
    );
    end component;

    component banco_regs is port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(2 downto 0);
        sel_reg:        in unsigned(2 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    component acumulador is port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    signal mov_a_reg, mov_reg_a: std_logic;
    signal banco_out: unsigned(15 downto 0);
    signal data_in_ula: unsigned(15 downto 0);
    signal value_wr_banco: unsigned(15 downto 0);
    signal op_ula : std_logic;
    signal wr_acum, wr_banco : std_logic;
    signal acum_in, acum_out: unsigned(15 downto 0);
    signal is_nop: std_logic;

begin

    uc_uut : uc port map(
        clk => clk,
        rst => rst,
        instr => instruction,
        wr_banco => wr_banco,
        pc_wr_en => wr_pc,
        mov_a_reg => mov_a_reg,
        mov_reg_a => mov_reg_a,
        op_ula => op_ula,
        jump_en => jump_en,
        operation => operation,
        is_nop => is_nop
    );

     value_wr_banco <= acum_out when mov_reg_a = '1' else "0000000000" & instruction(5 downto 0);



    banco_uut : banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => wr_banco,
        data_wr => value_wr_banco,
        reg_wr => instruction(8 downto 6),
        sel_reg => instruction(8 downto 6),
        data_out => banco_out
    );

    acum_in <= banco_out when mov_a_reg = '1' else ula_out;
    wr_acum <= '1' when ((mov_a_reg = '1' or op_ula = '1') and is_nop = '0') else '0';

    acum_uut : acumulador port map (
        clk => clk,
        rst => rst,
        wr_en => wr_acum,
        data_in => acum_in,
        data_out => acum_out
    );

    --entr0 <= acum_out when op_ula = '1' else "0000000000000000";
    --entr1 <= banco_out when op_ula = '1' else "0000000000000000";

    inputA <= acum_out;
    inputB <= banco_out;

end architecture;