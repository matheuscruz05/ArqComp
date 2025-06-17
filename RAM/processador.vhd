library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk : in std_logic;
        rst : in std_logic
    );
end entity;

architecture a_processador of processador is

    -- Componentes
    component fetch is
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            wr_pc       : in std_logic;
            jump_en     : in std_logic;
            jump_abs    : in std_logic;
            instruction : out unsigned(13 downto 0);
            rd_rom              : in std_logic
        );
    end component;

    component decode is
        port( 
            clk            : in std_logic;
            rst            : in std_logic;
            instruction    : in unsigned(13 downto 0);
            wr_pc          : out std_logic;
            jump_en        : out std_logic;
            jump_abs       : out std_logic;
            operation      : out unsigned(1 downto 0);
            inputA         : out unsigned(15 downto 0);
            inputB         : out unsigned(15 downto 0);
            ula_out        : in unsigned(15 downto 0);
            carry_flag     : in std_logic;
            wr_flag        : out std_logic;
            wr_ram         : out std_logic;
            data_out_ram   : in unsigned(15 downto 0);
            wr_cmpi        : out std_logic;
            zero_flag      : in std_logic;
            bcs            : out std_logic;
            beq            : out std_logic;
            rd_rom         : out std_logic
        );
    end component;

    component execute is
        port( 
            clk             : in std_logic;
            rst             : in std_logic;
            inputA          : in unsigned(15 downto 0);
            inputB          : in unsigned(15 downto 0);
            operation       : in unsigned(1 downto 0);
            result          : out unsigned(15 downto 0);
            wr_flag         : in std_logic;
            carry_flag      : out std_logic;
            zero_flag       : out std_logic;
            wr_cmpi         : in std_logic;
            wr_ram          : in std_logic;
            data_out_ram    : out unsigned(15 downto 0);
            endereco_ram    : in unsigned(6 downto 0)
        );
    end component;

    -- Sinais internos
    signal instruction     : unsigned(13 downto 0);
    signal inputA, inputB  : unsigned(15 downto 0);
    signal result          : unsigned(15 downto 0);
    signal operation       : unsigned(1 downto 0);

    signal wr_pc,rd_rom           : std_logic;
    signal jump_en         : std_logic;
    signal jump_abs        : std_logic;
    signal carry_flag      : std_logic;
    signal zero_flag       : std_logic;
    signal wr_flag         : std_logic;
    signal wr_ram          : std_logic;
    signal wr_cmpi         : std_logic;
    signal i1,i2 :unsigned(5 downto 0);
    signal data_out_ram    : unsigned(15 downto 0);
    signal endereco_ram    : unsigned(6 downto 0);
    signal bcs, beq                 : std_logic;

begin

    -- FETCH
    fetch_uut : fetch
        port map (
            clk         => clk,
            rst         => rst,
            wr_pc       => wr_pc,
            jump_en     => jump_en,
            jump_abs    => jump_abs,
            instruction => instruction,
            rd_rom => rd_rom
        );

    -- DECODE
    decode_uut : decode
        port map (
            clk           => clk,
            rst           => rst,
            instruction   => instruction,
            wr_pc         => wr_pc,
            jump_en       => jump_en,
            jump_abs      => jump_abs,
            operation     => operation,
            inputA        => inputA,
            inputB        => inputB,
            ula_out       => result,
            carry_flag    => carry_flag,
            wr_flag       => wr_flag,
            wr_ram        => wr_ram,
            data_out_ram  => data_out_ram,
            wr_cmpi       => wr_cmpi,
            zero_flag     => zero_flag,
            bcs           => bcs,  -- pode conectar depois
            beq           => beq,
            rd_rom        =>      rd_rom
        );

     i1 <= instruction(5 downto 0);
     i2 <= inputB(5 downto 0);  
    -- ENDEREÇO DA RAM (cálculo simples com base em inputA e instrução)
    endereco_ram <= (instruction(5) & instruction(5 downto 0))+ (inputB(5) & inputB(5 downto 0));

    -- EXECUTE
    execute_uut : execute
        port map (
            clk            => clk,
            rst            => rst,
            inputA         => inputA,
            inputB         => inputB,
            operation      => operation,
            result         => result,
            wr_flag        => wr_flag,
            carry_flag     => carry_flag,
            zero_flag      => zero_flag,
            wr_cmpi        => wr_cmpi,
            wr_ram         => wr_ram,
            data_out_ram   => data_out_ram,
            endereco_ram   => endereco_ram
        );

end architecture;
