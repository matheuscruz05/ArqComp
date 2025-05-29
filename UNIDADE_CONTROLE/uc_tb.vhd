library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc is 
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            instr       : in unsigned(13 downto 0);
            pc_wr_en    : out std_logic;
            jump_en     : out std_logic
        );
    end component;

    constant period_time              : time := 100 ns;
    signal finished                   : std_logic := '0';
    signal clk, rst                   : std_logic;
    signal pc_wr_en, jump_en          : std_logic;
    signal instr                      : unsigned(13 downto 0);

begin

    uut : uc port map(
        clk      => clk,
        rst      => rst,
        instr    => instr,
        pc_wr_en => pc_wr_en,
        jump_en  => jump_en
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
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        wait for 200 ns;

        -- NOP (opcode diferente de jump)
        instr <= "00000000000000";
        wait for 200 ns;

        -- JUMP (opcode 1111 nos 4 MSB)
        instr <= "11110000000000";
        wait for 200 ns;

        -- Outra instrução qualquer
        instr <= "11010000110000";
        wait;
    end process stim_proc;

end architecture;
