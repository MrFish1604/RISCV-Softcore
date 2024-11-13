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
        RI_sel: out std_logic;
        loadAcc: out std_logic;
        wr_size: out natural range 0 to N_OP := 0;
        imm_type: out std_logic
    );
    alias funct7: std_logic_vector(6 downto 0) is instr(31 downto 25);
    alias rs2 : std_logic_vector(4 downto 0) is instr(24 downto 20);
    alias rs1 : std_logic_vector(4 downto 0) is instr(19 downto 15);
    alias funct3: std_logic_vector(2 downto 0) is instr(14 downto 12);
    alias rd : std_logic_vector(4 downto 0) is instr(11 downto 7);
    alias opcode : std_logic_vector(6 downto 0) is instr(6 downto 0);

    constant R_TYPE: std_logic_vector(6 downto 0) := "0110011";
    constant I_TYPE: std_logic_vector(6 downto 0) := "0010011";
    constant L_TYPE: std_logic_vector(6 downto 0) := "0000011";
    constant S_TYPE: std_logic_vector(6 downto 0) := "0100011";
end controleur;

architecture rtl of controleur is
begin
    -- RI_sel <= '0' when opcode=R_TYPE else '1' when opcode=I_TYPE or opcode=L_TYPE else 'U';
    RI_sel <= not opcode(5) or not opcode(4); -- '0' if R_TYPE else '1'
    aluOp <= "0000" when opcode=L_TYPE else funct7(5) & funct3 when opcode=R_TYPE else "0" & funct3;
    loadAcc <= '1' when opcode=L_TYPE else '0';
    imm_type <= '1' when opcode=S_TYPE else '0';
    wr_size <= 0 when opcode/=S_TYPE else to_integer(unsigned(funct3))+1 when funct3(1)='0' else 4;
end rtl;
