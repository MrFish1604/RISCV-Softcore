library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controleur is
    generic
    (
        N: natural := 32;
        N_OP: natural := 4
    );
    port
    (
        instr: in std_logic_vector((N-1) downto 0);
        load: out std_logic:='0';
        we: out std_logic:='1';
        aluOp: out std_logic_vector((N_OP-1) downto 0);
        RI_sel: out std_logic
    );
    alias funct7: std_logic_vector(6 downto 0) is instr(31 downto 25);
    alias rs2 : std_logic_vector(4 downto 0) is instr(24 downto 20);
    alias rs1 : std_logic_vector(4 downto 0) is instr(19 downto 15);
    alias funct3: std_logic_vector(2 downto 0) is instr(14 downto 12);
    alias rd : std_logic_vector(4 downto 0) is instr(11 downto 7);
    alias opcode : std_logic_vector(6 downto 0) is instr(6 downto 0);

    constant R_TYPE: std_logic_vector(6 downto 0) := "0110011";
    constant I_TYPE: std_logic_vector(6 downto 0) := "0010011";
end controleur;

architecture rtl of controleur is
begin
    RI_sel <= '0' when opcode=R_TYPE else '1' when opcode=I_TYPE else 'U';
    aluOp <= funct7(5) & funct3 when opcode=R_TYPE else "0" & funct3;
end rtl;
