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
        op_ula          : out std_logic;
        wr_banco        : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic;
        mov_reg         : out std_logic_vector(2 downto 0);
        jump_abs        : out std_logic;
        op_const        : out std_logic;
        carry_flag      : in std_logic;
        wr_flag         : out std_logic
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
    signal mov_reg_a_s,mov_reg_reg : std_logic;
    signal is_nop_s : std_logic;
    signal bcs: std_logic;
begin

     state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        state => estado
    );


    opcode <= instr(13 downto 10);

    is_nop_s <= '1' when opcode = "0000" and estado = "01" else '0';

     wr_flag <= '1' when ((opcode="0100" or opcode="0101" or opcode="0110" or opcode="1100") and estado="10") else '0';
   
    mov_reg_a_s <= '1' when opcode = "0011" and estado = "01" and instr(9) = '0' and rst = '0' else '0';
    mov_reg_reg <= '1' when estado = "01" and opcode = "1000" else '0';



    -- mov reg -> reg
    mov_reg(0) <= mov_reg_reg;
    -- mov a -> reg
    mov_reg(1) <= mov_reg_a_s;
    -- mov reg -> a
    mov_reg(2) <= '1' when opcode = "0011" and  estado = "01" and instr(9) = '1' else '0';

    
    op_ula <= '1' when estado = "10" and (opcode = "0100" or opcode = "0110" or opcode = "0101") else '0';
    op_const <= '1' when opcode = "0101" else '0';

    wr_banco <= '1' when ((opcode = "0010" and estado = "01" and rst = '0') or mov_reg_a_s = '1' or mov_reg_reg = '1') and is_nop_s = '0' else '0';
    pc_wr_en <= '1' when estado = "00" and rst = '0' else '0';

    bcs <= '1' when (opcode="1011" and carry_flag = '1' and estado="10") else '0';


    jump_abs <= '1' when (estado = "01" and opcode = "1010") else '0';
    jump_en <= '1' when (bcs='1') else '0';


    operation <=    "00" when opcode = "0100" and estado = "10" else -- ADD
                    "01" when opcode = "0110" and estado = "10" else -- SUB
                    "10" when opcode = "0101" and estado = "10" else -- SUBI
                    "11";                                           -- CMPI

    is_nop <= is_nop_s;
    
--IGNORA RESET
end architecture;
