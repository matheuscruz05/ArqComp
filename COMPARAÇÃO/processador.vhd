library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk                 : in std_logic;
        rst                 : in std_logic
    );
end;

architecture a_processador of processador is
    component fetch is
        port (
            clk                 : in std_logic;
            rst                 : in std_logic;
            rd_rom              : in std_logic;
            wr_pc               : in std_logic;
            jump_en             : in std_logic;
            jump_abs            : in std_logic;
            instruction         : out unsigned(13 downto 0)
        );
    end component;

    component decode is
        port( 
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(13 downto 0);
        rd_rom          : out std_logic;
        wr_pc           : out std_logic;
        jump_en         : out std_logic;
        jump_abs         : out std_logic;
        operation       : out unsigned(1 downto 0);
        inputA           : out unsigned(15 downto 0);
        inputB           : out unsigned(15 downto 0);
        ula_out         : in unsigned(15 downto 0);
        carry_flag      : in std_logic;
        wr_flag         : out std_logic
    );
    end component;
    
    component execute is
        port (
            clk             : in std_logic;
            rst             : in std_logic;
            inputA            : in unsigned(15 downto 0);
            inputB          : in unsigned(15 downto 0);
            operation       : in unsigned(1 downto 0);
            result          : out unsigned(15 downto 0);
            wr_flag         : in std_logic;
            carry_flag      : out std_logic
        );
    end component;

    signal wr_pc, rd_rom            : std_logic;
    signal instruction              : unsigned(13 downto 0);
    signal result                   : unsigned(15 downto 0);
    signal operation                : unsigned(1 downto 0);
    signal inputA , inputB             : unsigned(15 downto 0);
    signal jump_en,carry_flag,wr_flag,jump_abs                  : std_logic;

begin

    fetch_uut : fetch port map(
        clk => clk,
        rst => rst,
        rd_rom => rd_rom,
        wr_pc => wr_pc,
        jump_en => jump_en,
        jump_abs=>jump_abs,
        instruction => instruction
    );

    decode_uut : decode port map(
        clk => clk,
        rst => rst,
        rd_rom => rd_rom,
        wr_pc => wr_pc,
        jump_en => jump_en,
        jump_abs => jump_abs,
        instruction => instruction,
        operation => operation,
        inputA  => inputA ,
        inputB => inputB,
        ula_out => result,
        carry_flag => carry_flag,
        wr_flag => wr_flag
    );

    execute_uut : execute port map(
        clk => clk,
        rst => rst,
        inputA  => inputA ,
        inputB => inputB,
        operation => operation,
        result => result,
        wr_flag => wr_flag,
        carry_flag => carry_flag
    );    

end architecture;