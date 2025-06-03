--************************************
-- Matheus Cruz da Silva - 2306352
-- Gabriel Mororó - 2306298
--************************************


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end;

architecture a_top_level_tb of top_level_tb is
    component top_level is 
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    constant period_time        : time := 100 ns;
    signal finished             : std_logic := '0';
    signal clk, rst             : std_logic;

begin

    uut : top_level port map(
        clk => clk,
        rst => rst
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    stim_proc: process
    begin
        -- Nenhum estímulo adicional é necessário neste testbench
        wait;
    end process stim_proc;

end architecture;
