library ieee;
use ieee.std_logic_1164.all;

entity state_machine_tb is
end entity;

architecture a_state_machine_tb of state_machine_tb is
    component state_machine is
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            state   : out std_logic
        );
    end component;

    constant period_time        : time := 100 ns;
    signal finished             : std_logic := '0';
    signal clk, rst, state      : std_logic;

begin

    uut : state_machine port map(
        clk   => clk,
        rst   => rst,
        state => state
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;  -- garante reset nos dois primeiros ciclos
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;          -- tempo total de simulação
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    stim_proc: process
    begin
        wait; -- nada a fazer: a máquina troca de estado sozinha
    end process stim_proc;

end architecture;
