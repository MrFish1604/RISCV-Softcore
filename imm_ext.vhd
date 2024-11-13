library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_ext is
    generic
    (
        N: natural := 32;
        IMM_SIZE: natural := 12;
        SHAMT_SIZE: natural := 5
    );
    port
    (
        instr: in std_logic_vector((N-1) downto 0);
        instType: in std_logic;
        immExt: out std_logic_vector((N-1) downto 0)
    );
    alias imm: std_logic_vector((IMM_SIZE-1) downto 0) is instr(31 downto 20);
    alias shamt: std_logic_vector((SHAMT_SIZE-1) downto 0) is instr(24 downto 20);
    alias funct2: std_logic_vector(1 downto 0) is instr(13 downto 12);
    alias imm7: std_logic_vector(6 downto 0) is instr(31 downto 25);
    alias imm5: std_logic_vector(4 downto 0) is instr(11 downto 7);
end imm_ext;

architecture rtl of imm_ext is
begin
    immExt <= std_logic_vector(resize(signed(imm7 & imm5), N)) when instType='1'
        else std_logic_vector(resize(unsigned(shamt), N)) when funct2="01"
        else std_logic_vector(resize(signed(imm), N));

end rtl;
