library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
    component pc is 
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            wr_en     : in std_logic;
            data_in   : in unsigned(6 downto 0);
            data_out  : out unsigned(6 downto 0)
        );
    end component;

    constant period_time             : time := 100 ns;
    signal finished                  : std_logic := '0';
    signal clk, rst, wr_en           : std_logic;
    signal data_in, data_out         : unsigned(6 downto 0);

begin

    uut : pc port map(
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en,
        data_in   => data_in,
        data_out  => data_out
    );

    -- Reset por dois ciclos
    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 2;
        rst <= '0';
        wait;
    end process;

    -- Tempo total da simulação
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Geração de clock
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

    -- Estímulos
    stim_proc: process
    begin
        wait for 250 ns; -- após reset
        wr_en <= '1';

        -- Escrita 1
        data_in <= "0000001";
        wait for period_time;

        -- Escrita 2
        data_in <= "0000010";
        wait for period_time;

        -- Escrita 3
        data_in <= "0000011";
        wait for period_time;

        -- Desativa escrita
        wr_en <= '0';
        data_in <= "1111111"; -- dado será ignorado
        wait for period_time * 2;

        -- Reativa escrita
        wr_en <= '1';
        data_in <= "0000100";
        wait for period_time;

        wait;
    end process stim_proc;

end architecture;
