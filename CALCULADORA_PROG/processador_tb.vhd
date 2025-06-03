library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    constant period_time : time := 100 ns;

    signal clk           : std_logic;
    signal rst           : std_logic;
    signal finished      : std_logic := '0';

    component processador is
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

begin
    uut: processador
        port map(
            clk => clk,
            rst => rst
        );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 100 us;         -- <== TEMPO TOTAL DA SIMULACAO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 200 ns;
        
        wait;
    end process;
end architecture;
