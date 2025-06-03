library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        instr       : in unsigned(13 downto 0);
        pc_wr_en    : out std_logic;
        jump_en     : out std_logic;
        mov_a_reg       : out std_logic;
        mov_reg_a       : out std_logic;
        op_ula          : out std_logic;
        wr_banco        : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic
    );
end entity;

architecture a_uc of uc is

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        state:      out unsigned(1 downto 0)
    );
    end component;

    signal estado  : unsigned(1 downto 0); -- 0 = fetch, 1 = decode
    signal opcode  : unsigned(3 downto 0);
    signal mov_reg_a_s : std_logic;
    signal is_nop_s : std_logic;
begin

     state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        state => estado
    );


    opcode <= instr(13 downto 10);

    -- JUMP apenas se opcode = 1111 e em estado decode
    is_nop_s <= '1' when opcode = "0000" and estado = "01" else '0';


    mov_a_reg <= '1' when opcode = "0011" and estado = "01" and instr(9) = '1' and rst = '0' else '0';
    mov_reg_a_s <= '1' when opcode = "0011" and estado = "01" and instr(9) = '0' and rst = '0' else '0';
    mov_reg_a <= mov_reg_a_s;

    op_ula <= '1' when (opcode = "0100" and estado = "10") or (opcode = "0110" and estado = "10") else '0';

    wr_banco <= '1' when ((opcode = "0010" and estado = "01" and rst = '0') or mov_reg_a_s = '1') and is_nop_s = '0' else '0';
    pc_wr_en <= '1' when estado = "00" and rst = '0' else '0';

    jump_en <= '1' when opcode = "1010" and estado = "01" else '0';

    operation <=    "00" when opcode = "0100" and estado = "10" else -- ADD
                    "01" when opcode = "0110" and estado = "10" else -- SUB
                    "10" when opcode = "0101" and estado = "10" else -- SUBI
                    "11";                                           -- CMPR

    is_nop <= is_nop_s;

end architecture;
