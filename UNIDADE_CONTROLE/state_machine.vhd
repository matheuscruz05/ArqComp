library ieee;
use ieee.std_logic_1164.all;

entity state_machine is 
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        state   : out std_logic
    );
end entity;

architecture a_state_machine of state_machine is
    signal estado: std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            estado <= '0';
        elsif rising_edge(clk) then
            estado <= not estado; -- alterna entre 0 (fetch) e 1 (decode)
        end if;
    end process;

    state <= estado;

end architecture;
