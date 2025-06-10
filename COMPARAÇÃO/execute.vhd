library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
    port( 
        clk             : in std_logic;
        rst             : in std_logic;
        inputA          : in unsigned(15 downto 0);
        inputB           : in unsigned(15 downto 0);
        operation       : in unsigned(1 downto 0);
        result          : out unsigned(15 downto 0);
        wr_flag         : in std_logic;
        carry_flag      : out std_logic
    );
end entity;

architecture a_execute of execute is
    
    signal overflow_flag, carry_flag_a, zero_flag: std_logic;

    component ula is port (
        inputA:              in unsigned(15 downto 0);
        inputB:              in unsigned(15 downto 0);
        selec_op:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);
        flag_overflow:      out std_logic;
        flag_carry:         out std_logic;
        flag_zero:          out std_logic
    );
    end component;

    component regsflag is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in std_logic;
        data_out:   out std_logic
    );
    end component;

begin

    ula_uut: ula port map (
        inputA => inputA,
        inputB => inputB,
        selec_op  => operation,
        result => result,
        flag_overflow => overflow_flag,
        flag_carry => carry_flag_a,
        flag_zero => zero_flag
    );


  regs_carry_flag: regsflag port map(
        clk         => clk,
        rst         => rst,
        wr_en       => wr_flag,
        data_in     => carry_flag_a,
        data_out    => carry_flag
    );
        
       

end architecture;