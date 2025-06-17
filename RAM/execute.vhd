library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
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
end entity;

architecture a_execute of execute is
    
    -- Sinais da ULA
    signal overflow_flag_ula, carry_flag_ula, zero_flag_ula : std_logic;

    -- Sinais do CMPI
    signal carry_flag_cmpi, overflow_flag_cmpi, zero_flag_cmpi : std_logic;

    -- Flags selecionadas para saída
    signal carry_selected, zero_selected : std_logic;
    signal wr_flag_mux : std_logic;
    component ula is
        port (
            inputA         : in unsigned(15 downto 0);
            inputB         : in unsigned(15 downto 0);
            selec_op       : in unsigned(1 downto 0);
            result         : out unsigned(15 downto 0);
            flag_overflow  : out std_logic;
            flag_carry     : out std_logic;
            flag_zero      : out std_logic
        );
    end component;

    component ram is port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        wr_en    : in std_logic;
        dado_in  : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0) 
    );
    end component;

    component regsflag is
        port (
            clk        : in std_logic;
            rst        : in std_logic;
            wr_en      : in std_logic;
            data_in    : in std_logic;
            data_out   : out std_logic
        );
    end component;

    component cmpi is
        port (
            clk           : in std_logic;
            rst           : in std_logic;
            wr_en         : in std_logic;
            a_in          : in signed(15 downto 0);
            carry_out     : out std_logic;
            overflow_out  : out std_logic;
            zero_out      : out std_logic
        );
    end component;

begin

    -- ULA
    ula_uut: ula
        port map (
            inputA         => inputA,
            inputB         => inputB,
            selec_op       => operation,
            result         => result,
            flag_overflow  => overflow_flag_ula,
            flag_carry     => carry_flag_ula,
            flag_zero      => zero_flag_ula
        );

    -- CMPI

    ram_uut: ram port map (
        clk         => clk,
        endereco    => endereco_ram,
        wr_en       => wr_ram,
        dado_in     => inputA,
        dado_out    => data_out_ram
    );


    cmpi_uut: cmpi
        port map (
            clk           => clk,
            rst           => rst,
            wr_en         => wr_cmpi,
            a_in          => signed(inputA),  -- converte inputA para signed(15 downto 0)
            carry_out     => carry_flag_cmpi,
            overflow_out  => overflow_flag_cmpi,
            zero_out      => zero_flag_cmpi
        );

    -- Seleção das flags: se wr_cmpi = '1', usa flags da cmpi; senão, da ula
    carry_selected <= carry_flag_cmpi when wr_cmpi = '1' else carry_flag_ula;
    zero_selected  <= zero_flag_cmpi  when wr_cmpi = '1' else zero_flag_ula;
    wr_flag_mux <= wr_flag or wr_cmpi;    
    -- Registro das flags
    regs_carry_flag: regsflag
        port map (
            clk       => clk,
            rst       => rst,
            wr_en     => wr_flag_mux,
            data_in   => carry_selected,
            data_out  => carry_flag
        );

    regs_zero_flag: regsflag
        port map (
            clk       => clk,
            rst       => rst,
            wr_en     => wr_flag_mux,
            data_in   => zero_selected,
            data_out  => zero_flag
        );

   
end architecture;
