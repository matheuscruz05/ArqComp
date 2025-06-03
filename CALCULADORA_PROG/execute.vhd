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
        result          : out unsigned(15 downto 0)
    );
end entity;

architecture a_execute of execute is
    
    signal overflow_flag, carry_flag, zero_flag: std_logic;

    component ula is port (
        inputA:              in unsigned(15 downto 0);
        inputB:              in unsigned(15 downto 0);
        operation:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);
        flag_overflow:      out std_logic;
        flag_carry:         out std_logic;
        flag_zero:          out std_logic
    );
    end component;

begin

    ula_uut: ula port map (
        inputA => inputA,
        inputB => inputB,
        operation => operation,
        result => result,
        flag_overflow => overflow_flag,
        flag_carry => carry_flag,
        flag_zero => zero_flag
    );


  
        
       

end architecture;