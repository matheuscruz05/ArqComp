library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom is
        port (
            clk:        in std_logic;
            endereco:   in unsigned(6 downto 0);
            dado:       out unsigned(13 downto 0)
        );
    end component;

    constant period_time            : time := 100 ns;
    signal finished                 : std_logic := '0';
    signal clk                      : std_logic;
    signal dado                     : unsigned(13 downto 0);
    signal endereco                 : unsigned(6 downto 0);

begin

    uut : rom port map(
        clk => clk,
        endereco => endereco,
        dado => dado
    );

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
        endereco <= "0000000";  wait for 100 ns;
        endereco <= "0000010";  wait for 100 ns;
        endereco <= "0001010";  wait for 100 ns;
        endereco <= "1100010";  wait for 100 ns;
        endereco <= "0001011";  wait for 100 ns;
        endereco <= "1100111";  wait for 100 ns;
        endereco <= "0000001";  wait for 100 ns;
        endereco <= "0000010";  wait;
    end process stim_proc;

end architecture;
